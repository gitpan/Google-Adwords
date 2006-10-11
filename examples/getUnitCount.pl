#!/usr/bin/perl
use strict; use warnings;

use Google::Adwords::InfoService;


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

my $service = Google::Adwords::InfoService->new();

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


my $count = $service->getUnitCount({
    startDate => '2006-09-01',
    endDate => '2006-09-15',
});
;
print "unit count is $count\n";

