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

# skip the sandbox tests for "make test".
# if you want to run the sandbox tests, comment out the following 
# two lines, and fill in your login details below that
ok( 1 == 1 );
exit;

# test values during development
my $email = '';
my $password = '';
my $currency = 'INR';
my $client_num = '2';

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

