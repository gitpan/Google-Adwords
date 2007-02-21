#!/usr/bin/perl
use strict; use warnings;

use Google::Adwords::AccountService;

# Initialize client accounts in the sandbox

my $email = '';
my $password = '';
my $currency = '';
my $client_num = '1';

my $service = Google::Adwords::AccountService->new();

# login
$service->email($email)
        ->password($password)
        ->developerToken($email. '++' . $currency)
        ->use_sandbox(1)
        ->debug(1)
;

my @emailaccounts = $service->getClientAccounts();


