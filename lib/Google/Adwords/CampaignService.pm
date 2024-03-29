package Google::Adwords::CampaignService;
use strict;
use warnings;

use version; our $VERSION = qv('0.11');

use base 'Google::Adwords::Service';
use Date::Manip;

# data types
use Google::Adwords::Campaign;
use Google::Adwords::BudgetOptimizerSettings;
use Google::Adwords::ConversionOptimizerSettings;
use Google::Adwords::GeoTarget;
use Google::Adwords::CityTargets;
use Google::Adwords::CountryTargets;
use Google::Adwords::MetroTargets;
use Google::Adwords::ProximityTargets;
use Google::Adwords::Circle;
use Google::Adwords::RegionTargets;
use Google::Adwords::LanguageTarget;
use Google::Adwords::NetworkTarget;
use Google::Adwords::AdSchedule;
use Google::Adwords::SchedulingInterval;
use Google::Adwords::StatsRecord;

### INTERNAL UTILITY ################################################
# Usage      : @campaign_params = _create_campaign_params($campaign);
# Purpose    : Create SOAP::Data request params from a campaign object
# Returns    : ????
# Parameters : ????
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub _create_campaign_params
{
    my $campaign = shift;
    my @campaign_params;

    # budgetAmount
    push @campaign_params,
        SOAP::Data->name( 'budgetAmount' => $campaign->budgetAmount )
        ->type('');

    # budget optimizer settings
    if ( defined $campaign->budgetOptimizerSettings )
    {
        my @budget_params;
        my $budget = $campaign->budgetOptimizerSettings;

        for (qw/bidCeiling enabled takeOnOptimizedBids/)
        {
            if ( defined $budget->$_ )
            {
                push @budget_params,
                    SOAP::Data->name( $_ => $budget->$_ )->type('');
            }
        }

        push @campaign_params,
            SOAP::Data->name(
            'budgetOptimizerSettings' => \SOAP::Data->value(@budget_params) )
            ->type('');

    } # end if ( defined $campaign...

    # budgetPeriod
    my $budget_period = $campaign->budgetPeriod || 'Daily';
    push @campaign_params,
        SOAP::Data->name( 'budgetPeriod' => $budget_period )->type('');

    # contentTargeting
    push @campaign_params,
        SOAP::Data->name( 'contentTargeting' => $campaign->contentTargeting )
        ->type('');

    # conversion optimizer settings
    if ( defined $campaign->conversionOptimizerSettings )
    {
        my @conv_params;
        my $c_opt = $campaign->conversionOptimizerSettings;

        for (qw/enabled maxCpaBidForAllAdGroups/)
        {
            if ( defined $c_opt->$_ )
            {
                push @conv_params,
                    SOAP::Data->name( $_ => $c_opt->$_ )->type('');
            }
        }

        push @campaign_params,
            SOAP::Data->name(
            'conversionOptimizerSettings' => \SOAP::Data->value(@conv_params)
            )->type('');

    } # end if ( defined $campaign...

    # end_day
    if ( defined $campaign->endDay )
    {
        push @campaign_params,
            SOAP::Data->name( 'endDay' => $campaign->endDay )->type('');
    }

    # geo_targeting
    if ( defined $campaign->geoTargeting )
    {
        my $geo_obj = $campaign->geoTargeting;

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

                my @soap_targets;

                if (    ( defined $targets->$key )
                    and ( scalar @{ $targets->$key } > 0 ) )
                {
                    push @soap_targets,
                        SOAP::Data->name( $key => @{ $targets->$key } )
                        ->type('');
                }

                # exclusions
                my $exclusion = 'excluded' . ucfirst $key;
                if (    ( defined $targets->$exclusion )
                    and ( scalar @{ $targets->$exclusion } > 0 ) )
                {
                    push @soap_targets,
                        SOAP::Data->name(
                        $exclusion => @{ $targets->$exclusion } )->type('');
                }

                if (@soap_targets)
                {
                    push @geo_data,
                        SOAP::Data->name(
                        $_ => \SOAP::Data->value(@soap_targets) )->type('');
                }

            } # end if ( defined $geo_obj->$_...
        } # end for ( keys %geo_target_params...

        # proximityTargets
        if ( defined $geo_obj->proximityTargets )
        {
            my @proximity_soap;
            my $circles = $geo_obj->proximityTargets->circles;

            foreach my $circle_ref ( @{$circles} )
            {
                my @circles_soap;
                for (
                    qw/latitudeMicroDegrees longitudeMicroDegrees
                    radiusMeters/
                    )
                {
                    if ( defined $circle_ref->$_ )
                    {
                        push @circles_soap,
                            SOAP::Data->name( $_ => $circle_ref->$_ )
                            ->type('');
                    }
                }
                push @proximity_soap,
                    SOAP::Data->name(
                    circles => \SOAP::Data->value(@circles_soap) )->type('');

            }

            push @geo_data,
                SOAP::Data->name(
                proximityTargets => \SOAP::Data->value(@proximity_soap) )
                ->type('');
        } # end if ( defined $geo_obj->proximityTargets...

        if ( scalar @geo_data > 0 )
        {
            push @campaign_params,
                SOAP::Data->name(
                'geoTargeting' => \SOAP::Data->value(@geo_data), )->type('');
        }
    } # end if ( defined $campaign...

    # language_targeting
    if ( defined $campaign->languageTargeting )
    {
        my $langs_ref = $campaign->languageTargeting->languages;

        if ( scalar @{$langs_ref} > 0 )
        {
            push @campaign_params,
                SOAP::Data->name( 'languageTargeting' =>
                    \SOAP::Data->name( 'languages' => @{$langs_ref} )
                    ->type('') )->type('');
        }
    }

    # campaign name
    if ( defined $campaign->name )
    {
        push @campaign_params,
            SOAP::Data->name( 'name' => $campaign->name )->type('');
    }

    # network_targeting
    if ( defined $campaign->networkTargeting )
    {
        my $network_ref = $campaign->networkTargeting->networkTypes;

        if ( scalar @{$network_ref} > 0 )
        {
            push @campaign_params,
                SOAP::Data->name( 'networkTargeting' =>
                    \SOAP::Data->name( 'networkTypes' => @{$network_ref} )
                    ->type('') )->type('');
        }
    }

    # Ad schedule
    if ( defined $campaign->schedule )
    {

        my @schedule_params;

        # status
        push @schedule_params,
            SOAP::Data->name( 'status' => $campaign->schedule->status )
            ->type('');

        # intervals
        foreach my $interval ( @{ $campaign->schedule->intervals } )
        {
            my @interval_params;
            for (qw/day endHour endMinute multiplier startHour startMinute/)
            {
                if ( defined $interval->$_ )
                {
                    push @interval_params,
                        SOAP::Data->name( $_ => $interval->$_ )->type('');
                }
            }
            push @schedule_params,
                SOAP::Data->name(
                'intervals' => \SOAP::Data->value(@interval_params) )
                ->type('');
        }

        push @campaign_params,
            SOAP::Data->name(
            'schedule' => \SOAP::Data->value(@schedule_params) )->type('');
    } # end if ( defined $campaign...

    # start_day
    if ( defined $campaign->startDay )
    {
        push @campaign_params,
            SOAP::Data->name( 'startDay' => $campaign->startDay )->type('');
    }

    # status
    if ( defined $campaign->status )
    {
        push @campaign_params,
            SOAP::Data->name( 'status' => $campaign->status )->type('');
    }

    return @campaign_params;
} # end sub _create_campaign_params

### INTERNAL UTILITY ##################################################
# Usage      : $campaign = $self->_create_campaign_object($data_ref);
# Purpose    : Create a campaign object from a hashref
# Returns    : ????
# Parameters : ????
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub _create_campaign_object
{
    my ( $self, $data ) = @_;

    # format dates
    $data->{'startDay'}
        = UnixDate( ParseDate( $data->{'startDay'} ), "%Y-%m-%d %H:%M:%S" );
    $data->{'endDay'}
        = UnixDate( ParseDate( $data->{'endDay'} ), "%Y-%m-%d %H:%M:%S" );

    # budgetOptimizerSettings
    if ( exists $data->{budgetOptimizerSettings} )
    {
        $data->{budgetOptimizerSettings}
            = $self->_create_object_from_hash(
            $data->{budgetOptimizerSettings},
            'Google::Adwords::BudgetOptimizerSettings' );
    }

    # conversionOptimizerSettings
    if ( exists $data->{conversionOptimizerSettings} )
    {
        $data->{conversionOptimizerSettings}
            = $self->_create_object_from_hash(
            $data->{conversionOptimizerSettings},
            'Google::Adwords::ConversionOptimizerSettings'
            );
    }

    # geoTargeting
    if ( exists $data->{geoTargeting} )
    {

        for ( keys %{ $data->{geoTargeting} } )
        {
            next if ( $_ eq 'targetAll' || $_ eq 'proximityTargets' );

            my $geo_ref = $data->{geoTargeting};
            if ( defined $geo_ref->{$_} )
            {
                my $target_obj
                    = $self->_create_object_from_hash( $geo_ref->{$_},
                    "Google::Adwords::" . ucfirst $_ );
                $data->{geoTargeting}{$_} = $target_obj;
            }

        }

        # proximityTargets
        if ( defined $data->{geoTargeting}{proximityTargets} )
        {
            my $proxi_ref = $data->{geoTargeting}{proximityTargets};
            if ( defined $proxi_ref->{circles} )
            {
                my @circles;
                if ( ref $proxi_ref->{circles} eq 'ARRAY' )
                {
                    for ( @{ $proxi_ref->{circles} } )
                    {
                        push @circles,
                            $self->_create_object_from_hash( $_,
                            "Google::Adwords::Circle" );
                    }
                }
                else
                {    # just a single circle
                    push @circles,
                        $self->_create_object_from_hash(
                        $proxi_ref->{circles}, "Google::Adwords::Circle" );
                }
                $proxi_ref->{circles} = \@circles;
            } # end if ( defined $proxi_ref...
            $data->{geoTargeting}{proximityTargets}
                = $self->_create_object_from_hash(
                $data->{geoTargeting}{proximityTargets},
                "Google::Adwords::ProximityTargets"
                );
        } # end if ( defined $data->{geoTargeting...

        $data->{geoTargeting}
            = $self->_create_object_from_hash( $data->{geoTargeting},
            'Google::Adwords::GeoTarget' );
    } # end if ( exists $data->{geoTargeting...

    # languageTargeting
    if ( exists $data->{languageTargeting} )
    {
        $data->{languageTargeting}
            = $self->_create_object_from_hash( $data->{languageTargeting},
            "Google::Adwords::LanguageTarget" );
    }

    # networkTargeting
    if ( exists $data->{networkTargeting} )
    {
        $data->{networkTargeting}
            = $self->_create_object_from_hash( $data->{networkTargeting},
            "Google::Adwords::NetworkTarget" );
    }

    # ad schedule
    my @intervals;
    if ( exists $data->{schedule}{intervals} )
    {

        # check if we have multiple intervals
        if ( ref $data->{schedule}{intervals} eq 'ARRAY' )
        {
            for ( @{ $data->{schedule}{intervals} } )
            {
                push @intervals,
                    $self->_create_object_from_hash( $_,
                    "Google::Adwords::SchedulingInterval" );
            }
        }
        else
        {

            # just a single interval
            push @intervals,
                $self->_create_object_from_hash( $data->{schedule}{intervals},
                "Google::Adwords::SchedulingInterval" );
        }
    } # end if ( exists $data->{schedule...

    if ( scalar @intervals > 0 )
    {
        $data->{schedule}{intervals} = \@intervals;
    }
    my $ad_schedule = $self->_create_object_from_hash( $data->{schedule},
        "Google::Adwords::AdSchedule" );

    $data->{schedule} = $ad_schedule;

    # get campaign object
    my $campaign_response = $self->_create_object_from_hash( $data,
        'Google::Adwords::Campaign' );

    return $campaign_response;
} # end sub _create_campaign_object

### INSTANCE METHOD ################################################
# Usage      :
#   my $campaign = $obj->addCampaign($campaign);
# Purpose    : Add a new campaign
# Returns    : ????
# Parameters : ????
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub addCampaign
{
    my ( $self, $campaign ) = @_;

    # budgetAmount should be present
    if ( not defined $campaign->budgetAmount )
    {
        die "budgetAmount should be set for the campaign object";
    }

    my @campaign_params = _create_campaign_params($campaign);

    my @params;
    push @params,
        SOAP::Data->name( 'campaign' => \SOAP::Data->value(@campaign_params) )
        ->type('');

    # create the SOAP service
    my $result = $self->_create_service_and_call(
        {
            service => 'CampaignService',
            method  => 'addCampaign',
            params  => \@params,
        }
    );

    # get response data in a hash
    my $data = $result->valueof("//addCampaignResponse/addCampaignReturn");

    return $self->_create_campaign_object($data);
} # end sub addCampaign

### INSTANCE METHOD ################################################
# Usage      :
#   my @campaigns = $obj->addCampaignList(@campaigns_to_add);
# Purpose    : Add a list of new campaign
# Returns    : @campaigns => List of newly added campaign objects
# Parameters : @campaigns_to_add => List of campaign objects to add
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub addCampaignList
{
    my ( $self, @campaigns ) = @_;

    # budgetAmount should be present
    for (@campaigns)
    {
        if ( not defined $_->budgetAmount )
        {
            die "budgetAmount should be set for the campaign object";
        }
    }

    # request params
    my @params;

    # loop over campaign objects
    for (@campaigns)
    {

        my @campaign_params = _create_campaign_params($_);

        push @params,
            SOAP::Data->name(
            'campaign' => \SOAP::Data->value(@campaign_params) )->type('');

    }

    # create the SOAP service
    my $result = $self->_create_service_and_call(
        {
            service => 'CampaignService',
            method  => 'addCampaignList',
            params  => \@params,
        }
    );

    my @data;
    foreach my $c (
        $result->valueof("//addCampaignListResponse/addCampaignListReturn") )
    {
        push @data, $self->_create_campaign_object($c);
    }

    return @data;
} # end sub addCampaignList

### INSTANCE METHOD ################################################
# Usage      :
#   my @campaigns = $obj->getAllAdWordsCampaigns();
# Purpose    : Get all the AdWords campaign for an account
# Returns    : A list of Campaign objects
# Parameters : none
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getAllAdWordsCampaigns
{
    my ($self) = @_;

    my @params;
    push @params, SOAP::Data->name( 'dummy' => 1 )->type('');

    my $result = $self->_create_service_and_call(
        {
            service => 'CampaignService',
            method  => 'getAllAdWordsCampaigns',
            params  => \@params,
        }
    );

    my @data;
    foreach my $c (
        $result->valueof(
            "//getAllAdWordsCampaignsResponse/getAllAdWordsCampaignsReturn")
        )
    {
        push @data, $self->_create_campaign_object($c);
    }

    return @data;
} # end sub getAllAdWordsCampaigns

### INSTANCE METHOD ################################################
# Usage      :
#   my $campaign = $obj->getCampaign($id);
# Purpose    : Get details for specified AdWords campaign
# Returns    : the campaign object
# Parameters : the id of the campaign
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getCampaign
{
    my ( $self, $id ) = @_;

    my @params;
    push @params, SOAP::Data->name( 'id' => $id )->type('');

    my $result = $self->_create_service_and_call(
        {
            service => 'CampaignService',
            method  => 'getCampaign',
            params  => \@params,
        }
    );

    my $data = $result->valueof("//getCampaignResponse/getCampaignReturn");

    return $self->_create_campaign_object($data);
} # end sub getCampaign

### INSTANCE METHOD ################################################
# Usage      :
#   my @campaigns = $obj->getCampaignList(@campaign_ids);
# Purpose    : Get details on a specific list of campaigns
# Returns    : A list of campaign objects
# Parameters : An list of campaign ids to be fetched
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getCampaignList
{
    my ( $self, @campaign_ids ) = @_;

    my @params;
    push @params, SOAP::Data->name( 'ids' => @campaign_ids )->type('');

    my $result = $self->_create_service_and_call(
        {
            service => 'CampaignService',
            method  => 'getCampaignList',
            params  => \@params,
        }
    );

    my @data;
    foreach my $c (
        $result->valueof("//getCampaignListResponse/getCampaignListReturn") )
    {
        push @data, $self->_create_campaign_object($c);
    }

    return @data;
} # end sub getCampaignList

### INSTANCE METHOD ################################################
# Usage      :
#   my @campaign_stats = $obj->getCampaignStats({
#           campaignids => [ 3982, 2787, 17872 ],
#           startDay => $startDay,
#           endDay      => $endDay,
#   });
# Purpose    : Get stats on a set of campaign
# Returns    :  A list of StatsRecord object for each campaign
# Parameters :
#       ids  : array reference of campaign ids
#       startDay : starting day of the stats YYYY-MM-DD
#       endDay : end day of the stats YYYY-MM-DD
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getCampaignStats
{
    my ( $self, $args_ref ) = @_;
    my $ra_id    = $args_ref->{campaignids} || [];
    my $startDay = $args_ref->{startDay}    || '';
    my $endDay   = $args_ref->{endDay}      || '';

    my @params;
    push @params, SOAP::Data->name( 'campaignids' => @{$ra_id} )->type('');
    push @params, SOAP::Data->name( 'startDay'    => $startDay )->type('');
    push @params, SOAP::Data->name( 'endDay'      => $endDay )->type('');

    my $result = $self->_create_service_and_call(
        {
            service => 'CampaignService',
            method  => 'getCampaignStats',
            params  => \@params,
        }
    );

    my @data;
    foreach my $c (
        $result->valueof("//getCampaignStatsResponse/getCampaignStatsReturn")
        )
    {
        push @data,
            $self->_create_object_from_hash( $c,
            'Google::Adwords::StatsRecord' );
    }

    return @data;
} # end sub getCampaignStats

### INSTANCE METHOD ################################################
# Usage      :
#   my $is_optimized = $obj->getOptimizeAdServing($id);
# Purpose    : Get the optimize AdServing status flag.
# Returns    : 1 if true, 0 otherwise
# Parameters : the campaign id
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getOptimizeAdServing
{
    my ( $self, $id ) = @_;

    my @params;
    push @params, SOAP::Data->name( 'id' => $id )->type('');

    my $result = $self->_create_service_and_call(
        {
            service => 'CampaignService',
            method  => 'getOptimizeAdServing',
            params  => \@params,
        }
    );

    my $data = $result->valueof(
        "//getOptimizeAdServingResponse/getOptimizeAdServingReturn");

    return ( $data eq 'true' ) ? 1 : 0;
} # end sub getOptimizeAdServing

### INSTANCE METHOD ################################################
# Usage      :
#   my $ret = $obj->setOptimizeAdServing($id, $enable);
# Purpose    : Set the optimize AdServing status flag.
# Returns    : returns 1 if success
# Parameters :
#       - the campaign id
#       - the enable flag, set to 1 for 'true', 0 for for 'false'
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub setOptimizeAdServing
{
    my ( $self, $id, $enable ) = @_;

    if ( not defined $id )
    {
        die "setOptimizeAdServing : need to provide campaign id.\n";
    }
    if ( not defined $enable )
    {
        die "setOptimizeAdServing : need to provide enable flag.\n";
    }

    my @params;
    push @params, SOAP::Data->name( 'campaignid' => $id )->type('');
    push @params,
        SOAP::Data->name( 'enable' => ($enable) ? 'true' : 'false' )
        ->type('');

    my $result = $self->_create_service_and_call(
        {
            service => 'CampaignService',
            method  => 'setOptimizeAdServing',
            params  => \@params,
        }
    );

    return 1;
} # end sub setOptimizeAdServing

### INSTANCE METHOD ################################################
# Usage      :
#   my $campaign = $obj->updateCampaign($campaign_obj);
# Purpose    : Update an existing campaign
# Returns    : returns 1 on success
# Parameters : The Campaign object which needs updating
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub updateCampaign
{
    my ( $self, $campaign ) = @_;

    # id should be present
    if ( not defined $campaign->id )
    {
        die "id should be set for the campaign object";
    }

    my @campaign_params = _create_campaign_params($campaign);
    push @campaign_params,
        SOAP::Data->name( 'id' => $campaign->id )->type('');

    my @params;
    push @params,
        SOAP::Data->name( 'campaign' => \SOAP::Data->value(@campaign_params) )
        ->type('');

    # create the SOAP service
    my $result = $self->_create_service_and_call(
        {
            service => 'CampaignService',
            method  => 'updateCampaign',
            params  => \@params,
        }
    );

    return 1;
} # end sub updateCampaign

### INSTANCE METHOD ################################################
# Usage      :
#   my $ret = $obj->updateCampaignList(@campaigns);
# Purpose    : Update a list of campaigns
# Returns    : 1 on success
# Parameters : @campaigns => List of campaign objects to update
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub updateCampaignList
{
    my ( $self, @campaigns ) = @_;

    # id should be present
    for (@campaigns)
    {
        if ( not defined $_->id )
        {
            die "id should be set for the campaign object";
        }
    }

    my @params;

    # loop over campaign objects
    for my $campaign (@campaigns)
    {

        my @campaign_params = _create_campaign_params($campaign);
        push @campaign_params,
            SOAP::Data->name( 'id' => $campaign->id )->type('');

        push @params,
            SOAP::Data->name(
            'campaign' => \SOAP::Data->value(@campaign_params) )->type('');

    }

    # create the SOAP service
    my $result = $self->_create_service_and_call(
        {
            service => 'CampaignService',
            method  => 'updateCampaignList',
            params  => \@params,
        }
    );

    return 1;
} # end sub updateCampaignList

1;

=pod

=head1 NAME
 
Google::Adwords::CampaignService - Interface to the Google Adwords CampaignService API calls
 
 
=head1 VERSION
 
This documentation refers to Google::Adwords::CampaignService version 0.10
 
 
=head1 SYNOPSIS
 
    use Google::Adwords::Campaign;
    use Google::Adwords::GeoTarget;
    use Google::Adwords::CityTargets;
    use Google::Adwords::CampaignService;

    # create a new campaign object
    my $campaign = Google::Adwords::Campaign;

    # set values for the campaign object
    $campaign->name('My Final Try');
    $campaign->budgetAmount(10000000);

    # target a certain city in US
    my $geo_target = Google::Adwords::GeoTarget->new();
    my $city_targets = Google::Adwords::CityTargets->new();
    $city_targets->cities([ 'Pelican, AK US' ]);
    $geo_target->cityTargets($city_targets);
    $campaign->geoTargeting($geo_target);
  
    # create the campaign service object
    my $campaign_service = Google::Adwords::CampaignService->new();

    # need to login to the Adwords service
    $campaign_service->email($email_address)
                     ->password($password)
                     ->developerToken($developer_token)
                     ->applicationToken($application_token);

    # if you have a MCC
    $campaign_service->clientEmail($client_email);
    # or 
    $campaign_service->clientCustomerId($customerid);

    # now create the campaign
    my $campaign_response = $campaign_service->addCampaign($campaign);

    print "New campaign ID is :" . $campaign_response->id;
 
  
=head1 DESCRIPTION

This module provides an interface to the Google Adwords CampaignService API
calls. Please read L<Google::Adwords::Campaign> on how to setup and receive
information about your campaigns.

  
=head1 METHODS 
 
=head2 B<addCampaign()>

=head3 Description

=over 4

Create a new campaign.

=back

=head3 Usage

    my $campaign_response = $obj->addCampaign($campaign);

=head3 Parameters

=over 4

1) $campaign - A Google::Adwords::Campaign object

=back

=head3 Returns
 
=over 4

$campaign_response => The new campaign details as a Google::Adwords::Campaign object

=back

=head2 B<addCampaignList()>

=head3 Description

=over 4

Add a list of new Campaigns

=back

=head3 Usage

    my @campaign_responses = $obj->addCampaignList(@campaigns_to_add);

    # or even
    my @campaign_responses 
        = $obj->addCampaignList($campaign1, $campaign2);

=head3 Parameters

=over 4

1) @campaigns_to_add - A List of Google::Adwords::Campaign objects which
should be added

=back

=head3 Returns
 
=over 4

@campaign_responses => A List of Google::Adwords::Campaign objects which were
added

=back

=head2 B<getAllAdWordsCampaigns()>

=head3 Description

=over 4

Return all information about all Campaigns belonging to the customer issuing
the request. Ad Automator campaigns will not be included in the list of
returned campaigns.

=back

=head3 Usage

        my @campaigns = $obj->getAllAdWordsCampaigns();

=head3 Parameters

None.

=head3 Returns
 
=over 4

@campaigns => A list of Google::Adwords::Campaign objects

=back

=head2 B<getCampaign()>

=head3 Description

=over 4

Return all information about a specified Campaign.

=back

=head3 Usage

    my $campaign = $obj->getCampaign($id);

=head3 Parameters

1) $id - The id of the campaign you want details for.

=head3 Returns
 
=over 4

$campaign => The campaign details as a Google::Adwords::Campaign object

=back

=head2 B<getCampaignList()>

=head3 Description

=over 4

Return information about a list of Campaigns.

=back

=head3 Usage

    my @campaigns = $obj->getCampaignList(@campaign_ids);

=head3 Parameters

A list of campaign ids you require information about

=head3 Returns
 
=over 4

@campaigns => A list of Google::Adwords::Campaign objects

=back

=head2 B<getCampaignStats()>

=head3 Description

=over 4

Get statistics for a list of Campaigns. See L<Google::Adwords::StatsRecord> 
for details about the statistics returned. The time granularity is one day.

Also see - 

L<http://www.google.com/apis/adwords/developer/StatsRecord.html>

=back

=head3 Usage

    my @campaign_stats = $obj->getCampaignStats({
        campaignids     => [ 3567, 4567, 8819 ],
        startDay => '2006-08-01',
        endDay  => '2006-08-31',
    });

=head3 Parameters

Takes a hashref with following keys,

=over 4

* campaignids => An array ref of campaign ids you want stats for

* startDay => The starting day of the period for which statistics are to 
be collected in format YYYY-MM-DD

* endDay => The ending day of the period for which statistics are to be
collected in format YYYY-MM-DD


=back


=head3 Returns
 
=over 4

An list of Google::Adwords::StatsRecord objects for each campaign

=back

=head2 B<getOptimizeAdServing()>

=head3 Description

=over 4

Retrieve the 'optimized ad serving' setting for this campaign. If optimized ad
serving is enabled for a campaign, creatives with the best clickthrough rates
will be favored. This setting applies to all AdGroups in the Campaign.

More info is here - 

L<https://adwords.google.com/select/tips.html#AdServing>

=back

=head3 Usage

=over 4

    my $is_optimized = $obj->getOptimizeAdServing($id);

=back

=head3 Parameters

1) $id - The campaign id.

=head3 Returns
 
=over 4

1 if the flag is set to 'true', 0 if set to 'false'.

=back

=head2 B<setOptimizeAdServing()>

=head3 Description

=over 4

Modify the 'optimized ad serving' setting for this campaign. New campaigns
have optimized ad serving enabled by default. This setting can only be toggled
for Campaigns that have at least one Creative associated with them.

=back

=head3 Usage

=over 4

    my $ret = $obj->setOptimizeAdServing($id, 1); # to set the flag
    my $ret = $obj->setOptimizeAdServing($id, 0); # to unset the flag

=back

=head3 Parameters

The campaign id and a boolean (1 or 0) for setting/unsetting the flag.

=head3 Returns
 
=over 4

Returns 1 on success

=back

=head2 B<updateCampaign()>

=head3 Description

=over 4

Update the settings for an existing campaign.

=back

=head3 Usage

=over 4

    my $ret = $obj->updateCampaign($campaign);

=back

=head3 Parameters

1) $campaign - A Google::Adwords::Campaign object which needs updating. Make
sure you have at the least set the id of the object. If you need to update
only certain fileds, then use the accessor to set the value. Fields which
don't have values will not be updated

=head3 Returns

Returns 1 on success
 
=over 4

=back

=head2 B<updateCampaignList()>

=head3 Description

=over 4

Update the settings for a list of existing campaigns.

=back

=head3 Usage

=over 4

    my $ret = $obj->updateCampaignList(@campaigns);

=back

=head3 Parameters

@campaigns => A list of Google::Adwords::Campaign objects which need updating

=head3 Returns

=over 4

Returns 1 on success

=back

=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::Campaign>

=item * L<Google::Adwords::GeoTarget>

=item * L<Google::Adwords::CityTargets>

=item * L<Google::Adwords::CountryTargets>

=item * L<Google::Adwords::MetroTargets>

=item * L<Google::Adwords::RegionTargets>

=item * L<Google::Adwords::StatsRecord>

=item * L<Google::Adwords::AdSchedule>

=item * L<Google::Adwords::SchedulingInterval>

=item * L<Google::Adwords::BudgetOptimizerSettings>

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

