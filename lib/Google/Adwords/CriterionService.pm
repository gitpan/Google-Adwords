package Google::Adwords::CriterionService;
use strict; use warnings;

use version; our $VERSION = qv('0.3');

use base 'Google::Adwords::Service';

use Google::Adwords::Criterion;
use Google::Adwords::StatsRecord;


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
    my ($self, @criteria) = @_;

    my @params=();

    for my $criterion (@criteria){

     if ( !UNIVERSAL::isa($criterion, 'Google::Adwords::Criterion') ) {
      #next;
      die "Object is a not a Google::Adwords::Criterion object.";
     }
     if (not defined $criterion->adGroupId) {
        die "adGroupId must be set for the criterion\n";
     }
     if (not defined $criterion->criterionType) {
        die "criterionType must be set for the criterion\n";
     }
     my @criterion_params;
     
     push @criterion_params, SOAP::Data->name(
       'adGroupId' => $criterion->adGroupId )->type('');

      push @criterion_params, SOAP::Data->name(
       'criterionType' => $criterion->criterionType )->type('');

        for (qw/
            destinationUrl
            exemptionRequest
            language
            negative
            paused
            status
            maxCpc
            minCpc
            text
            type
            maxCpm
            url
        /)
        {
            if ( defined $criterion->$_ ) {
                push @criterion_params, SOAP::Data->name(
                  $_ => $criterion->$_ )->type('');
            }
        }

        push @params,
        SOAP::Data->name(
            'criterion' => \SOAP::Data->value(@criterion_params) )->type('');

    }

    my $result	= $self->_create_service_and_call({
     service	=> 'CriterionService',
     method	=> 'addCriteria',
     params	=> \@params,
    });
    
    my @data;
    foreach my $c ( $result->valueof("//addCriteriaResponse/addCriteriaReturn") ) {
     push @data, $self->_create_object_from_hash($c, 'Google::Adwords::Criterion');
    }

    return	@data;
}


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
    my ($self, $campaign_id, $criterions_ref) = @_;

    my @criterion_params;

    for my $criterion (@{$criterions_ref}){

     if ( !UNIVERSAL::isa($criterion, 'Google::Adwords::Criterion') ) {
      #next;
      die "Object is a not a Google::Adwords::Criterion object.";
     }
     if (not defined $criterion->adGroupId) {
        die "adGroupId must be set for the criterion\n";
     }
     if (not defined $criterion->criterionType) {
        die "criterionType must be set for the criterion\n";
     }
     my @criterion_params_inner;
     
     push @criterion_params_inner, SOAP::Data->name(
       'adGroupId' => $criterion->adGroupId )->type('');

      push @criterion_params_inner, SOAP::Data->name(
       'criterionType' => $criterion->criterionType )->type('');

        for (qw/
            destinationUrl
            exemptionRequest
            language
            negative
            paused
            status
            maxCpc
            minCpc
            text
            type
            maxCpm
            url
        /)
        {
            if ( defined $criterion->$_ ) {
                push @criterion_params_inner, SOAP::Data->name(
                  $_ => $criterion->$_ )->type('');
            }
        }

        push @criterion_params,
            SOAP::Data->name(
                'criterion' => \SOAP::Data->value(@criterion_params_inner) )->type('');

    }

    my @params;
    push @params,
     SOAP::Data->name(
      'campaignId' => $campaign_id )->type('');
    push @params,
     SOAP::Data->name(
      'criteria' => @criterion_params )->type('');


    my $result	= $self->_create_service_and_call({
     service	=> 'CriterionService',
     method	=> 'setCampaignNegativeCriteria',
     params	=> \@params,
    });
    
    return 1;
}



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
    my ($self, @criteria) = @_;

    my @params;

    for my $criterion (@criteria){
     if ( !UNIVERSAL::isa($criterion, 'Google::Adwords::Criterion') ) {
      #next;
      die "Object is a not a Google::Adwords::Criterion object.";
     }
     if (not defined $criterion->id) {
        die "id must be set for the criterion\n";
     }
     if (not defined $criterion->adGroupId) {
        die "adGroupId must be set for the criterion\n";
     }
     if (not defined $criterion->criterionType) {
        die "criterionType must be set for the criterion\n";
     }
     my @criterion_params_inner;
     
     push @criterion_params_inner, SOAP::Data->name(
       'id' => $criterion->id )->type('');
     push @criterion_params_inner, SOAP::Data->name(
       'adGroupId' => $criterion->adGroupId )->type('');
      push @criterion_params_inner, SOAP::Data->name(
       'criterionType' => $criterion->criterionType )->type('');

        for (qw/
            destinationUrl
            exemptionRequest
            language
            negative
            paused
            status
            maxCpc
            minCpc
            text
            type
            maxCpm
            url
        /)
        {
            if ( defined $criterion->$_ ) {
                push @criterion_params_inner, SOAP::Data->name(
                  $_ => $criterion->$_ )->type('');
            }
        }

        push @params,
        SOAP::Data->name(
            'criterion' => \SOAP::Data->value(@criterion_params_inner) )->type('');
    }

    my $result  = $self->_create_service_and_call({
     service    => 'CriterionService',
     method     => 'updateCriteria',
     params     => \@params,
    });

    return 1;
}




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
    my ($self, $adgroup_id, $criterion_ids_ref) = @_;

    my @params;
    push @params,
     SOAP::Data->name(
      'adGroupId' => $adgroup_id )->type('');
    push @params,
     SOAP::Data->name(
      'criterionIds' => @{$criterion_ids_ref} )->type('');

    my $result	= $self->_create_service_and_call({
     service	=> 'CriterionService',
     method	=> 'removeCriteria',
     params	=> \@params,
    });

    return	1;
}

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
    my ($self, $campaign_id) = @_;

    my @params;
    push @params,
     SOAP::Data->name(
      'campaignId' => $campaign_id )->type('');

    my $result	= $self->_create_service_and_call({
     service	=> 'CriterionService',
     method	=> 'getCampaignNegativeCriteria',
     params	=> \@params,
    });
    
    my @data;
    foreach my $c (
    $result->valueof("//getCampaignNegativeCriteriaResponse/getCampaignNegativeCriteriaReturn") ) {
        push @data, $self->_create_object_from_hash($c, 'Google::Adwords::Criterion');
    }

    return	@data;
}



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
    my ($self, $adgroupid) = @_;

    my @params;
    push @params,
     SOAP::Data->name(
      'adGroupId' => $adgroupid )->type('');

    my $result	= $self->_create_service_and_call({
     service	=> 'CriterionService',
     method	=> 'getAllCriteria',
     params	=> \@params,
    });
    
    my @data;
    foreach my $c ( $result->valueof("//getAllCriteriaResponse/getAllCriteriaReturn") ) {
     push @data, $self->_create_object_from_hash($c, 'Google::Adwords::Criterion');
    }

    return	@data;
}



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
    my ($self, $adgroup_id, $criterion_ids_ref) = @_;

    my @params;
    push @params,
     SOAP::Data->name(
      'adGroupId' => $adgroup_id )->type('');
    push @params,
     SOAP::Data->name(
      'criterionIds' => @{$criterion_ids_ref} )->type('');

    my $result	= $self->_create_service_and_call({
     service	=> 'CriterionService',
     method	=> 'getCriteria',
     params	=> \@params,
    });
    
    my @data;
    foreach my $c ( $result->valueof("//getCriteriaResponse/getCriteriaReturn") ) {
     push @data, $self->_create_object_from_hash($c, 'Google::Adwords::Criterion');
    }

    return	@data;
}

### INSTANCE METHOD ################################################
# Usage      : 
#   my @criterion_stats = $obj->getCriterionStats({
#       adGroupId	=> 1234
#	    criterionIds => [ 3982, 2787, 17872 ],
#	    startDay 	=> $startDay,
#	    endDay	=> $endDay,
#	    inPST	=> 1,
#   });
# Purpose    : Get stats on a set of criteria
# Returns    :  A list of StatsRecord object for each criterion
# Parameters : 
#   adGroupId : The ad group that contains the criteria to be queried
#	creativeIds  : array reference of criteria ids
#	startDay : starting day of the stats YYYY-MM-DD
#	endDay : end day of the stats YYYY-MM-DD
#	inPST : True = get stats in America/Los_Angeles timezone (Google headquarters) regardless of the parent account's localtimezone.
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getCriterionStats
{
 my ($self, $args_ref) = @_;
 my $adgroupid	= $args_ref->{adGroupId} || 0;
 my $ra_id	= $args_ref->{criterionIds} || [];
 my $startDay	= $args_ref->{startDay} || '';
 my $endDay	= $args_ref->{endDay}	|| '';
 my $inPST	= $args_ref->{inPST}	|| 0;

 my @params;
 push @params,
      SOAP::Data->name(
	'adGroupId' => $adgroupid )->type('');
 push @params,
      SOAP::Data->name(
	'criterionIds' => @{ $ra_id } )->type('');
 push @params,
      SOAP::Data->name(
	'startDay' => $startDay )->type('');
 push @params,
      SOAP::Data->name(
	'endDay' => $endDay )->type('');
 push @params,
      SOAP::Data->name(
	'inPST' => $inPST )->type('');
    
 my $result	= $self->_create_service_and_call({
   service	=> 'CriterionService',
   method	=> 'getCriterionStats',
   params	=> \@params,
   });

 my @data;
 foreach my $c (
 $result->valueof("//getCriterionStatsResponse/getCriterionStatsReturn") ) {
  push @data, $self->_create_object_from_hash($c, 'Google::Adwords::StatsRecord');
 }

 return	@data;
}



1;

=pod

=head1 NAME
 
Google::Adwords::CriterionService - Interact with the Google Adwords
CriterionService API calls
 
 
=head1 VERSION
 
This documentation refers to Google::Adwords::CriterionService version 0.3
 
 
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

    my $adgroupid	= 123456789;

    # get all the criteria for an adgroup
    my @getallcriteria	= $criterion_service->getAllCriteria($adgroupid);
    for ( @getallcriteria ) {
        print "Criterion name : " . $_->name . " , Id : " . $_->id . "\n";
    }

    # get a specific criterion from an AdGroup
    my $criterionid	= 987654321;

    my $getcriterion = $criterion_service->getCriteria($adgroupid, [ $criterionid ]);
    print "Get criterion: " . $getcriterion->name . ", Id : " . $getcriterion->id . "\n";

    # remove a criterion
    my $ret	= $criterion_service->removeCriteria($adgroupid, [ $criterionid ]);
    
    # add a criterion
    my $criterion_keyword = Google::Adwords::Criterion->new
            ->adGroupId($adgroupid)
            ->criterionType('Keyword')
            ->type('Broad')
            ->text('Aarohan & Technologies');

    my $addcriterion	= $criterion_service->addCriteria($criterion_keyword);
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
        inPST       => 1,
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

* inPST => Set to 1 to get stats in America/Los_Angeles timezone (Google
headquarters) regardless of the parent account's localtimezone.

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
 
=head1 LICENCE AND COPYRIGHT
 
Copyright (c) 2006 Rohan Almeida <rohan@almeida.in>. All rights
reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


