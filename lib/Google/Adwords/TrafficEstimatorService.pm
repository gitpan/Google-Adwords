package Google::Adwords::TrafficEstimatorService;
use strict;
use warnings;

use version; our $VERSION = qv('0.1.2');

use base 'Google::Adwords::Service';

# data types
use Google::Adwords::KeywordTrafficRequest;
use Google::Adwords::AdGroupRequest;
use Google::Adwords::KeywordRequest;
use Google::Adwords::AdGroupEstimate;
use Google::Adwords::KeywordEstimate;
use Google::Adwords::CampaignRequest;
use Google::Adwords::GeoTarget;
use Google::Adwords::CityTargets;
use Google::Adwords::CountryTargets;
use Google::Adwords::MetroTargets;
use Google::Adwords::RegionTargets;
use Google::Adwords::ProximityTargets;
use Google::Adwords::Circle;
use Google::Adwords::LanguageTarget;
use Google::Adwords::NetworkTarget;
use Google::Adwords::CampaignEstimate;
use Google::Adwords::KeywordRequest;


### CLASS METHOD/INSTANCE METHOD/INTERFACE SUB/INTERNAL UTILITY ###
# Usage      : ????
# Purpose    : ????
# Returns    : ????
# Parameters : ????
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub checkKeywordTraffic
{
    my ( $self, @k_t_reqs ) = @_;

    my @params;

    for (@k_t_reqs)
    {
        my @request_params;
        if ( defined $_->keywordText )
        {
            push @request_params,
                SOAP::Data->name( 'keywordText' => $_->keywordText )
                ->type('');
        }
        if ( defined $_->keywordType )
        {
            push @request_params,
                SOAP::Data->name( 'keywordType' => $_->keywordType )
                ->type('');
        }
        if ( defined $_->language )
        {
            push @request_params,
                SOAP::Data->name( 'language' => $_->language )->type('');
        }

        push @params, SOAP::Data->name(
            'requests' => \SOAP::Data->value(@request_params) )->type('');
    } # end for (@k_t_reqs)

    my $result = $self->_create_service_and_call(
        {
            service => 'TrafficEstimatorService',
            method  => 'checkKeywordTraffic',
            params  => \@params,
        }
    );

    # get response data in a hash
    my @data;
    foreach my $c (
        $result->valueof(
            "//checkKeywordTrafficResponse/checkKeywordTrafficReturn")
        )
    {
        push @data, $c;
    }

    return @data;
} # end sub checkKeywordTraffic

### INSTANCE METHOD ################################################
# Usage      :
#   my @adgroupestimate  = $obj->estimateAdGroupList($adgrpreq1, $adgrpreq2);
# Purpose    : Returns traffic estimates for the requested set of new or existing ad groups.
# Returns    : An array of Google::Adwords::AdGroupEstimate objects.
# Parameters : An array of Google::Adwords::AdGroupRequest objects.
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub estimateAdGroupList
{
    my ( $self, @adgrouprequest ) = @_;

    my @params;
    for (@adgrouprequest)
    {
        my @adgrouprequest_params;
        if ( defined $_->id )
        {
            push @adgrouprequest_params,
                SOAP::Data->name( 'id' => $_->id )->type('');
        }
        if ( defined $_->maxCpc )
        {
            push @adgrouprequest_params,
                SOAP::Data->name( 'maxCpc' => $_->maxCpc )->type('');
        }
        if ( defined $_->keywordRequests )
        {
            my @p =
                ( ref( $_->keywordRequests ) eq 'ARRAY' )
                ? @{ $_->keywordRequests }
                : $_->keywordRequests;
            foreach my $kwreq (@p)
            {
                my @keywordrequest_params;
                foreach my $field (qw/ id maxCpc negative text type /)
                {
                    if ( defined $kwreq->$field )
                    {
                        push @keywordrequest_params,
                            SOAP::Data->name( $field => $kwreq->$field )
                            ->type('');
                    }
                }
                push @adgrouprequest_params,
                    SOAP::Data->name( 'keywordRequests' =>
                        \SOAP::Data->value(@keywordrequest_params) )
                    ->type('');
            }
        } # end if ( defined $_->keywordRequests...
        push @params,
            SOAP::Data->name(
            'adGroupRequests' => \SOAP::Data->value(@adgrouprequest_params) )
            ->type('');
    } # end for (@adgrouprequest)

    my $result = $self->_create_service_and_call(
        {
            service => 'TrafficEstimatorService',
            method  => 'estimateAdGroupList',
            params  => \@params,
        }
    );

    # get response data in a hash
    my @data;
    foreach my $c (
        $result->valueof(
            "//estimateAdGroupListResponse/estimateAdGroupListReturn")
        )
    {
        my @keywordestimate;
        my $ra_keywordestimate =
            ( ref( $c->{keywordEstimates} ) eq 'ARRAY' )
            ? $c->{keywordEstimates}
            : [ $c->{keywordEstimates} ];
        for ( @{$ra_keywordestimate} )
        {
            push @keywordestimate,
                $self->_create_object_from_hash( $_,
                'Google::Adwords::KeywordEstimate' );
        }
        $c->{keywordEstimates} = \@keywordestimate;
        push @data,
            $self->_create_object_from_hash( $c,
            'Google::Adwords::AdGroupEstimate' );
    }

    return @data;
} # end sub estimateAdGroupList

### INSTANCE METHOD ################################################
# Usage      :
#   my @campaignestimate  = $obj->estimateCampaignList($cmpgnreq1, $cmpgnreq2);
# Purpose    : Returns traffic estimates for the requested set of campaigns.
# Returns    : An array of Google::Adwords::CampaignEstimate objects.
# Parameters : An array of Google::Adwords::CampaignRequest objects.
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub estimateCampaignList
{
    my ( $self, @campaignrequest ) = @_;

    my @params;
    foreach my $campaign (@campaignrequest)
    {
        my @campaignrequest_params;
        if ( defined $campaign->id )
        {
            push @campaignrequest_params,
                SOAP::Data->name( 'id' => $campaign->id )->type('');
        }

        # geo_targeting
        if ( defined $campaign->geoTargeting )
        {
            my $geo_obj = $campaign->geoTargeting;

            #die ref $geo_obj;
            my @geo_data;

            if ( defined $geo_obj->targetAll )
            {
                push @geo_data,
                    SOAP::Data->name( targetAll => $geo_obj->targetAll )
                    ->type('');
            }

            # hash to map API params
            my %geo_target_params = (
                'countryTargets' => 'countries',
                'cityTargets'    => 'cities',
                'metroTargets'   => 'metros',
                'regionTargets'  => 'regions',
            );

            for ( keys %geo_target_params )
            {
                if ( defined $geo_obj->$_ )
                {
                    my $targets = $geo_obj->$_;
                    my $key     = $geo_target_params{$_};

                    if (    ( defined $targets->$key )
                        and ( scalar @{ $targets->$key } > 0 ) )
                    {
                        push @geo_data,
                            SOAP::Data->name(
                            $_ => \SOAP::Data->name(
                                $key => @{ $targets->$key }
                                )->type('')
                            )->type('');
                    }
                } # end if ( defined $geo_obj->$_...
            } # end for ( keys %geo_target_params...

            if ( scalar @geo_data > 0 )
            {
                push @campaignrequest_params,
                    SOAP::Data->name(
                    'geoTargeting' => \SOAP::Data->value(@geo_data), )
                    ->type('');
            }
        } # end if ( defined $campaign...

        # languageTargeting
        if ( defined $campaign->languageTargeting )
        {
            my $langs_ref = $campaign->languageTargeting;
            if ( scalar @{ $langs_ref->{'languages'} } > 0 )
            {
                push @campaignrequest_params,
                    SOAP::Data->name(
                    'languageTargeting' => \SOAP::Data->name(
                        'languages' => @{ $langs_ref->{'languages'} }
                        )->type('')
                    )->type('');
            }
        }

        # networkTargeting
        if ( defined $campaign->networkTargeting )
        {
            my $network_ref = $campaign->networkTargeting;
            if ( scalar @{ $network_ref->{'networkTypes'} } > 0 )
            {
                push @campaignrequest_params,
                    SOAP::Data->name(
                    'networkTargeting' => \SOAP::Data->name(
                        'networkTypes' => @{ $network_ref->{'networkTypes'} }
                        )->type('')
                    )->type('');
            }
        }

        # adGroupRequests
        if ( defined $campaign->adGroupRequests
            && $campaign->adGroupRequests )
        {
            my @p =
                ( ref( $campaign->adGroupRequests ) eq 'ARRAY' )
                ? @{ $campaign->adGroupRequests }
                : $campaign->adGroupRequests;
            foreach my $adgrpreq (@p)
            {
                my @adgrouprequest_params;
                foreach my $field (qw/ id maxCpc /)
                {
                    if ( defined $adgrpreq->$field )
                    {
                        push @adgrouprequest_params,
                            SOAP::Data->name( $field => $adgrpreq->$field )
                            ->type('');
                    }
                }

                # keywordRequests
                if ( defined $adgrpreq->keywordRequests )
                {
                    my @p =
                        ( ref( $adgrpreq->keywordRequests ) eq 'ARRAY' )
                        ? @{ $adgrpreq->keywordRequests }
                        : $adgrpreq->keywordRequests;
                    foreach my $kwreq (@p)
                    {
                        my @keywordrequest_params;
                        foreach my $field (qw/ id maxCpc negative text type /)
                        {
                            if ( defined $kwreq->$field )
                            {
                                push @keywordrequest_params, SOAP::Data->name(
                                    $field => $kwreq->$field )->type('');
                            }
                        }
                        push @adgrouprequest_params,
                            SOAP::Data->name( 'keywordRequests' =>
                                \SOAP::Data->value(@keywordrequest_params) )
                            ->type('');
                    }
                } # end if ( defined $adgrpreq...
                push @campaignrequest_params,
                    SOAP::Data->name( 'adGroupRequests' =>
                        \SOAP::Data->value(@adgrouprequest_params) )
                    ->type('');
            }
        } # end if ( defined $campaign...
        push @params,
            SOAP::Data->name(
            'campaignRequests' => \SOAP::Data->value(@campaignrequest_params)
            )->type('');
    }

    my $result = $self->_create_service_and_call(
        {
            service => 'TrafficEstimatorService',
            method  => 'estimateCampaignList',
            params  => \@params,
        }
    );

    # get response data in a hash
    my @data;
    foreach my $c (
        $result->valueof(
            "//estimateCampaignListResponse/estimateCampaignListReturn")
        )
    {
        my @adgroupestimate;
        my $ra_adgroupestimate =
            ( ref( $c->{adGroupEstimates} ) eq 'ARRAY' )
            ? $c->{adGroupEstimates}
            : [ $c->{adGroupEstimates} ];
        foreach my $adgrpest ( @{$ra_adgroupestimate} )
        {
            my @keywordestimate;
            my $ra_keywordestimate =
                ( ref( $adgrpest->{keywordEstimates} ) eq 'ARRAY' )
                ? $adgrpest->{keywordEstimates}
                : [ $adgrpest->{keywordEstimates} ];
            for ( @{$ra_keywordestimate} )
            {
                push @keywordestimate,
                    $self->_create_object_from_hash( $_,
                    'Google::Adwords::KeywordEstimate' );
            }
            $adgrpest->{keywordEstimates} = \@keywordestimate;
            push @adgroupestimate,
                $self->_create_object_from_hash( $adgrpest,
                'Google::Adwords::AdGroupEstimate' );
        }
        $c->{adGroupEstimates} = \@adgroupestimate;
        push @data,
            $self->_create_object_from_hash( $c,
            'Google::Adwords::CampaignEstimate' );
    }

    return @data;
} # end sub estimateCampaignList

### INSTANCE METHOD ################################################
# Usage      :
#   my @keywordestimate  = $obj->estimateKeywordList($kwreq1, $kwreq2);
# Purpose    : Returns traffic estimates for the requested set of keywords.
# Returns    : An array of Google::Adwords::KeywordEstimate objects.
# Parameters : An array of Google::Adwords::KeywordRequest objects.
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub estimateKeywordList
{
    my ( $self, @keywordrequest ) = @_;

    my @params;
    for (@keywordrequest)
    {
        my @keywordrequest_params;
        foreach my $field (qw/ id maxCpc negative text type /)
        {
            if ( defined $_->$field )
            {
                push @keywordrequest_params,
                    SOAP::Data->name( $field => $_->$field )->type('');
            }
        }
        push @params,
            SOAP::Data->name(
            'keywordRequests' => \SOAP::Data->value(@keywordrequest_params) )
            ->type('');
    } # end for (@keywordrequest)

    my $result = $self->_create_service_and_call(
        {
            service => 'TrafficEstimatorService',
            method  => 'estimateKeywordList',
            params  => \@params,
        }
    );

    # get response data in a hash
    my @data;
    foreach my $c (
        $result->valueof(
            "//estimateKeywordListResponse/estimateKeywordListReturn")
        )
    {
        push @data,
            $self->_create_object_from_hash( $c,
            'Google::Adwords::KeywordEstimate' );
    }

    return @data;
} # end sub estimateKeywordList

1;

=pod

=head1 NAME
 
Google::Adwords::TrafficEstimatorService - Interact with the Google Adwords
TrafficEstimatorService API calls
 
 
=head1 VERSION
 
This documentation refers to Google::Adwords::TrafficEstimatorService version
0.1.2
 
 
=head1 SYNOPSIS
   
    use Google::Adwords::TrafficEstimatorService;

    use Google::Adwords::AdGroupRequest;
    use Google::Adwords::KeywordRequest;
    use Google::Adwords::CampaignRequest;

    # Create the service object
    my $service = Google::Adwords::TrafficEstimatorService->new();

    # Login to the Adwords server
    $service->email($email)
            ->password($password)
            ->applicationToken($app_token)
            ->developerToken($dev_token);

    # if you use a MCC
    #$service->clientEmail('clientemail@domain.com');
    # or 
    #$service->clientCustomerId($customerid);

    # create some KeywordRequest objects
    my $kwreq1 = Google::Adwords::KeywordRequest->new
                ->text('web analytics')
                ->type('Broad')
                ->maxCpc(1000000);

    my $kwreq2 = Google::Adwords::KeywordRequest->new
                ->text('anti spam product')
                ->type('Broad')
                ->maxCpc(1000000);

    # estimateKeywordList
    my @keyword_estimates = $service->estimateKeywordList($kwreq1, $kwreq2);
    for ( @keyword_estimates ) {
        print "Id : " . $_->id . " | upperAvgPosition : " 
            . $_->upperAvgPosition . "\n";
    }

    # Create AdGroupRequest objects
    my $adgrpreq1 = Google::Adwords::AdGroupRequest->new
                        ->maxCpc(50000000)
                        ->keywordRequests($kwreq1, $kwreq2);

    # estimateAdGroupList
    my @adgroupestimates = $service->estimateAdGroupList($adgrpreq1);
    for ( @adgroupestimate ) {
        print "Id : " . $_->id . "\n";
        foreach my $kw ( @{$_->keywordEstimates} ) {
            print "\tId: " . $kw->id . " | upperAvgPosition : " 
                . $kw->upperAvgPosition . "\n";
        }
    }

    # Create a CampaignRequest object
    my $cmpgreq1 = Google::Adwords::CampaignRequest->new;

    # geoTargeting
        $cmpgreq1->geoTargeting({ cities => [ 'Pelican, AK US' ] });

    # languageTargeting
    $cmpgreq1->languageTargeting({
        languages => [ 'fr', 'en' ] 
    });

    $cmpgreq1->adGroupRequests($adgrpreq1);

    # estimateCampaignList
    my @campaign_estimates = $service->estimateCampaignList($cmpgreq1);
    for ( @campaign_estimates ) {
        print "Id : " . $_->id . "\n";
        foreach my $adgrp ( @{$_->adGroupEstimates} ) {
            print "\tAdGroup Id: " . $adgrp->id . "\n";
            foreach my $kw ( @{$adgrp->keywordEstimates} ) {
                print "\t\tKeyword Id: " . $kw->id 
                    . " | upperAvgPosition : " . $kw->upperAvgPosition . "\n";
            }
        }
    }
  
=head1 DESCRIPTION

This module provides an interface to the Google Adwords TrafficEstimatorService API
calls. 

  
=head1 METHODS 

=head2 B<estimateAdGroupList()>

=head3 Description

=over 4

Returns traffic estimates for the requested set of new or existing ad groups.
All of the ad groups must be new or all of the ad groups must be from the same
campaign. New ad groups are estimated as if they were part of a new campaign
with global targeting.

=back

=head3 Usage

=over 4

    my @adgroup_estimates = $obj->estimateAdGroupList($adgrpreq1, $adgrpreq2);

=back

=head3 Parameters

=over 4

A list of Google::Adwords::AdGroupRequest objects.

=back

=head3 Returns
 
=over 4

A list of Google::Adwords::AdGroupEstimate objects.

=back

=head2 B<estimateCampaignList()>

=head3 Description

=over 4

Returns traffic estimates for the requested set of campaigns. The campaigns
can be all new or all existing, or a mixture of new and existing.

=back

=head3 Usage

=over 4

    my @campaign_estimates = $obj->estimateCampaignList($cmpgnreq1, $cmpgnreq2);

=back

=head3 Parameters

=over 4

A list of Google::Adwords::CampaignRequest objects.

=back

=head3 Returns
 
=over 4

A list of Google::Adwords::CampaignEstimate objects.

=back

=head2 B<estimateKeywordList()>

=head3 Description

=over 4

Returns traffic estimates for the requested set of new keywords. All of the
keywords must be new. Keywords are estimated as if they were part of a single
new ad group in a single new campaign with global targeting.

=back

=head3 Usage

=over 4

    my @keyword_estimates = $obj->estimateKeywordList($kwreq1, $kwreq2);

=back

=head3 Parameters

=over 4

A list of Google::Adwords::KeywordRequest objects.

=back

=head3 Returns
 
=over 4

A list of Google::Adwords::KeywordEstimate objects.

=back

=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::KeywordRequest>

=item * L<Google::Adwords::KeywordEstimate>

=item * L<Google::Adwords::AdGroupRequest>

=item * L<Google::Adwords::AdGroupEstimate>

=item * L<Google::Adwords::CampaignRequest>

=item * L<Google::Adwords::CampaignEstimate>

=back

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

