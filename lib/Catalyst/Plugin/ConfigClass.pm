package Catalyst::Plugin::ConfigClass;
use strict;
use warnings;
use NEXT;
use Catalyst::Utils;

our $VERSION = '0.01';

use base 'Class::Data::Inheritable';
__PACKAGE__->mk_classdata(qw/_config_class/);

=head1 NAME

Catalyst::Plugin::ConfigClass - use a class to store C<< $c->config >>
instead of a plain hash

=head1 SYNOPSIS

  package MyApp::Config;
  use base 'Catalyst::Component'; # if you want, not required

  sub COMPONENT {
     my ($class, $app, $args) = @_;
     return bless $args => $class;
  }
  # you can also implement ACCEPT_CONTEXT if you need $c!

  package MyApp;
  use Catalyst qw/... ConfigClass .../;
  MyApp->config->{Plugin::ConfigClass} = 'MyApp::Config';
  # or
  # MyApp->config->{Plugin::ConfigClass} = Some::Config->new;

  MyApp->setup;

  # now $c->config returns an instance of C<MyApp::Config>, optionally
  # calling ACCEPT_CONTEXT each time you ask for it

=head1 WHY

The main idea is so that you can have a C<MyApp::Config> class that
works the same inside and outside of Catalyst.  You can also use the
class to massage the config data from something that looks good in the
config file to something that the rest of Catalyst understands.

=head1 METHODS

=head2 setup

Called at setup time, obviously.  It loads your config class at this
point -- everything before C<ConfigClass> sees config as a hash,
everything after sees it as your class.  If something bad happens,
your app will die right here.

=head2 config

This method will work as usual until C<setup> is run.  After that, it
will return the value of C<Plugin::ConfigClass> or an instance of it.

=cut

sub setup {
    my $app = shift;
    
    my $config = $app->config;
    my $class  = delete $config->{'Plugin::ConfigClass'};
    
    if ($class){
        if (!ref $class) {
            Catalyst::Utils::ensure_class_loaded($class);
            $app->_config_class($class->COMPONENT($app, $config));
        }
        else {
            $app->_config_class($class);
        }
    }

    return $app->NEXT::setup(@_);
}

sub config {
    my $c = shift;

    if ($c->_config_class){
        my $config = $c->_config_class;

        if ($config->can('ACCEPT_CONTEXT')) {
            return $config->ACCEPT_CONTEXT($c);
        }
        return $config;
    }

    # if there's no _config_class, behave normally
    return $c->NEXT::config(@_);
}

=head1 TODO

I'm going to replace this with something more generic soon.  Consider
this an experiment.

=head1 AUTHOR

Jonathan Rockway C<< jrockway@cpan.org >>

=head1 COPYRIGHT

Same as Perl itself, yada yada yada.

=cut

1;
