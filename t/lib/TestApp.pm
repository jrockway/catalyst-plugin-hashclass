package TestApp;
use strict;
use warnings;

use Catalyst qw/ConfigClass/;

__PACKAGE__->config(key => 'value');
__PACKAGE__->config->{'Plugin::ConfigClass'} = 'TestApp::Config';
__PACKAGE__->setup;

1;
