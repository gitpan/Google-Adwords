package Google::Adwords::CriterionService;
use strict;
use warnings;

use version; our $VERSION = qv('0.5');

use base 'Google::Adwords::Service';

use Google::Adwords::Criterion;
use Google::Adwords::StatsRecord;

use Google::Adwords::ApiError;

use Google::Adwords::LanguageTarget;
use Google::Adwords::GeoTarget;
use Google::Adwords::CityTargets;
use Google::Adwords::CountryTargets;
use Google::Adwords::MetroTargets;
use Google::Adwords::RegionTargets;
use Google::Adwords::ProximityTargets;
use Google::Adwords::Circle;

### INTERNAL UTILITY ###############################################
# Usage      : @params = $self->_create_request_params($obj);
# Purpose    : Create SOAP::Data params from the input object
# Returns    : ????
# Parameters : ????
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub _create_request_params
{
    my ( $self, $criterion ) = @_;

    my @params;

    # Get fields of the base Ad object
    my @fields = Google::Adwords::Criterion->get_fields();

    for (@fields)
    {
        if ( defined $criterion->$_ )
        {
            {
                push @params,
                    SOAP::Data->name( $_ => $criterion->$_ )->type('');
            }
        }
    }

    return @params;
} # end sub _create_request_params

### INTERNAL UTILITY #####################################################
# Usage      : $obj = $self->_parse_criterion_response($criterion_ref);
# Purpose    : Create an Ad object from the Ad input hashref
# Returns    : ????
# Parameters : ????
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub _parse_criterion_response
{
    my ( $self, $r ) = @_;

    # get the type of Criterion
    my $type = ref $r;

    my $c_ref;
    $c_ref->{criterionType} = $type;

    my @fields = Google::Adwords::Criterion->get_fields();

    for (@fields)
    {
        {
            $c_ref->{$_} = $r->{$_};
        }
    }

    return $self->_create_object_from_hash( $c_ref,
        'Google::Adwords::Criterion' );
} # end sub _parse_criterion_response

### INSTANCE METHOD ##################################################
# Usage      : @criterions = $obj->addCriteria(@list_of_criterions);
# Purpose    : Add a new Criteria
# Returns    : @criterions => list of newly added Criterion objects
# Parameters : @list_of_criterions => list of Criterion objects
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub addCriteria
{
    my ( $self, @criteria ) = @_;

    my @params = ();

    foreach my $criterion (@criteria)
    {
        if ( not defined $criterion->adGroupId )
        {
            die "adGroupId must be set for the criterion\n";
        }
        if ( not defined $criterion->criterionType )
        {
            die "criterionType must be set for the criterion\n";
        }
        my @criterion_params = $self->_create_request_params($criterion);

        push @params, SOAP::Data->name(
            'criteria' => \SOAP::Data->value(@criterion_params) )->type('');

    } # end for my $criterion (@criteria...

    my $result = $self->_create_service_and_call(
        {
            service  => 'CriterionService',
            method   => 'addCriteria',
            params   => \@params,
            with_uri => 1,
        }
    );

    my @data;
    foreach
        my $c ( $result->valueof("//addCriteriaResponse/addCriteriaReturn") )
    {
        push @data, $self->_parse_criterion_response($c);
    }

    return @data;
} # end sub addCriteria

### INSTANCE METHOD #####################################################
# Usage      :
#   my @api_errors = $obj->checkCriteria({
#       ads => \@ads,
#       languageTarget => [ 'en', 'hi', ],
#       geoTarget   => {
#           countries => [ 'US', 'IN' ],
#       },
#   });
# Purpose    : Check a batch of Ads for policy errors.
# Returns    : A list of ApiError objects
# Parameters : A hashref with following keys:
#   ads => an arrayref of Ad objects
#   languageTarget => an arrayref of language codes
#   geoTarget => a hashref of geotargeting info
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub checkCriteria
{
    my ( $self, $args_ref ) = @_;

    my @params;

    my @ads_params;
    foreach my $ad ( @{ $args_ref->{criteria} } )
    {
        my @ad_params = $self->_create_request_params($ad);
        push @ads_params, @ad_params;
    }
    push @params,
        SOAP::Data->name( 'criteria' => \SOAP::Data->value(@ads_params) )
        ->type('');

    # languageTarget
    if ( exists $args_ref->{languageTarget} )
    {
        my $languages_ref = $args_ref->{languageTarget}->languages;
        push @params,
            SOAP::Data->name( 'languageTarget' =>
                \SOAP::Data->name( 'languages' => @{$languages_ref} )
                ->type('') )->type('');
    }

    # geoTargeting
    if ( exists $args_ref->{geoTarget} )
    {
        my $geo_obj = $args_ref->{geoTarget};

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
                        $_ => \SOAP::Data->name( $key => @{ $targets->$key } )
                            ->type('') )->type('');
                }
            }
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
                push @proximity_soap, SOAP::Data->name(
                    circles => \SOAP::Data->value(@circles_soap) )->type('');

            }

            push @geo_data,
                SOAP::Data->name(
                proximityTargets => \SOAP::Data->value(@proximity_soap) )
                ->type('');
        } # end if ( defined $geo_obj->proximityTargets...

        if ( scalar @geo_data > 0 )
        {
            push @params, SOAP::Data->name(
                'geoTarget' => \SOAP::Data->value(@geo_data), )->type('');
        }
    } # end if ( exists $args_ref->...

    my $result = $self->_create_service_and_call(
        {
            service => 'CriterionService',
            method  => 'checkCriteria',
            params  => \@params,
        }
    );

    my @data;
    foreach my $c (
        $result->valueof("//checkCriteriaResponse/checkCriteriaReturn") )
    {
        push @data, $self->_create_object_from_hash( $c,
            'Google::Adwords::ApiError' );
    }

    return @data;
} # end sub checkCriteria

### INSTANCE METHOD ##################################################
# Usage      :
#   $ret = $obj->setCampaignNegativeCriteria(
#       $campaign_id,
#       \@criterions,
#   );
# Purpose    : set new negative criteria
# Returns    : $ret => 1 on success
# Parameters :
#   1) $campaign_id => Campaign ID
#   2) \@criterions => arrayref of Criterion objects
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub setCampaignNegativeCriteria
{
    my ( $self, $campaign_id, $criterions_ref ) = @_;

    my @params;
    push @params, SOAP::Data->name( 'campaignId' => $campaign_id )->type('');

    foreach my $criterion ( @{$criterions_ref} )
    {
        if ( not defined $criterion->adGroupId )
        {
            die "adGroupId must be set for the criterion\n";
        }
        if ( not defined $criterion->criterionType )
        {
            die "criterionType must be set for the criterion\n";
        }
        my @criterion_params = $self->_create_request_params($criterion);

        push @params, SOAP::Data->name(
            'criteria' => \SOAP::Data->value(@criterion_params) )->type('');
    } # end for my $criterion ( @{$criterions_ref...

    my $result = $self->_create_service_and_call(
        {
            service => 'CriterionService',
            method  => 'setCampaignNegativeCriteria',
            params  => \@params,
        }
    );

    return 1;
} # end sub setCampaignNegativeCriteria

### INSTANCE METHOD #################################################
# Usage      : $ret = $obj->updateCriteria(@criteria);
# Purpose    : Update a list of Criteria
# Returns    : $ret => 1 on success
# Parameters : @criteria => List of Criterion objects
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub updateCriteria
{
    my ( $self, @criteria ) = @_;

    my @params;

    foreach my $criterion (@criteria)
    {
        if ( not defined $criterion->adGroupId )
        {
            die "adGroupId must be set for the criterion\n";
        }
        if ( not defined $criterion->criterionType )
        {
            die "criterionType must be set for the criterion\n";
        }
        my @criterion_params = $self->_create_request_params($criterion);

        push @params, SOAP::Data->name(
            'criteria' => \SOAP::Data->value(@criterion_params) )->type('');
    } # end for my $criterion (@criteria...

    my $result = $self->_create_service_and_call(
        {
            service => 'CriterionService',
            method  => 'updateCriteria',
            params  => \@params,
        }
    );

    return 1;
} # end sub updateCriteria

### INSTANCE METHOD ################################################
# Usage      :
#   $ret = $obj->removeCriteria($adgroup_id, \@criterion_ids);
# Purpose    : Remove a list of criteria
# Returns    : $ret => 1 on success
# Parameters :
#   1) $adgroup_id => AdGroup ID
#   2) \@criterion_ids => arrayref of criterion ids
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub removeCriteria
{
    my ( $self, $adgroup_id, $criterion_ids_ref ) = @_;

    my @params;
    push @params, SOAP::Data->name( 'adGroupId' => $adgroup_id )->type('');
    push @params,
        SOAP::Data->name( 'criterionIds' => @{$criterion_ids_ref} )->type('');

    my $result = $self->_create_service_and_call(
        {
            service => 'CriterionService',
            method  => 'removeCriteria',
            params  => \@params,
        }
    );

    return 1;
} # end sub removeCriteria

### INSTANCE METHOD ####################################################
# Usage      :
#   my @criterions = $obj->getCampaignNegativeCriteria($campaign_id);
# Purpose    : Get list of negative criteria
# Returns    : @criterions => List of Criterion objects
# Parameters : $campaign_id => Campaign ID
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getCampaignNegativeCriteria
{
    my ( $self, $campaign_id ) = @_;

    my @params;
    push @params, SOAP::Data->name( 'campaignId' => $campaign_id )->type('');

    my $result = $self->_create_service_and_call(
        {
            service => 'CriterionService',
            method  => 'getCampaignNegativeCriteria',
            params  => \@params,
        }
    );

    my @data;
    foreach my $c (
        $result->valueof(
            "//getCampaignNegativeCriteriaResponse/getCampaignNegativeCriteriaReturn"
        )
        )
    {
        push @data, $self->_parse_criterion_response($c);
    }

    return @data;
} # end sub getCampaignNegativeCriteria

### INSTANCE METHOD ####################################################
# Usage      : my @criterions = $obj->getAllCriteria($adgroup_id);
# Purpose    : Get all criteria of an AgGroup
# Returns    : @criterions => List of Criterion objects
# Parameters : $adgroup_id => AdGroup ID
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getAllCriteria
{
    my ( $self, $adgroupid ) = @_;

    my @params;
    push @params, SOAP::Data->name( 'adGroupId' => $adgroupid )->type('');

    my $result = $self->_create_service_and_call(
        {
            service => 'CriterionService',
            method  => 'getAllCriteria',
            params  => \@params,
        }
    );

    my @data;
    foreach my $c (
        $result->valueof("//getAllCriteriaResponse/getAllCriteriaReturn") )
    {
        push @data, $self->_parse_criterion_response($c);
    }

    return @data;
} # end sub getAllCriteria

### INSTANCE METHOD ####################################################
# Usage      :
#   my @criterions = $obj->getCriteria($adgroup_id, \@criterion_ids);
# Purpose    : Get list of criteria
# Returns    : @criterions => List of Criterion objects
# Parameters :
#   1) $adgroup_id => AdGroup ID
#   2) \@criterion_ids => arrayref of Criterion ids
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getCriteria
{
    my ( $self, $adgroup_id, $criterion_ids_ref ) = @_;

    my @params;
    push @params, SOAP::Data->name( 'adGroupId' => $adgroup_id )->type('');
    push @params,
        SOAP::Data->name( 'criterionIds' => @{$criterion_ids_ref} )->type('');

    my $result = $self->_create_service_and_call(
        {
            service => 'CriterionService',
            method  => 'getCriteria',
            params  => \@params,
        }
    );

    my @data;
    foreach
        my $c ( $result->valueof("//getCriteriaResponse/getCriteriaReturn") )
    {
        push @data, $self->_parse_criterion_response($c);
    }

    return @data;
} # end sub getCriteria

### INSTANCE METHOD ################################################
# Usage      :
#   my @criterion_stats = $obj->getCriterionStats({
#       adGroupId       => 1234
#           criterionIds => [ 3982, 2787, 17872 ],
#           startDay    => $startDay,
#           endDay      => $endDay,
#   });
# Purpose    : Get stats on a set of criteria
# Returns    :  A list of StatsRecord object for each criterion
# Parameters :
#   adGroupId : The ad group that contains the criteria to be queried
#       creativeIds  : array reference of criteria ids
#       startDay : starting day of the stats YYYY-MM-DD
#       endDay : end day of the stats YYYY-MM-DD
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getCriterionStats
{
    my ( $self, $args_ref ) = @_;
    my $adgroupid = $args_ref->{adGroupId}    || 0;
    my $ra_id     = $args_ref->{criterionIds} || [];
    my $startDay  = $args_ref->{startDay}     || '';
    my $endDay    = $args_ref->{endDay}       || '';

    my @params;
    push @params, SOAP::Data->name( 'adGroupId'    => $adgroupid )->type('');
    push @params, SOAP::Data->name( 'criterionIds' => @{$ra_id} )->type('');
    push @params, SOAP::Data->name( 'startDay'     => $startDay )->type('');
    push @params, SOAP::Data->name( 'endDay'       => $endDay )->type('');

    my $result = $self->_create_service_and_call(
        {
            service => 'CriterionService',
            method  => 'getCriterionStats',
            params  => \@params,
        }
    );

    my @data;
    foreach my $c (
        $result->valueof(
            "//getCriterionStatsResponse/getCriterionStatsReturn")
        )
    {
        push @data,
            $self->_create_object_from_hash( $c,
            'Google::Adwords::StatsRecord' );
    }

    return @data;
} # end sub getCriterionStats

1;

=pod

=head1 NAME
 
Google::Adwords::CriterionService - Interact with the Google Adwords
CriterionService API calls
 
 
=head1 VERSION
 
This documentation refers to Google::Adwords::CriterionService version 0.4
 
 
=head1 SYNOPSIS

    use Google::Adwords::CriterionService;
    use Google::Adwords::Criterion;

    # create the CriterionService object
    my $criterion_service = Google::Adwords::CriterionService->new();

    # need to login to the Adwords service
    $criterion_service->email($email_address)
                     ->password($password)
                     ->developerToken($developer_token)
                     ->applicationToken($app_token);

    # if you have a MCC
    $criterion_service->clientEmail($client_email);
    # or 
    $criterion_service->clientCustomerId($customerid);

    my $adgroupid       = 123456789;

    # get all the criteria for an adgroup
    my @getallcriteria  = $criterion_service->getAllCriteria($adgroupid);
    for ( @getallcriteria ) {
        print "Criterion Id : " . $_->id . "\n";
    }

    # get a specific criterion from an AdGroup
    my $criterionid     = 987654321;

    my $getcriterion = $criterion_service->getCriteria($adgroupid, [ $criterionid ]);
    print "Got Criterion Id : " . $getcriterion->id . "\n";

    # remove a criterion
    my $ret     = $criterion_service->removeCriteria($adgroupid, [ $criterionid ]);
    
    # add a criterion
    my $criterion_keyword = Google::Adwords::Criterion->new
            ->adGroupId($adgroupid)
            ->criterionType('Keyword')
            ->type('Broad')
            ->text('Aarohan & Technologies');

    my $addcriterion    = $criterion_service->addCriteria($criterion_keyword);
    print "Added Criterion ID: " . $addcriterion->id . "\n";

  
=head1 DESCRIPTION

This module provides an interface to the Google Adwords CriterionService API
calls.

  
=head1 METHODS 

=head2 B<addCriteria()>

=head3 Description

    Add a new Criteria to this AdGroup.

=head3 Usage

    my @added_criteria = $service->addCriteria($criterion1, $criterion2);

=head3 Parameters

=over 4

A list of Google::Adwords::Criterion objects to be added

=back

=head3 Returns
 
=over 4

A list of the newly added criterions, each as a Google::Adwords::Criterion object

=back

=head2 B<checkCriteria()>

Not Implemented.

=head2 B<getAllCriteria()>

=head3 Description

=over 4

Return a list of criteria associated with this AdGroup.

=back

=head3 Usage

=over 4

    my @criteria = $obj->getAllCriteria($adgroup_id);

=back

=head3 Parameters

=over 4

1) $adgroup_id => the id of the AdGroup.

=back

=head3 Returns
 
=over 4

A list of Google::Adwords::Criterion objects.

=back

=head2 B<getCampaignNegativeCriteria()>

=head3 Description

=over 4

Gets a list of the negative criteria associated with a campaign. Negative criteria
determine where the ads in the campaign will not be displayed. Negative website
criteria indicate websites where the ads will not appear. Negative keyword criteria
indicate keywords that cause the ads to be excluded from display.

=back

=head3 Usage

    my @criteria = $obj->getCampaignNegativeCriteria($campaign_id);

=head3 Parameters

=over 4

=item 1) $campaign_id => The campaign ID

=back

=head3 Returns
 
=over 4

@criteria => A list of Google::Adwords::Criterion objects

=back

=head2 B<getCriteria()>

=head3 Description

=over 4

Return a list of criteria with the specified IDs associated with this AdGroup. This
function will only return criteria associated with one AdGroup at a time. Invalid IDs
are ignored.

=back

=head3 Usage

    my @criteria = $obj->getCriteria($adgroup_id, [ $criterion_id1 ]);

=head3 Parameters

=over 4

=item 1) $adgroup_id : the id of the AdGroup

=item 2) arrayref of Criterion Ids

=back

=head3 Returns
 
=over 4

@criteria => A list of Google::Adwords::Criterion objects

=back

=head2 B<getCriterionStats()>

=head3 Description

=over 4

Get statistics for a list of Criteria. See L<Google::Adwords::StatsRecord> 
for details about the statistics returned. The time granularity is one day.

Also see - 

http://www.google.com/apis/adwords/developer/StatsRecord.html

=back

=head3 Usage

   my @criterion_stats = $service->getCriterionStats({
        adGroupId   => 1234,
        criterionIds => [ 3982, 2787, 17872 ],
        startDay    => $startDay,
        endDay      => $endDay,
    });

=head3 Parameters

Takes a hashref with following keys,

=over 4

* adGroupId => The ad group that contains the criterion to be queried

* criterionIds => array reference of criterion ids

* startDay => The starting day of the period for which statistics are to 
be collected in format YYYY-MM-DD

* endDay => The ending day of the period for which statistics are to be
collected in format YYYY-MM-DD


=back


=head3 Returns
 
=over 4

A list of Google::Adwords::StatsRecord objects; one for each criterion.

=back

=head2 B<removeCriteria()>

=head3 Description

=over 4

Remove a list of Criteria from an AdGroup.

=back

=head3 Usage

    my $ret = $obj->removeCriteria($adGroupId, [ $criterionId ]);

=head3 Parameters

=over 4

=item 1) $adGroupId : the id of the adgroup

=item 2) array ref of criterion Ids

=back

=head3 Returns
 
=over 4

1 on success

=back

=head2 B<setCampaignNegativeCriteria()>

=head3 Description

=over 4

Removes all existing negative criteria from a campain and sets new negative criteria
for the specified campaign. Negative criteria determine where the ads in the campaign
will not be displayed. Negative website criteria indicate websites where the ads will
not appear. Negative keyword criteria indicate keywords that cause the ads to be
excluded from display.

Calling this method with a null or empty list clears the negative criteria for the
campaign. If your campaign already has some negative criteria and you want to add
more, first call getCampaignNegativeCriteria, then add the new negative criteria to
the results and send the complete set of negative criteria to
setCampaignNegativeCriteria.


=back

=head3 Usage

    my $ret = $obj->setCampaignNegativeCriteria($campaign_id, [ $criterion1 ]);

=head3 Parameters

=over 4

=item 1) $campaign_id => The campaign ID

=item 2) arrayref of Criterion objects

=back

=head3 Returns
 
=over 4

1 on success

=back

=head2 B<updateCriteria()>

=head3 Description

=over 4

Update all mutable fields associated with these Criteria. Only the maxCpc, maxCpm,
negative, paused, and destinationUrl fields are mutable.

=back

=head3 Usage

    my $ret = $service->updateCriteria($criterion1, $criterion2);

=head3 Parameters

=over 4

A List of Google::Adwords::Criterion objects to be updated

=back

=head3 Returns
 
=over 4

1 on success

=back

=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::Criterion>

=item * L<Google::Adwords::StatsRecord>

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


