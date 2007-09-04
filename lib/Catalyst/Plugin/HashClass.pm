package Catalyst::Plugin::HashClass;
use strict;
use warnings;
use NEXT;
use Catalyst::Utils;

our $VERSION = '0.02';

use base 'Class::Data::Inheritable';

=head1 NAME

Catalyst::Plugin::HashClass - use a class to back C<< $c->* >>

=head1 SYNOPSIS

This module can make C<< $c->config >> or C<< $c->stash >> a real
object instead of just a hash.  This is good for creating a config
class that can load itself from a file and be used both inside and
outside of Catalyst.

Assuming your app is called MyApp, set up your config (etc.) object:

  package MyApp::Config;
  use base 'Catalyst::Component'; # if you want, not required

  sub COMPONENT {
     my ($class, $app, $original_config) = @_;
     return bless $original_config => $class;
  }
  # you can also implement ACCEPT_CONTEXT if you need $c!

My gut tells me that if your config class needs C<$c>, you're doing
something seriously wrong.  But TMTOWTDI, so whatever.

Once you have a class that can load the config, just tell Catalyst to
use this class as your config:

  package MyApp;
  use Catalyst qw/... HashClass .../;
  MyApp->config->{Plugin::HashClass}   = { config => 'MyApp::Config'};
  # or
  # MyApp->config->{Plugin::HashClass} = { config => Some::Config->new };

  MyApp->setup;

  # now $c->config returns an instance of C<MyApp::Config>, optionally
  # calling ACCEPT_CONTEXT each time you ask for it

=head1 WHY

The main idea is so that you can have a C<MyApp::Config> class that
works the same inside and outside of Catalyst.  You can also use the
class to massage the config data from something that looks good in the
config file to something that the rest of Catalyst understands.

You aren't limited to just changing the C<config> object, though, you
can also change the stash or even add methods:

   MyApp->config->{Plugin::HashClass} = { stash => 'MyApp::Stash' };

Now C<< $c->stash >> will return a C<MyApp::Stash>, not an unblessed
hash.  This could be good; you can have accessors for your hash keys:

   package MyApp::Stash;
   use base 'Class::Accessor';
   __PACKAGE__->mk_accessors(qw/foo bar baz/);
   1;

Then in your app:

  sub some_action :Local {
      my ($self, $c) = @_;
      $c->stash->foo('this is foo');
  }

It's up to you to decide what to do.  I have some uses for this;
they'll be on the CPAN shortly :)

=head1 METHODS

=head2 setup

Called at setup time, obviously.  It loads your classes at this point
-- everything before C<HashClass> sees the method calls return their
usual hashes, everything after this is called sees them as your
configured class.  If something bad happens, your app will die right
here.

Reads the method => class mapping as an anonymous hash from
C<< YourApp->config->{Plugin::HashClass} >>.

=cut

sub setup {
    my $app = shift;
    
    my $config = $app->config;

    my %def = %{$config->{'Plugin::HashClass'} || {}};
    delete $config->{'Plugin::HashClass'};
    
    foreach my $method (keys %def) {
        my $class = $def{$method};
        if ($class){
            my $accessor = "_${method}_class";
            __PACKAGE__->mk_classdata($accessor);
            
            if (!ref $class) {
                Catalyst::Utils::ensure_class_loaded($class);
                $app->$accessor($class->COMPONENT($app, $config));
            }
            else {
                $app->$accessor($class);
            }
            
            _mk_replacement_for($method);
        }
    }
    
    return $app->NEXT::setup(@_);
}

sub _mk_replacement_for {
    my $method = shift;
    
    no strict 'refs';
    
    *{$method} = sub {
        my $c = shift;
        
        my $accessor = "_${method}_class";
        if (my $obj = $c->$accessor){
            if ($obj->can('ACCEPT_CONTEXT')) {
                return $obj->ACCEPT_CONTEXT($c);
            }
            return $obj;
        }
        
        my $next = "NEXT::$method";
        return $c->$next(@_);
    };
}

=head1 BUGS

Consider this an experiment.  Your feedback is welcome.

=head1 AUTHOR

Jonathan Rockway C<< jrockway@cpan.org >>

=head1 COPYRIGHT

Same as Perl itself, yada yada yada.

=cut

1;
