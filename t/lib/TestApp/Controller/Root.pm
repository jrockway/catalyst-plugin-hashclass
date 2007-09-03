package TestApp::Controller::Root;
use strict;
use warnings;

__PACKAGE__->config(namespace => q{});

use base 'Catalyst::Controller';

# your actions replace this one
sub main :Path { $_[1]->res->body('<h1>It works</h1>') }

sub foo :Local {
    $_[1]->response->body($_[1]->config->foo);
}

sub key :Local {
    $_[1]->response->body($_[1]->config->{key});
}

sub key_accessor :Local {
    $_[1]->response->body($_[1]->config->key);
}

sub model_config :Local {
    my ($self, $c) = @_;
    $c->res->body($c->model('Foo')->data); # data from config class
}

sub context :Local {
    my $called = 0;
    *TestApp::Config::ACCEPT_CONTEXT = sub {
        $called++;
        return $_[0];
    };
    my $config = $_[1]->config; # calls above
    $_[1]->response->body($called); # should be 1
}

sub stash_accessors :Local {
    my ($self, $c) = @_;
    
    $c->stash->foo('This appears to have worked.');
    $c->res->body($c->stash->{foo});
}

1;
