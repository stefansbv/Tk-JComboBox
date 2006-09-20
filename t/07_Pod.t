use strict;
use Test::More;

eval "use Test::Pod";
plan skip all => "Test::Pod required for testing POD" if $@;
my @poddirs = qw( blib script );
all_pod_files_ok( all_pod_files( @poddirs ));