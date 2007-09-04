package Google::Adwords::CreativeService;
use strict;
use warnings;

use version; our $VERSION = qv('0.3.1');

use base 'Google::Adwords::Service';

use Google::Adwords::Creative;
use Google::Adwords::Image;
use Google::Adwords::StatsRecord;

### INSTANCE METHOD ################################################
# Usage      :
#   my $addcreative = $obj->addCreative($creative);
# Purpose    : Add a new creative
# Returns    : Return a creative object
# Parameters : A Google::Adwords::Creative object
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub addCreative
{
    my ( $self, $creative ) = @_;

    if ( not defined $creative )
    {
        die "Must provide a defined creative object.";
    }
    if ( !UNIVERSAL::isa( $creative, 'Google::Adwords::Creative' ) )
    {
        die "Object is a not a Google::Adwords::Creative object.";
    }

    my @creative_params;

    if ( defined $creative->adGroupId )
    {
        push @creative_params,
            SOAP::Data->name( 'adGroupId' => $creative->adGroupId )->type('');
    }

    if ( defined $creative->destinationUrl )
    {
        push @creative_params,
            SOAP::Data->name( 'destinationUrl' => $creative->destinationUrl )
            ->type('');
    }

    if ( defined $creative->displayUrl )
    {
        push @creative_params,
            SOAP::Data->name( 'displayUrl' => $creative->displayUrl )
            ->type('');
    }

    # if we have image defined then it's an image, otherwise it's a text
    if ( defined $creative->image )
    {
        my $image = $creative->image;
        my @image_params;
        if ( defined $image->data )
        {
            push @image_params,
                SOAP::Data->name(
                'data' => SOAP::Data->type( base64 => $image->data ) )
                ->type('');
        }
        if ( defined $image->name )
        {
            push @image_params,
                SOAP::Data->name( 'name' => $image->name )->type('');
        }
        if ( defined $image->type )
        {
            push @image_params,
                SOAP::Data->name( 'type' => $image->type )->type('');
        }
        push @creative_params,
            SOAP::Data->name( 'image' => \SOAP::Data->value(@image_params) )
            ->type('');
    } # end if ( defined $creative...
    else
    {
        if ( defined $creative->headline )
        {
            push @creative_params,
                SOAP::Data->name( 'headline' => $creative->headline )
                ->type('');
        }
        if ( defined $creative->description1 )
        {
            push @creative_params,
                SOAP::Data->name( 'description1' => $creative->description1 )
                ->type('');
        }
        if ( defined $creative->description2 )
        {
            push @creative_params,
                SOAP::Data->name( 'description2' => $creative->description2 )
                ->type('');
        }
    }

    if ( defined $creative->exemptionRequest )
    {
        push @creative_params, SOAP::Data->name(
            'exemptionRequest' => $creative->exemptionRequest )->type('');
    }

    my @params;
    push @params,
        SOAP::Data->name( 'creative' => \SOAP::Data->value(@creative_params) )
        ->type('');

    my $result = $self->_create_service_and_call(
        {
            service => 'CreativeService',
            method  => 'addCreative',
            params  => \@params,
        }
    );

    # get response data in a hash
    my $data = $result->valueof("//addCreativeResponse/addCreativeReturn");

    if ( $data->{image} )
    {
        $data->{image} = $self->_create_object_from_hash( $data->{image},
            'Google::Adwords::Image' );
    }

    my $creative_response = $self->_create_object_from_hash( $data,
        'Google::Adwords::Creative' );

    return $creative_response;
} # end sub addCreative

### INSTANCE METHOD ################################################
# Usage      :
#   my @creative = $obj->addCreativeList($creative1, $creative2);
# Purpose    : Add a list of creatives
# Returns    : Return the list of created creatives
# Parameters : An array of Google::Adwords::Creative object
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub addCreativeList
{
    my ( $self, @creative_list ) = @_;

    if ( !@creative_list )
    {
        die "Must provide a defined creative object.";
    }

    my @params;

    foreach my $creative (@creative_list)
    {

        my @creative_params;

        if ( !UNIVERSAL::isa( $creative, 'Google::Adwords::Creative' ) )
        {
            die "Object is a not a Google::Adwords::Creative object.";
        }

        if ( defined $creative->adGroupId )
        {
            push @creative_params,
                SOAP::Data->name( 'adGroupId' => $creative->adGroupId )
                ->type('');
        }

        if ( defined $creative->destinationUrl )
        {
            push @creative_params, SOAP::Data->name(
                'destinationUrl' => $creative->destinationUrl )->type('');
        }

        if ( defined $creative->displayUrl )
        {
            push @creative_params,
                SOAP::Data->name( 'displayUrl' => $creative->displayUrl )
                ->type('');
        }

        # if we have image defined then it's an image, otherwise it's a text
        if ( defined $creative->image )
        {
            my $image = $creative->image;
            my @image_params;
            if ( defined $image->data )
            {
                push @image_params,
                    SOAP::Data->name(
                    'data' => SOAP::Data->type( base64 => $image->data ) )
                    ->type('');
            }
            if ( defined $image->name )
            {
                push @image_params,
                    SOAP::Data->name( 'name' => $image->name )->type('');
            }
            if ( defined $image->type )
            {
                push @image_params,
                    SOAP::Data->name( 'type' => $image->type )->type('');
            }
            push @creative_params, SOAP::Data->name(
                'image' => \SOAP::Data->value(@image_params) )->type('');
        } # end if ( defined $creative...
        else
        {
            if ( defined $creative->headline )
            {
                push @creative_params,
                    SOAP::Data->name( 'headline' => $creative->headline )
                    ->type('');
            }
            if ( defined $creative->description1 )
            {
                push @creative_params, SOAP::Data->name(
                    'description1' => $creative->description1 )->type('');
            }
            if ( defined $creative->description2 )
            {
                push @creative_params, SOAP::Data->name(
                    'description2' => $creative->description2 )->type('');
            }
        }

        if ( defined $creative->exemptionRequest )
        {
            push @creative_params, SOAP::Data->name(
                'exemptionRequest' => $creative->exemptionRequest )->type('');
        }
        push @params, SOAP::Data->name(
            'creative' => \SOAP::Data->value(@creative_params) )->type('');
    }

    my $result = $self->_create_service_and_call(
        {
            service => 'CreativeService',
            method  => 'addCreativeList',
            params  => \@params,
        }
    );

    my @data;
    foreach my $c (
        $result->valueof("//addCreativeListResponse/addCreativeListReturn") )
    {
        if ( $c->{image} )
        {
            $c->{image} = $self->_create_object_from_hash( $c->{image},
                'Google::Adwords::Image' );
        }
        push @data, $self->_create_object_from_hash( $c,
            'Google::Adwords::Creative' );
    }

    return @data;
} # end sub addCreativeList

### INSTANCE METHOD ################################################
# Usage      :
#   my @creatives = $obj->getActiveCreatives($adgroupid);
# Purpose    : Get all the active creatives for a given AdGroup
# Returns    : A list of Google::Adwords::Creative objects
# Parameters : The adgroupid from which we want the active creatives
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getActiveCreatives
{
    my ( $self, $adgroupid ) = @_;

    my @params;
    push @params, SOAP::Data->name( 'adGroupId' => $adgroupid )->type('');

    my $result = $self->_create_service_and_call(
        {
            service => 'CreativeService',
            method  => 'getActiveCreatives',
            params  => \@params,
        }
    );

    my @data;
    foreach my $c (
        $result->valueof(
            "//getActiveCreativesResponse/getActiveCreativesReturn")
        )
    {
        if ( $c->{image} )
        {
            $c->{image} = $self->_create_object_from_hash( $c->{image},
                'Google::Adwords::Image' );
        }
        push @data, $self->_create_object_from_hash( $c,
            'Google::Adwords::Creative' );
    }

    return @data;
} # end sub getActiveCreatives

### INSTANCE METHOD ################################################
# Usage      :
#   my @creatives = $obj->getAllCreatives($adgroupid);
# Purpose    : Get all the creatives for a given AdGroup
# Returns    : A list of Google::Adwords::Creative objects
# Parameters : The adgroupid from which we want all the creatives
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getAllCreatives
{
    my ( $self, $adgroupid ) = @_;

    my @params;
    push @params, SOAP::Data->name( 'adGroupId' => $adgroupid )->type('');

    my $result = $self->_create_service_and_call(
        {
            service => 'CreativeService',
            method  => 'getAllCreatives',
            params  => \@params,
        }
    );

    my @data;
    foreach my $c (
        $result->valueof("//getAllCreativesResponse/getAllCreativesReturn") )
    {
        if ( $c->{image} )
        {
            $c->{image} = $self->_create_object_from_hash( $c->{image},
                'Google::Adwords::Image' );
        }
        push @data, $self->_create_object_from_hash( $c,
            'Google::Adwords::Creative' );
    }

    return @data;
} # end sub getAllCreatives

### INSTANCE METHOD ################################################
# Usage      :
#   my $creative = $obj->getCreative($adgroupid, $creativeid);
# Purpose    : Get a given creative in a given adgroup
# Returns    : The requested creative as a Google::Adwords::Creative object.
# Parameters : The targeted adgroup id and creative id
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getCreative
{
    my ( $self, $adgroupid, $creativeid ) = @_;

    my @params;
    push @params, SOAP::Data->name( 'adGroupId'  => $adgroupid )->type('');
    push @params, SOAP::Data->name( 'creativeId' => $creativeid )->type('');

    my $result = $self->_create_service_and_call(
        {
            service => 'CreativeService',
            method  => 'getCreative',
            params  => \@params,
        }
    );

    my $data = $result->valueof("//getCreativeResponse/getCreativeReturn");
    if ( $data->{image} )
    {
        $data->{image} = $self->_create_object_from_hash( $data->{image},
            'Google::Adwords::Image' );
    }

    my $creative = $self->_create_object_from_hash( $data,
        'Google::Adwords::Creative' );

    return $creative;
} # end sub getCreative

### INSTANCE METHOD ################################################
# Usage      :
#   my @creative_stats = $obj->getCreativeStats({
#       adGroupId       => 1234
#           creativeIds => [ 3982, 2787, 17872 ],
#           startDay    => $startDay,
#           endDay      => $endDay,
#           inPST       => 1,
#   });
# Purpose    : Get stats on a set of creatives
# Returns    :  A list of StatsRecord object for each creative
# Parameters :
#   adGroupId : The ad group that contains the creative to be queried
#       creativeIds  : array reference of creative ids
#       startDay : starting day of the stats YYYY-MM-DD
#       endDay : end day of the stats YYYY-MM-DD
#       inPST : True = get stats in America/Los_Angeles timezone (Google headquarters) regardless of the parent account's localtimezone.
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getCreativeStats
{
    my ( $self, $args_ref ) = @_;
    my $adgroupid = $args_ref->{adGroupId}   || 0;
    my $ra_id     = $args_ref->{creativeIds} || [];
    my $startDay  = $args_ref->{startDay}    || '';
    my $endDay    = $args_ref->{endDay}      || '';
    my $inPST     = $args_ref->{inPST}       || 0;

    my @params;
    push @params, SOAP::Data->name( 'adGroupId'   => $adgroupid )->type('');
    push @params, SOAP::Data->name( 'creativeIds' => @{$ra_id} )->type('');
    push @params, SOAP::Data->name( 'startDay'    => $startDay )->type('');
    push @params, SOAP::Data->name( 'endDay'      => $endDay )->type('');
    push @params, SOAP::Data->name( 'inPST'       => $inPST )->type('');

    my $result = $self->_create_service_and_call(
        {
            service => 'CreativeService',
            method  => 'getCreativeStats',
            params  => \@params,
        }
    );

    my @data;
    foreach my $c (
        $result->valueof("//getCreativeStatsResponse/getCreativeStatsReturn")
        )
    {
        push @data,
            $self->_create_object_from_hash( $c,
            'Google::Adwords::StatsRecord' );
    }

    return @data;
} # end sub getCreativeStats

### INSTANCE METHOD ###################################################
# Usage      : $ret = $obj->updateCreatives(@creatives);
# Purpose    : update status of creatives
# Returns    : 1 on success
# Parameters :
#   @creatives => List of Creative objects
# Throws     : no exceptions
# Comments   : Only the status filed can be updated
# See Also   : n/a
#######################################################################
sub updateCreatives
{
    my ( $self, @creatives ) = @_;

    my @params;

    foreach my $creative (@creatives)
    {

        my @creative_params;

        if ( !UNIVERSAL::isa( $creative, 'Google::Adwords::Creative' ) )
        {
            die "Object is a not a Google::Adwords::Creative object.";
        }

        if ( not defined $creative->id )
        {
            die "id must be set for the Cretive object\n";
        }
        if ( not defined $creative->adGroupId )
        {
            die "adGroupId must be set for the Cretive object\n";
        }
        if ( not defined $creative->status )
        {
            die "status must be set for the Cretive object\n";
        }

        push @creative_params,
            SOAP::Data->name( 'id' => $creative->id )->type('');
        push @creative_params,
            SOAP::Data->name( 'adGroupId' => $creative->adGroupId )->type('');
        push @creative_params,
            SOAP::Data->name( 'status' => $creative->status )->type('');

        push @params, SOAP::Data->name(
            'creative' => \SOAP::Data->value(@creative_params) )->type('');
    }

    my $result = $self->_create_service_and_call(
        {
            service => 'CreativeService',
            method  => 'updateCreatives',
            params  => \@params,
        }
    );

    return 1;
} # end sub updateCreatives

1;

=pod

=head1 NAME
 
Google::Adwords::CreativeService - Interact with the Google Adwords
CreativeService API calls
 
 
=head1 VERSION
 
This documentation refers to Google::Adwords::CreativeService version 0.3.1
 
 
=head1 SYNOPSIS

    use Google::Adwords::CreativeService;
    use Google::Adwords::Image;
    use Google::Adwords::Creative;

    use File::Slurp;

    # create the CreativeService object
    my $creative_service = Google::Adwords::CreativeService->new();

    # need to login to the Adwords service
    $creative_service->email($email_address)
                     ->password($password)
                     ->developerToken($developer_token)
                     ->applicationToken($app_token);

    # if you have a MCC
    $creative_service->clientEmail($client_email);
    # or 
    $creative_service->clientCustomerId($customerid);

    my $adgroupid       = 123456789;

    # get all the creatives for an adgroup
    my @getallcreatives = $creative_service->getAllCreatives($adgroupid);
    for ( @getallcreatives ) {
        print "Creative name : " . $_->name . " , Id : " . $_->id . "\n";
    }

    # get a specific creative from an AdGroup
    my $creativeid      = 987654321;

    my $getcreative     = $creative_service->getCreative($adgroupid, $creativeid);
    print "Get creative: " . $getcreative->name . ", Id : " . $getcreative->id . "\n";

    # add a creative
    my $creative_text = Google::Adwords::Creative->new
            ->adGroupId($adgroupid)
            ->destinationUrl('http://www.example.com')
            ->displayUrl('http://www.example.com')
            ->headline('API : creative')
            ->description1('desc1 added via API')
            ->description2('desc2 added via API');

    my $addcreative     = $creative_service->addCreative($creative_text);
    print "Added Creative ID: " . $addcreative->id . "\n";

    # add a image creative
    my $data_blurb = read_file('image.gif');

    my $image   = Google::Adwords::Image->new
            ->name('Image #1')
            ->data($data_blurb)
            ->type('image');
    
    my $creative_image = Google::Adwords::Creative->new
            ->adGroupId($adgroupid)
            ->destinationUrl('http://www.example.com')
            ->displayUrl('http://www.example.com')
            ->image( $image );
    
    my $addcreative     = $creative_service->addCreative($creative_image);
    print "Added Creative ID: " . $addcreative->id . "\n";
    print "Image Height: " . $addcreative->image->height . "\n";

  
=head1 DESCRIPTION

This module provides an interface to the Google Adwords CreativeService API
calls. Please read L<Google::Adwords::Creative> on how to setup and receive
information about your creatives.

  
=head1 METHODS 

=head2 B<addCreative()>

=head3 Description

=over 4

Make a new Creative. The Creative can either be a text Creative or an image.

=back

=head3 Usage

=over 4

    my $creative_response = $obj->addCreative($creative);

=back

=head3 Parameters

=over 4

$creative => A Google::Adwords::Creative object

=back

=head3 Returns
 
=over 4

$creative_response => The newly added creative as a Google::Adwords::Creative object

=back

=head2 B<addCreativeList()>

=head3 Description

=over 4

Make a batch of new Creatives.

=back

=head3 Usage

=over 4

    my @creatives = $obj->addCreativeList($creative1, $creative2);

=back

=head3 Parameters

=over 4

A list of Google::Adwords::Creative objects

=back

=head3 Returns
 
=over 4

The list of created creatives, each as a Google::Adwords::Creative object

=back

=head2 B<getActiveCreatives()>

=head3 Description

=over 4

Return all active Creatives associated with an AdGroup.

=back

=head3 Usage

=over 4

    my @creatives = $obj->getActiveCreatives($adgroupid);

=back

=head3 Parameters

=over 4

1) $adgroupid : the id of the AdGroup.

=back

=head3 Returns
 
=over 4

A list of Google::Adwords::Creative objects.

=back

=head2 B<getAllCreatives()>

=head3 Description

=over 4

Return all Creatives (active and deleted) associated with an AdGroup

=back

=head3 Usage

=over 4

    my @creatives = $obj->getAllCreatives($adgroupid);

=back

=head3 Parameters

=over 4

1) $adgroupid : the id of the AdGroup.

=back

=head3 Returns
 
=over 4

A list of Google::Adwords::Creative objects.

=back

=head2 B<getCreative()>

=head3 Description

=over 4

Return information about one Creative.

=back

=head3 Usage

=over 4

    my $creative = $obj->getCreative($adgroupid, $creativeid);

=back

=head3 Parameters

=over 4

=item 1) $adgroupid : the id of the AdGroup

=item 2) $creativeid : the id of the Creative.

=back

=head3 Returns
 
=over 4

$creative => The creative info as a Google::Adwords::Creative object

=back

=head2 B<getCreativeStats()>

=head3 Description

=over 4

Get statistics for a list of Creatives. See L<Google::Adwords::StatsRecord> 
for details about the statistics returned. The time granularity is one day.

Also see - 

http://www.google.com/apis/adwords/developer/StatsRecord.html

=back

=head3 Usage

=over 4

   my @creative_stats = $obj->getCreativeStats({
        adGroupId   => 1234
        creativeIds => [ 3982, 2787, 17872 ],
        startDay    => $startDay,
        endDay      => $endDay,
        inPST       => 1,
    });

=back

=head3 Parameters

Takes a hashref with following keys,

=over 4

* adGroupId => The ad group that contains the creative to be queried

* creativeIds => array reference of creative ids

* startDay => The starting day of the period for which statistics are to 
be collected in format YYYY-MM-DD

* endDay => The ending day of the period for which statistics are to be
collected in format YYYY-MM-DD

* inPST => Set to 1 to get stats in America/Los_Angeles timezone (Google
headquarters) regardless of the parent account's localtimezone.

=back


=head3 Returns
 
=over 4

A list of Google::Adwords::StatsRecord objects; one for each creative.

=back

=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::Creative>

=item * L<Google::Adwords::Image>

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

