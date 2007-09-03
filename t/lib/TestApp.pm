package TestApp;
use strict;
use warnings;

use Catalyst qw/ConfigClass/;

__PACKAGE__->config(key => 'value');

if ($main::use_class) {
    __PACKAGE__->config->{'Plugin::ConfigClass'} = 'TestApp::Config';
}
else {
    require TestApp::Config;
    __PACKAGE__->config('Plugin::ConfigClass' => 
                        TestApp::Config->new(__PACKAGE__->config));
}
__PACKAGE__->setup;

1;
