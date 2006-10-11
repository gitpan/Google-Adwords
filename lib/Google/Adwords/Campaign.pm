package Google::Adwords::Campaign;
use strict; use warnings;

use version; our $VERSION = qv('0.0.2');

use base 'Google::Adwords::Data';

my @fields = qw/
    dailyBudget
    enableSeparateContentBids
    id
    name
    status
    startDay
    endDay
    languageTargeting
    geoTargeting
    networkTargeting
/;

__PACKAGE__->mk_accessors(@fields);

1;

=pod

=head1 NAME
 
Google::Adwords::Campaign - A Google Adwords Campaign Object
 
 
=head1 VERSION
 
This documentation refers to Google::Adwords::Campaign version 0.0.2
 
 
=head1 SYNOPSIS
 
    use Google::Adwords::Campaign;
    use Google::Adwords::CampaignService;

    # create a new campaign object
    my $campaign = Google::Adwords::Campaign;

    # set values for the campaign object
    $campaign->name('My Final Try');
    $campaign->dailyBudget(10000000);

    # target a certain city in US
    $campaign->geoTargeting({
       cities => [ 'Pelican, AK US' ], 
    });
  
    # create the campaign service object
    my $campaign_service = Google::Adwords::CampaignService->new();

    # need to login to the Adwords service
    $campaign_service->email($email_address)
                     ->password($password)
                     ->developerToken($developer_token)
                     ->applicationToken($application_token);

    # if you use a MCC
    $campaign_service->clientEmail($client_email);

    # now create the campaign
    my $campaign_response = $campaign_service->addCampaign($campaign);

    print "New campaign ID is :" . $campaign_response->id;
 
  
=head1 DESCRIPTION
 
This object should be used with the CampaignService API calls
 
 
=head1 METHODS 
 
B<Mutators (read/write)>

* dailyBudget

* enableSeparateContentBids

* name

* status

* startDay

* endDay

* languageTargeting

* geoTargeting

* networkTargeting

 
B<Accessors (read only)>

* id

 
The following methods accept/return a hashref

B<languageTargeting()>

=over 4

A hashref with keys:

* languages - An arrayref of language codes

Example usage:

    # set English and Hindi as my language targets
    $campaign->languageTargeting({
        languages => [ 'en', 'hi' ],
    });

The language codes are available here:

http://www.google.com/apis/adwords/developer/adwords_api_languages.html


=back

B<geoTargeting()>

=over 4

A hashref with keys:

* countries - An arrayref of country codes

* regions - An arrayref of region codes

* cities - An arrayref of city codes

* metros - An arrayref of metro codes


Example usage:

    # Set target countries as US and India
    $campaign->geoTargeting({
        countries => [ 'US', 'IN' ],
    });

    # Only target Adelaide in Australia
    $campaign->geoTargeting({
        cities => [ 'Adelaide, SA AU' ],
    });

    # By region, target Berlin in Germany
    $campaign->geoTargeting({
        regions => [ 'DE-BE' ],
    });

    # By metros, target Los Angeles
    $campaign->geoTargeting({
        metros => [ '803' ],
    });


The codes are available here:

countries - 

http://www.google.com/apis/adwords/developer/adwords_api_countries.html

regions - 

http://www.google.com/apis/adwords/developer/adwords_api_regions.html

cities (outside the US) - 

http://www.google.com/apis/adwords/developer/adwords_api_cities.html

cities (in the US) - 

http://www.google.com/apis/adwords/developer/adwords_api_us_cities.html

metros (in the US) - 

http://www.google.com/apis/adwords/developer/adwords_api_us_metros.html


From the Adwords website:

=over 4

You can target campaigns by cities, countries, metros, and regions. However, a
single campaign can only target one geographic area. For example, you can
target a campaign by countries or regions, but not both. You can specify
multiple values within a single type of geographic area. For example, you
could target a campaign by more than one country.


=back

More info is here:

http://www.google.com/apis/adwords/developer/adwords_api_geotarget.html


=back

B<networkTargeting()>

=over 4

A hashref with keys:

* networkTypes => arrayref of network names

Exmaple usage:
    
    # target only the google search network
    $campaign->networkTargeting({
        networkTypes => [ 'GoogleSearch' ],
    });


The network types are:

* GoogleSearch

* SearchNetwork

* ContentNetwork


From the Adwords website:

=over 4

When creating a new campaign, if no targeting is specified, the default
targeting is GoogleSearch. SearchNetwork encompasses GoogleSearch, so
GoogleSearch need not be specified when this value is included.

=back

More info is here:

http://www.google.com/apis/adwords/developer/NetworkTarget.html


=back

=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::CampaignService>

=back



=head1 AUTHOR
 
Rohan Almeida <rohan@almeida.in>

 
 
=head1 LICENCE AND COPYRIGHT
 
Copyright (c) 2006 Rohan Almeida <rohan@almeida.in>. All rights
reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

