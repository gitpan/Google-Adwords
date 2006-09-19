#!/usr/bin/perl
use strict; use warnings;

use Google::Adwords::CampaignService;

# your adwords login email
my $email = '';

# your password
my $password = '';

# your developer token
my $token = '';

# your client email if you use a MCC
my $client_email = '';

my $service = Google::Adwords::CampaignService->new();

$service->email($email)
        ->password($password)
        ->token($token)
;

# debug
$service->debug(1);

# client email
if ((defined $client_email) && ($client_email ne '')) {
    $service->clientEmail($client_email);
}

my $campaign_id_1;
my $campaign_id_2;

my @stats = $service->getCampaignStats({
    campaignids => [ $campaign_id_1, $campaign_id_2 ],
    startDay => '2006-08-01',
    endDay => '2006-08-31',
    inPST => 1,
});

for (@stats) {
    print "Campaign ID: " . $_->id . "\n";
    print "\tClicks: " . $_->clicks . "\n";
    print "\tConversions: " . $_->conversions . "\n";
}

