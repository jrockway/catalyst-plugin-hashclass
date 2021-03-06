#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 13;

# setup library path
use FindBin qw($Bin);
use lib "$Bin/lib";

our $use_class;
BEGIN { $use_class = 1 };

# make sure testapp works
use ok 'TestApp';

# a live test against TestApp, the test application
use Test::WWW::Mechanize::Catalyst 'TestApp';
my $mech = Test::WWW::Mechanize::Catalyst->new;

$mech->get_ok('http://localhost/foo');
$mech->content_like(qr/foo/);

$mech->get_ok('http://localhost/key');
$mech->content_like(qr/value/);

$mech->get_ok('http://localhost/key_accessor');
$mech->content_like(qr/value/);

$mech->get_ok('http://localhost/model_config');
$mech->content_like(qr/Foo Model/);

$mech->get_ok('http://localhost/context');
$mech->content_like(qr/1/);

$mech->get_ok('http://localhost/stash_accessors');
$mech->content_like(qr/This appears to have worked/);
