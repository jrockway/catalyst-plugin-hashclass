# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

package TestApp::Model::Foo;
use strict;
use warnings;

use base 'Catalyst::Model';

sub data {
    my ($self) = @_;
    return $self->{data};
}

1;
