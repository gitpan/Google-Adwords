#!/usr/bin/perl
use strict; use warnings;

use Test::More qw/ no_plan /;
use IO::Prompt;

use lib 't/lib';
use InfoService;
use CampaignService;
use AdGroupService;
use AccountService;
use CreativeService;

my $i;

# check if user wants to run sandbox tests
my $answer = prompt "Do you want to run sandbox tests? (y/n): ";

if ($answer ne 'y') {
    ok (1 == 1);
    exit;
}

my $email = prompt "Your gmail address: ";
my $password = prompt "Your password: ";
my $currency = prompt "Your currence code (3 digit): ";
$email = $email->{value};
$password = $password->{value};
$currency = $currency->{value};

my $params_ref = {
    sandbox => 1,
    email => $email,
    password => $password,
    developerToken => $email. '++' . $currency,
};


$i = InfoService->new($params_ref);
$i->runtests();

$i = CampaignService->new($params_ref);
$i->runtests();

$i = AdGroupService->new($params_ref);
$i->runtests();

$i = AccountService->new($params_ref);
$i->runtests();

$i = CreativeService->new($params_ref);
$i->runtests();

