package Google::Adwords::AdGroupService;
use strict;
use warnings;

use version; our $VERSION = qv('0.2');

use base 'Google::Adwords::Service';
use Date::Manip;

use Google::Adwords::AdGroup;
use Google::Adwords::StatsRecord;

### INSTANCE METHOD ################################################
# Usage      :
#   my $adgroup = $obj->addAdGroup($campaign_id, $adgroup);
# Purpose    : Add a new AdGroup to a campaign
# Returns    : The newly created AdGroup
# Parameters :
#   1) $campaign_id => Campaign ID
#   2) $adgroup => A Google::Adwords::AdGroup object
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub addAdGroup
{
    my ( $self, $campaignId, $adgroup ) = @_;

    # campaignId should be present
    if ( not defined $campaignId )
    {
        die "campaignId should be set.";
    }
    if ( not defined $adgroup )
    {
        die "adgroup object must be specified.";
    }
    if (    ( not defined $adgroup->maxCpc )
        and ( not defined $adgroup->maxCpm ) )
    {
        die "adgroup must have either maxCpm or maxCpc set.";
    }

    my @adgroup_params;

    # adgroup name
    if ( defined $adgroup->name )
    {
        push @adgroup_params,
            SOAP::Data->name( 'name' => $adgroup->name )->type('');
    }

    # status
    if ( defined $adgroup->status )
    {
        push @adgroup_params,
            SOAP::Data->name( 'status' => $adgroup->status )->type('');
    }

    # maxContentCpc
    if ( defined $adgroup->maxContentCpc )
    {
        push @adgroup_params,
            SOAP::Data->name( 'maxContentCpc' => $adgroup->maxContentCpc )
            ->type('');
    }

    # maxCpc
    if ( defined $adgroup->maxCpc )
    {
        push @adgroup_params,
            SOAP::Data->name( 'maxCpc' => $adgroup->maxCpc )->type('');
    }

    # maxCpm
    if ( defined $adgroup->maxCpm )
    {
        push @adgroup_params,
            SOAP::Data->name( 'maxCpm' => $adgroup->maxCpm )->type('');
    }

    my @params;
    push @params,
        SOAP::Data->name('campaignID')->value($campaignId)->type('');
    push @params,
        SOAP::Data->name( 'newData' => \SOAP::Data->value(@adgroup_params) )
        ->type('');

    # create the SOAP service
    my $result = $self->_create_service_and_call(
        {
            service => 'AdGroupService',
            method  => 'addAdGroup',
            params  => \@params,
        }
    );

    # get response data in a hash
    my $data = $result->valueof("//addAdGroupResponse/addAdGroupReturn");

    # get adgroup object
    my $adgroup_response = $self->_create_object_from_hash( $data,
        'Google::Adwords::AdGroup' );

    return $adgroup_response;
} # end sub addAdGroup

### INSTANCE METHOD ################################################
# Usage      :
#   my @adgroups = $obj->addAdGroupList($campaign_id, \@adgroups_to_add);
# Purpose    : Add a new AdGroup to a campaign
# Returns    : The newly created AdGroup
# Parameters :
#   1) $campaign_id => Campaign ID
#   2) $adgroup => A Google::Adwords::AdGroup object
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub addAdGroupList
{
    my ( $self, $campaignId, $adgroups_to_add_ref ) = @_;

    # campaignId should be present
    if ( not defined $campaignId )
    {
        die "campaignId should be set.";
    }

    for ( @{$adgroups_to_add_ref} )
    {
        if ( ( not defined $_->maxCpc ) and ( not defined $_->maxCpm ) )
        {
            die "adgroup must have either maxCpm or maxCpc set.";
        }
    }

    my @params;
    push @params,
        SOAP::Data->name('campaignID')->value($campaignId)->type('');

    for my $adgroup ( @{$adgroups_to_add_ref} )
    {
        my @adgroup_params;

        # adgroup name
        if ( defined $adgroup->name )
        {
            push @adgroup_params,
                SOAP::Data->name( 'name' => $adgroup->name )->type('');
        }

        # status
        if ( defined $adgroup->status )
        {
            push @adgroup_params,
                SOAP::Data->name( 'status' => $adgroup->status )->type('');
        }

        # maxContentCpc
        if ( defined $adgroup->maxContentCpc )
        {
            push @adgroup_params,
                SOAP::Data->name( 'maxContentCpc' => $adgroup->maxContentCpc )
                ->type('');
        }

        # maxCpc
        if ( defined $adgroup->maxCpc )
        {
            push @adgroup_params,
                SOAP::Data->name( 'maxCpc' => $adgroup->maxCpc )->type('');
        }

        # maxCpm
        if ( defined $adgroup->maxCpm )
        {
            push @adgroup_params,
                SOAP::Data->name( 'maxCpm' => $adgroup->maxCpm )->type('');
        }

        push @params,
            SOAP::Data->name( newData => \SOAP::Data->value(@adgroup_params) )
            ->type('');
    } # end for my $adgroup ( @{$adgroups_to_add_ref...

    # create the SOAP service
    my $result = $self->_create_service_and_call(
        {
            service => 'AdGroupService',
            method  => 'addAdGroupList',
            params  => \@params,
        }
    );

    my @data;
    for my $a (
        $result->valueof("//addAdGroupListResponse/addAdGroupListReturn") )
    {

        # get adgroup object
        push @data,
            $self->_create_object_from_hash( $a, 'Google::Adwords::AdGroup' );
    }

    return @data;
} # end sub addAdGroupList

### INSTANCE METHOD ################################################
# Usage      :
#   my $adgroup = $obj->getAdGroup($id);
# Purpose    : Get the specified AdGroup
# Returns    : the adgroup object
# Parameters : the id of the adgroup
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getAdGroup
{
    my ( $self, $id ) = @_;

    my @params;
    push @params, SOAP::Data->name( 'adGroupId' => $id )->type('');

    my $result = $self->_create_service_and_call(
        {
            service => 'AdGroupService',
            method  => 'getAdGroup',
            params  => \@params,
        }
    );

    my $data = $result->valueof("//getAdGroupResponse/getAdGroupReturn");

    my $adgroup_response = $self->_create_object_from_hash( $data,
        'Google::Adwords::AdGroup' );

    return $adgroup_response;
} # end sub getAdGroup

### INSTANCE METHOD ################################################
# Usage      :
#   my @adgroups = $obj->getAdGroupList(@adgroup_ids);
# Purpose    : Get details on a specific list of adgroups
# Returns    : An list of adgroup objects
# Parameters : An list of adgroup ids to be fetched
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getAdGroupList
{
    my ( $self, @ids ) = @_;

    my @params;
    push @params, SOAP::Data->name( 'adgroupIDs' => @ids )->type('');

    my $result = $self->_create_service_and_call(
        {
            service => 'AdGroupService',
            method  => 'getAdGroupList',
            params  => \@params,
        }
    );

    my @data;
    foreach my $c (
        $result->valueof("//getAdGroupListResponse/getAdGroupListReturn") )
    {
        push @data,
            $self->_create_object_from_hash( $c, 'Google::Adwords::AdGroup' );
    }

    return @data;
} # end sub getAdGroupList

### INSTANCE METHOD ################################################
# Usage      :
#   my @adgroups = $obj->getAllAdGroups($campaignID);
# Purpose    : Get all the campaign's adgroups
# Returns    : An array of AdGroups objects
# Parameters : A campaign Id
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getAllAdGroups
{
    my ( $self, $id ) = @_;

    if ( not defined $id )
    {
        die "must give a campaignId.";
    }

    my @params;
    push @params, SOAP::Data->name( 'campaignID' => $id )->type('');

    my $result = $self->_create_service_and_call(
        {
            service => 'AdGroupService',
            method  => 'getAllAdGroups',
            params  => \@params,
        }
    );

    my @data;
    foreach my $c (
        $result->valueof("//getAllAdGroupsResponse/getAllAdGroupsReturn") )
    {
        push @data,
            $self->_create_object_from_hash( $c, 'Google::Adwords::AdGroup' );
    }

    return @data;
} # end sub getAllAdGroups

### INSTANCE METHOD ################################################
# Usage      :
#   my @adgroup_stats = $obj->getAdGroupStats({
#       campaignId      => $campaignId
#           adGroupIds  => [ arrayref of adgroup ids ],
#           startDay => $startDay,
#           endDay      => $endDay,
#   });
# Purpose    : Get stats on a set of adgroups
# Returns    : StatsRecord object for each adgroup
# Parameters :
#       campaignId : the campaign in which to find the ad group
#       adGroupIds  : array reference of adgroup ids
#       startDay : starting day of the stats YYYY-MM-DD
#       endDay : end day of the stats YYYY-MM-DD
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getAdGroupStats
{
    my ( $self, $args_ref ) = @_;
    my $campaignId = $args_ref->{campaignId} || 0;
    my $ra_id      = $args_ref->{adGroupIds} || [];
    my $startDay   = $args_ref->{startDay}   || '';
    my $endDay     = $args_ref->{endDay}     || '';

    my @params;
    push @params, SOAP::Data->name( 'campaignId' => $campaignId )->type('');
    push @params, SOAP::Data->name( 'adGroupIds' => @{$ra_id} )->type('');
    push @params, SOAP::Data->name( 'startDay'   => $startDay )->type('');
    push @params, SOAP::Data->name( 'endDay'     => $endDay )->type('');

    my $result = $self->_create_service_and_call(
        {
            service => 'AdGroupService',
            method  => 'getAdGroupStats',
            params  => \@params,
        }
    );

    my @data;
    foreach my $c (
        $result->valueof("//getAdGroupStatsResponse/getAdGroupStatsReturn") )
    {
        push @data,
            $self->_create_object_from_hash( $c,
            'Google::Adwords::StatsRecord' );
    }

    return @data;
} # end sub getAdGroupStats

### INSTANCE METHOD ################################################
# Usage      :
#   my $ret = $obj->updateAdGroup($adgroup);
# Purpose    : Update an existing AdGroup
# Returns    : none
# Parameters : AdGroup object
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub updateAdGroup
{
    my ( $self, $adgroup ) = @_;

    if ( not defined $adgroup )
    {
        die "adgroup object must be specified.";
    }
    if ( not defined $adgroup->id )
    {
        die "adgroup id must be specified.";
    }

    my @adgroup_params;

    # adgroup id
    push @adgroup_params, SOAP::Data->name( 'id' => $adgroup->id )->type('');

    # adgroup name
    if ( defined $adgroup->name )
    {
        push @adgroup_params,
            SOAP::Data->name( 'name' => $adgroup->name )->type('');
    }

    # status
    if ( defined $adgroup->status )
    {
        push @adgroup_params,
            SOAP::Data->name( 'status' => $adgroup->status )->type('');
    }

    # maxCpc
    if ( defined $adgroup->maxCpc )
    {
        push @adgroup_params,
            SOAP::Data->name( 'maxCpc' => $adgroup->maxCpc )->type('');
    }

    # maxContentCpc
    if ( defined $adgroup->maxContentCpc )
    {
        push @adgroup_params,
            SOAP::Data->name( 'maxContentCpc' => $adgroup->maxContentCpc )
            ->type('');
    }

    # maxCpm
    if ( defined $adgroup->maxCpm )
    {
        push @adgroup_params,
            SOAP::Data->name( 'maxCpm' => $adgroup->maxCpm )->type('');
    }

    my @params;
    push @params, SOAP::Data->name(
        'changedData' => \SOAP::Data->value(@adgroup_params) )->type('');

    # create the SOAP service
    my $result = $self->_create_service_and_call(
        {
            service => 'AdGroupService',
            method  => 'updateAdGroup',
            params  => \@params,
        }
    );

    return 1;
} # end sub updateAdGroup

### INSTANCE METHOD ################################################
# Usage      :
#   my $ret = $obj->updateAdGroupList(@adgroups);
# Purpose    : Update a list of existing AdGroups
# Returns    : 1 on success
# Parameters : List of AdGroup objects
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub updateAdGroupList
{
    my ( $self, @adgroups ) = @_;

    # check that ids are specified
    for (@adgroups)
    {
        if ( not defined $_->id )
        {
            die "adgroup id must be specified.";
        }
    }

    my @params;

    for my $adgroup (@adgroups)
    {

        my @adgroup_params;

        # adgroup id
        push @adgroup_params,
            SOAP::Data->name( 'id' => $adgroup->id )->type('');

        # adgroup name
        if ( defined $adgroup->name )
        {
            push @adgroup_params,
                SOAP::Data->name( 'name' => $adgroup->name )->type('');
        }

        # status
        if ( defined $adgroup->status )
        {
            push @adgroup_params,
                SOAP::Data->name( 'status' => $adgroup->status )->type('');
        }

        # maxCpc
        if ( defined $adgroup->maxCpc )
        {
            push @adgroup_params,
                SOAP::Data->name( 'maxCpc' => $adgroup->maxCpc )->type('');
        }

        # maxCpm
        if ( defined $adgroup->maxCpm )
        {
            push @adgroup_params,
                SOAP::Data->name( 'maxCpm' => $adgroup->maxCpm )->type('');
        }

        push @params, SOAP::Data->name(
            'changedData' => \SOAP::Data->value(@adgroup_params) )->type('');
    } # end for my $adgroup (@adgroups...

    # create the SOAP service
    my $result = $self->_create_service_and_call(
        {
            service => 'AdGroupService',
            method  => 'updateAdGroupList',
            params  => \@params,
        }
    );

    return 1;
} # end sub updateAdGroupList

1;

__END__

=pod

=head1 NAME
 
Google::Adwords::AdGroupService - Interact with the Google Adwords
AdGroupService API calls
 
=head1 VERSION
 
This documentation refers to Google::Adwords::AdGroupService version 0.2
 
=head1 SYNOPSIS
 
    use Google::Adwords::AdGroup;
    use Google::Adwords::AdGroupService;

    # create a new adgroup object
    my $adgroup = Google::Adwords::AdGroup->new;

    # set values for the adgroup object
    $adgroup->name('My Final Try');
    $adgroup->maxCpc(500000);
  
    # create the adgroup service object
    my $adgroup_service = Google::Adwords::AdGroupService->new();

    # need to login to the Adwords service
    $adgroup_service->email($email_address)
                     ->password($password)
                     ->developerToken($developer_token)
                     ->applicationToken($application_token);

    # if you use a MCC
    #$adgroup_service->clientEmail($client_email);
    # or 
    #$adgroup_service->clientCustomerId($customerid);

    # now create the adgroup
    my $campaignId = 1234; # within this campaign
    my $adgroup_response = $adgroup_service->addAdGroup($campaignId, $adgroup);

    print "New adgroup ID is :" . $adgroup_response->id;
 
  
  
=head1 METHODS 
 
=head2 B<addAdGroup()>

=head3 Description

=over 4

Create a new AdGroup.

=back

=head3 Usage

=over 4

    my $adgroup = $obj->addAdGroup($campaignId, $adgroup_obj);

=back

=head3 Parameters

Takes the campaignId in which the adgroup is to be added
and a Google::Adwords::AdGroup object.

=head3 Returns
 
=over 4

$adgroup => The new adgroup details as a Google::Adwords::AdGroup object

=back

=head2 B<addAdGroupList()>

=head3 Description

=over 4

Create multiple new AdGroups. All the AdGroups must be associated with the
same Campaign.

=back

=head3 Usage

=over 4

    my @adgroups = $obj->addAdGroupList($campaignId, \@adgroups_to_add);

=back

=head3 Parameters

=over 4

=item * $campaignId => Campaign ID

=item * \@adgroups_to_add => arrayref of Google::Adwords::AdGroup objects

=back


=head3 Returns
 
=over 4

@adgroups => List of AdGroup objects with details filled in.

=back

=head2 B<getAdGroup()>

=head3 Description

=over 4

Get information on an existing adgroup.

=back

=head3 Usage

=over 4

    my $adgroup = $obj->getAdGroup($id);

=back

=head3 Parameters

Takes the id of the targeted adgroup.

=head3 Returns
 
=over 4

$adgroup => The adgroup details as a Google::Adwords::AdGroup object

=back

=head2 B<getAdGroupList()>

=head3 Description

=over 4

Get details on a specific list of adgroups

=back

=head3 Usage

=over 4

    my @adgroup_ids = (1001, 1002, 1003);
    my @adgroups = $obj->getAdGroupList(@adgroup_ids);

=back

=head3 Parameters

A list of adgroup ids.

=head3 Returns
 
=over 4

A list of Adgroup objects

=back

=head2 B<getAdGroupStats()>

=head3 Description

=over 4

Get statistics for a list of ad groups in a campaign. Returns the statictics
as a Google::Adwords::StatsRecord object for each adgroup. The time granularity 
is one day.

=back

=head3 Usage

=over 4

    my @stats = $obj->getAdGroupStats({
        campaignId => $campaignId,
        adGroupIds      => [ $id1, $id2, $id3 ],
        startDay => '2006-08-01'
        endDay  => '2006-08-31',
    });

=back

=head3 Parameters

Takes a hashref with keys - 

=over 4

=item * campaignId - The campaign in which to find the ad groups


=item * adGroupIds - arrayref of adgroup ids


=item * startDay - The starting day of the period for which statistics are to
be collected. Format is YYYY-MM-DD


=item * endDay - The ending day of the period for which statistics are to be
collected, inclusive. Format is YYYY-MM-DD



=back

=head3 Returns
 
=over 4

A list of Google::Adwords::StatsRecord objects for each adgroup.

=back

=head2 B<getAllAdGroups()>

=head3 Description

=over 4

Get all information about the adgroups associated with a campaign.

=back

=head3 Usage

=over 4

        my @adgroups = $obj->getAllAdGroups($campaignId);

=back

=head3 Parameters

The id of the campaign.

=head3 Returns
 
=over 4

@adgroups => An list of all the adgroups, each as a Google::Adwords::AdGroup object

=back

=head2 B<updateAdGroup()>

=head3 Description

=over 4

Update the fields of an existing adgroup

=back

=head3 Usage

=over 4

    my $adgroup = Google::Adwords::AdGroup->new;
    $adgroup->id(1001);
    $adgroup->maxCpc(700000);

    my $ret = $obj->updateAdGroup($adgroup);

=back

=head3 Parameters

    A Google::Adwords::AdGroup object which needs to be updated.

=head3 Returns

1 on success
 
=over 4

=back

=head2 B<updateAdGroupList()>

=head3 Description

=over 4

Update the fields of multiple existing adgroups

=back

=head3 Usage

=over 4

    my $adgroup1 = Google::Adwords::AdGroup->new;
    $adgroup1->id(1001);
    $adgroup1->maxCpc(700000);

    my $adgroup2 = Google::Adwords::AdGroup->new;
    $adgroup2->id(1002);
    $adgroup2->maxCpm(700000);

    my $ret = $obj->updateAdGroupList(qw/$adgroup1 $adgroup2/);

=back

=head3 Parameters

    A list of Google::Adwords::AdGroup objects which needs to be updated.

=head3 Returns

1 on success
 
=over 4

=back


=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::AdGroup>

=item * L<Google::Adwords::StatsRecord>

=back


=head1 AUTHOR
 
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

