# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

package TestApp::Config;
use strict;
use warnings;

use base 'Class::Accessor';
__PACKAGE__->mk_accessors(qw/key/);

sub COMPONENT {
    my ($class, $app, $config) = @_;
    return $class->new($config);
}

sub foo {
    return 'foo';
}

1;
