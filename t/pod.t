#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
eval "use Test::Pod";
plan skip_all => "Test::Pod required for testing POD" if $@;

my @pod_dirs = qw( lib );
all_pod_files_ok( all_pod_files(@pod_dirs) );

