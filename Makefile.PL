use inc::Module::Install;

my $module = 'Catalyst::Plugin::HashClass';

my $dist   = $module;
$dist =~ s/::/-/g;
name($dist);

my @path = split '::', $module;
all_from('lib/'. (join '/',@path). '.pm');

requires 'Catalyst::Utils';
requires 'NEXT';
requires 'Class::Data::Inheritable';

build_requires 'Class::Accessor';
build_requires 'Catalyst::Runtime';
build_requires 'Test::More';
build_requires 'ok';

WriteAll();
