#!/usr/bin/perl
use strict; use warnings;

use lib 'lib';
use Google::Adwords::InfoService;

my $email = '';
my $password = '';
my $token = '';

my $ginfo = Google::Adwords::InfoService->new();

$ginfo
    ->email($email)
    ->password($password)
    ->token($token)
#    ->use_sandbox(1)
;

my $quota = $ginfo->getUsageQuotaThisMonth;
print "usage quota this month is $quota\n";

