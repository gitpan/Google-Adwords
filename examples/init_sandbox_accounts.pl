#!/usr/bin/perl
use strict; use warnings;

use lib 'lib';
use Google::Adwords::AccountService;

# Initialize client accounts in the sandbox

my $email = '';
my $password = '';
my $currency = 'INR';

my $service = Google::Adwords::AccountService->new();

# login
$service->email($email)
        ->password($password)
        ->developerToken($email. '++' . $currency)
        #->api_version('v7')
        ->use_sandbox(1)
        ->debug(1)
;

my @emailaccounts = $service->getClientAccounts();


