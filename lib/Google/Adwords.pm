package Google::Adwords;
use strict;
use warnings;

use version; our $VERSION = qv('1.3.1');

1;

=pod

=head1 NAME
 
Google::Adwords - an interface which abstracts the Google Adwords SOAP API
 
 
=head1 VERSION
 
This documentation refers to Google::Adwords version 1.3.1
 

=head1 API VERSION

Google::Adwords currently uses version 9 (v9) of the Adwords API which is the
default. You can also opt to use version 8 if you wish. Just set the api_version() in
your *Service objects to 'v8'. 

    # use v8 of the Adwords API
    $campaign_service->api_version('v8');

 
=head1 SYNOPSIS
 
    use Google::Adwords::CampaignService;
    use Google::Adwords::Campaign;

    # create the service
    my $service = Google::Adwords::CampaignService->new();

    # login details
    $service->email('email@domain.com')
            ->password('password')
            ->developerToken($developer_token)
            ->applicationToken($app_token);

    # if you use a MCC
    #$service->clientEmail('clientemail@domain.com');
    # or (but not both)
    #$service->clientCustomerId('xxx-xxx-xxxx');

    # To use an earlier version of the Adwords API
    #$service->api_version('v8');

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
    
    # time taken for the API call 
    my $response_time = $service->responseTime;

    # quota units consumed
    my $units_consumed = $service->units;

  
=head1 DESCRIPTION
 
This collection of modules under Google::Adwords provides an easy 
to use object oriented interface to the Google Adwords SOAP API. 
You don't need to understand SOAP or web services to use this module.

=over

* Base Service Class        -   L<Google::Adwords::Service>

=back

Read the manual page for this module in order to see how to setup your
authentication details and other options available

B<Each API Service belongs to a module of the same name as the service>

=over

* CampaignService           -   L<Google::Adwords::CampaignService>

* InfoService               -   L<Google::Adwords::InfoService>
 
* AdGroupService            -   L<Google::Adwords::AdGroupService>

* AccountService            -   L<Google::Adwords::AccountService>

* AdService                 -   L<Google::Adwords::AdService>

* ReportService             -   L<Google::Adwords::ReportService>

* TrafficEstimatorService   -   L<Google::Adwords::TrafficEstimatorService>

* CriterionService          -   L<Google::Adwords::CriterionService>

* KeywordToolService        -   L<Google::Adwords::KeywordToolService>

=back


B<Many services need to deal with complex data types which are available as objects>

=over

* Campaign                  -   L<Google::Adwords::Campaign>

* AdSchedule                -   L<Google::Adwords::AdSchedule>

* SchedulingInterval        -   L<Google::Adwords::SchedulingInterval>

* BudgetOptimizerSettings   -   L<Google::Adwords::BudgetOptimizerSettings>

* StatsRecord               -   L<Google::Adwords::StatsRecord>   

* AdGroup                   -   L<Google::Adwords::AdGroup>   

* ClientUsageRecord         -   L<Google::Adwords::ClientUsageRecord>

* AccountInfo               -   L<Google::Adwords::AccountInfo>

* EmailPromotionsPreferences    - L<Google::Adwords::EmailPromotionsPreferences>

* Address                   -   L<Google::Adwords::Address>

* CoverageType              -   L<Google::Adwords::CoverageType>

* CreditCard                -   L<Google::Adwords::CreditCard>

* Creative                  -   L<Google::Adwords::Creative>

* Image                     -   L<Google::Adwords::Image>

* ReportJob                 -   L<Google::Adwords::ReportJob>

* KeywordRequest            -   L<Google::Adwords::KeywordRequest>

* KeywordEstimate           -   L<Google::Adwords::KeywordEstimate>

* AdGroupRequest            -   L<Google::Adwords::AdGroupRequest>

* AdGroupEstimate           -   L<Google::Adwords::AdGroupEstimate>

* CampaignRequest           -   L<Google::Adwords::CampaignRequest>

* CampaignEstimate          -   L<Google::Adwords::CampaignEstimate>

* Business                  -   L<Google::Adwords::Business>

* Criterion                 -   L<Google::Adwords::Criterion>

* Ad                        -   L<Google::Adwords::Ad>

* KeywordVariation          -   L<Google::Adwords::KeywordVariation>

* KeywordVariations         -   L<Google::Adwords::KeywordVariations>

* SeedKeyword               -   L<Google::Adwords::SeedKeyword>

* SiteKeyword               -   L<Google::Adwords::SiteKeyword>

* SiteKeywordGroups         -   L<Google::Adwords::SiteKeywordGroups>

=back


 
=head1 DEPENDENCIES
 
* SOAP::Lite
 
=head1 THANKS

* The Yahoo::Marketing module on which this module draws heavily from

* betonmarkets.com - For the initial requirement and funding


=head1 SEE ALSO

Mailing List at L<https://lists.sourceforge.net/lists/listinfo/google-adwords-perl>

=head1 AUTHORS
 
Rohan Almeida <rohan@almeida.in>

Mathieu Jondet <mathieu@eulerian.com>
 
 
=head1 LICENSE AND COPYRIGHT
 
Copyright (c) 2006 Rohan Almeida <rohan@almeida.in>. All rights
reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

