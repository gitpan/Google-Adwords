package Google::Adwords;
use strict; use warnings;

use version; our $VERSION = qv('0.1');

1;

=pod

=head1 NAME
 
Google::Adwords - an interface which abstracts the Google Adwords SOAP API
 
 
=head1 VERSION
 
This documentation refers to Google::Adwords version 0.1
 
 
=head1 SYNOPSIS
 
    use Google::Adwords::CampaignService;
    use Google::Adwords::Campaign;

    my $service = Google::Adwords::CampaignService->new();

    $service->email('email@domain.com')
            ->password('password')
            ->token('developer_token');

    # if you use a MCC
    #$service->clientEmail('clientemail@domain.com');

    # if you want SOAP trace output
    #$service->debug(1);

    # create a campaign object
    my $campaign = Google::Adwords::Campaign->new();

    # fill in your campaign details
    $campaign->name('my campaign #1')
             ->dailyBudget(100000)
             ->status('Paused');

    # add the campaign
    my $campaign_response = $service->addCampaign($campaign);

    # ID of new campaign
    my $campaign_id = $campaign_response->id;
    
  
=head1 DESCRIPTION
 
This collection of modules under Google::Adwords provides an easy 
to use object oriented interface to the Google Adwords SOAP API. 
You don't need to understand SOAP or web services to use this module.

* Base Service Class - L<Google::Adwords::Service>

Read the manual page for this module in order to see how to setup your
authentication details and other options available

Each API Service belongs to a particular module.

* CampaignService   - L<Google::Adwords::CampaignService>

* InfoService       - L<Google::Adwords::InfoService>
 

Some services like the CampaignService need to deal with complex data 
types which are available as objects.

* Campaign          - L<Google::Adwords::Campaign>

* StatsRecord       - L<Google::Adwords::StatsRecord>   

Please read the documentation for the above modules.
 
=head1 DEPENDENCIES
 
* SOAP::Lite
 
=head1 THANKS

* The Yahoo::Marketing module on which this module draws heavily from

* betonmarkets.com - For the initial requirement and funding


=head1 AUTHORS
 
Rohan Almeida <rohan@almeida.in>

Mathieu Jondet <mathieu@eulerian.com>
 
 
=head1 LICENCE AND COPYRIGHT
 
Copyright (c) 2006 Rohan Almeida <rohan@almeida.in>. All rights
reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

