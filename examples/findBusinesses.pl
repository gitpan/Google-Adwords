#!/usr/bin/perl
use strict; use warnings;

use Google::Adwords::AdService;

# your adwords login email
my $email = '';

# your password
my $password = '';

# your developer token
my $dev_token = $email . '++INR';

# your application token
my $app_token = '';

# your client email if you use a MCC
my $client_email = 'client_2+' . $email;


my $service = Google::Adwords::AdService->new();

$service->email($email)
        ->password($password)
        ->developerToken($dev_token)
        ->applicationToken($app_token)
;

# debug
$service->debug(0);

# client email
if ((defined $client_email) && ($client_email ne '')) {
    $service->clientEmail($client_email);
}


my @businesses = $service->findBusinesses({
    name        => 'Google',
    address     => 'Mountain',
    countryCode => 'US',
});

for (@businesses) {
    print "Name: " . $_->name . "\n";
    print "Phone: " . $_->phoneNumber . "\n";
}

