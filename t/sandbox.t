#!/usr/bin/perl
use strict;
use warnings;

use Test::More qw/ no_plan /;
use IO::Prompt;

use lib 't/lib';
use InfoService;
use CampaignService;
use AdGroupService;
use AccountService;
use AdService;
use ReportService;
use TrafficEstimatorService;
use CriterionService;
use KeywordToolService;

# which test modules should we run
my @modules = (
    { InfoService             => 1, },
    { CampaignService         => 1, },
    { AdGroupService          => 1, },
    { AccountService          => 1, },
    { AdService               => 1, },
    { ReportService           => 1, },
    { TrafficEstimatorService => 1, },
    { CriterionService        => 1, },
    { KeywordToolService      => 1, },
);

# check if user wants to run sandbox tests
my $answer = prompt "Do you want to run the sandbox tests? (y/n): ";

if ( $answer ne 'y' ) {
    ok( 1 == 1 );
    exit;
}

my $email      = prompt "Your gmail address: ";
my $password   = prompt "-e", '*', "Your password: ";
my $currency   = prompt "Your currence code (3 digit): ";
my $client_num = prompt "Which client email number to use (1,2,3,4,5): ";
$email      = $email->{value};
$password   = $password->{value};
$currency   = $currency->{value};
$client_num = $client_num->{value};

# test values during development
#my $email = '';
#my $password = '';
#my $currency = '';
#my $client_num = '1';

my $params_ref = {
    sandbox        => 1,
    debug          => 0,
    email          => $email,
    password       => $password,
    developerToken => $email . '++' . $currency,
    clientEmail    => 'client_' . $client_num . '+' . $email,
};

for (@modules) {
    my ($key) = keys %{$_};
    if ( $_->{$key} == 1 ) {
        my $i = $key->new($params_ref);
        $i->runtests();
    }
}

