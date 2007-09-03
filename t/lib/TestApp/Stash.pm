# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

package TestApp::Stash;
use strict;
use warnings;

use base 'Class::Accessor';
__PACKAGE__->mk_accessors(qw/foo bar baz/);

1;
