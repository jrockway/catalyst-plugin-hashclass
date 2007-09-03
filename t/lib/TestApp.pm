package TestApp;
use strict;
use warnings;

use TestApp::Stash;
use Catalyst qw/HashClass/;

__PACKAGE__->config(key => 'value');

__PACKAGE__->config->{'Plugin::HashClass'}{stash} = TestApp::Stash->new;

if ($main::use_class) {
    __PACKAGE__->config->{'Plugin::HashClass'}{config} = 
      'TestApp::Config';
}
else {
    require TestApp::Config;
    __PACKAGE__->config->{'Plugin::HashClass'}{config} = 
      TestApp::Config->new(__PACKAGE__->config);
}
__PACKAGE__->setup;

1;
