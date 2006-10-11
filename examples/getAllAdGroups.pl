#!/usr/bin/perl
use strict; use warnings;

use Google::Adwords::AdGroupService;

# your adwords login email
my $email = '';

# your password
my $password = '';

# your developer token
my $dev_token = '';

# your application token
my $app_token = '';

# your client email if you use a MCC
my $client_email = '';


my $service = Google::Adwords::AdGroupService->new();

$service->email($email)
        ->password($password)
        ->developerToken($dev_token)
        ->applicationToken($app_token)
;

# debug
$service->debug(1);

# client email
if ((defined $client_email) && ($client_email ne '')) {
    $service->clientEmail($client_email);
}

# get adgroups belonging to this campaign
my $campaign_id = '';

my @adgroups = $service->getAllAdGroups($campaign_id);

print "units consumed: " . $service->units . "\n";
print "number of adgroups: " . scalar @adgroups . "\n";

for (@adgroups) {
    print "ID: " . $_->id . "\n";
    print "\tName: " . $_->name . "\n";
}

