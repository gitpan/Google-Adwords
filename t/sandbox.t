#!/usr/bin/perl
use strict; use warnings;

use Test::More qw/ no_plan /;
use IO::Prompt;

use lib 't/lib';
use InfoService;
use CampaignService;

my $i;

# check if user wants to run sandbox tests
my $answer = prompt "Do you want to run sandbox tests? (y/n): ";

if ($answer ne 'y') {
    ok (1 == 1);
    exit;
}


$i = InfoService->new({sandbox => 1});
$i->runtests();

$i = CampaignService->new({sandbox => 1});
$i->runtests();

