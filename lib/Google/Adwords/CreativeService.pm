package Google::Adwords::CreativeService;
use strict; use warnings;

use version; our $VERSION = qv('0.2');

use base 'Google::Adwords::Service';

use Google::Adwords::Creative;
use Google::Adwords::Image;

### INSTANCE METHOD ################################################
# Usage      : 
#   my $ret = $obj->activateCreative($adGroupId, $creativeId);
# Purpose    : Activate a given creative in a given adgroup
# Returns    : Always return 1
# Parameters : AdGroup Id and Creative Id
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub activateCreative
{
    my ($self, $adgroupid, $creativeid) = @_;

    my @params;
    push @params,
     SOAP::Data->name(
      'adGroupId' => $adgroupid )->type('');
    push @params,
     SOAP::Data->name(
      'creativeId' => $creativeid )->type('');

    my $result	= $self->_create_service_and_call({
     service	=> 'CreativeService',
     method	=> 'activateCreative',
     params	=> \@params,
    });

    return	1;
}

### INSTANCE METHOD ################################################
# Usage      : 
#   my $ret = $obj->activateCreativeList(
#       {
#           adGroupId => 1,
#           creativeId => 1,
#       },
#       {
#           adGroupId => 5,
#           creativeId => 2,
#       },
#   );
# Purpose    : Mark a list of creatives as active
# Returns    : Always return 1
# Parameters : A list of hashrefs
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub activateCreativeList
{
    my ($self, @pairs) = @_;

    my @adgroupids;
    my @creativeids;

    for ( @pairs ) {
     push @adgroupids, $_->{adGroupId};
     push @creativeids, $_->{creativeId};
    }

    my @params;
    push @params,
     SOAP::Data->name(
      'adGroupIds' => @adgroupids )->type('');
    push @params,
     SOAP::Data->name(
      'creativeIds' => @creativeids )->type('');

    my $result	= $self->_create_service_and_call({
     service	=> 'CreativeService',
     method	=> 'activateCreativeList',
     params	=> \@params,
    });

    return	1;
}

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
    my ($self, $creative) = @_;

    if ( not defined $creative ) {
     die "Must provide a defined creative object.";
    }
    if ( !UNIVERSAL::isa($creative, 'Google::Adwords::Creative') ) {
     die "Object is a not a Google::Adwords::Creative object.";
    }

    my @creative_params;
    
    if ( defined $creative->adGroupId ) {
     push @creative_params, SOAP::Data->name(
       'adGroupId' => $creative->adGroupId )->type('');
    }

    if ( defined $creative->destinationUrl ) {
     push @creative_params, SOAP::Data->name(
       'destinationUrl' => $creative->destinationUrl )->type('');
    }

    if ( defined $creative->displayUrl ) {
     push @creative_params, SOAP::Data->name(
       'displayUrl' => $creative->displayUrl )->type('');
     }

    # if we have image defined then it's an image, otherwise it's a text
    if ( defined $creative->image ) {
     my $image	= $creative->image;
     my @image_params;
     if ( defined $image->data ) {
      push @image_params, SOAP::Data->name(
       'data' => SOAP::Data->type( base64 => $image->data ) )->type('');
     }
     if ( defined $image->name ) {
      push @image_params, SOAP::Data->name(
	'name' => $image->name )->type('');
     }
     if ( defined $image->type ) {
      push @image_params, SOAP::Data->name(
	'type' => $image->type )->type('');
     }
     push @creative_params, SOAP::Data->name(
      'image'	=> \SOAP::Data->value(@image_params) )->type('');
    } else {
     if ( defined $creative->headline ) {
      push @creative_params, SOAP::Data->name(
	'headline' => $creative->headline )->type('');
     }
     if ( defined $creative->description1 ) {
      push @creative_params, SOAP::Data->name(
	'description1' => $creative->description1 )->type('');
     }
     if ( defined $creative->description2 ) {
      push @creative_params, SOAP::Data->name(
	'description2' => $creative->description2 )->type('');
     }
    }

    if ( defined $creative->exemptionRequest ) {
     push @creative_params, SOAP::Data->name(
      'exemptionRequest' => $creative->exemptionRequest )->type('');
    }

    my @params;
    push @params,
     SOAP::Data->name(
      'creative' => \SOAP::Data->value(@creative_params) )->type('');

    my $result	= $self->_create_service_and_call({
     service	=> 'CreativeService',
     method	=> 'addCreative',
     params	=> \@params,
    });
    
    # get response data in a hash
    my $data = $result->valueof("//addCreativeResponse/addCreativeReturn");

     if ( $data->{image} ) {
      $data->{image} = 
       $self->_create_object_from_hash($data->{image}, 'Google::Adwords::Image');
     }

    my $creative_response = 
     $self->_create_object_from_hash($data, 'Google::Adwords::Creative');

    return	$creative_response;
}

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
    my ($self, @creative_list) = @_;

    if ( !@creative_list ) {
     die "Must provide a defined creative object.";
    }
    
    my @params;

    foreach my $creative ( @creative_list ) {

     my @creative_params;
      
     if ( !UNIVERSAL::isa($creative, 'Google::Adwords::Creative') ) {
      die "Object is a not a Google::Adwords::Creative object.";
     }

     if ( defined $creative->adGroupId ) {
      push @creative_params, SOAP::Data->name(
	'adGroupId' => $creative->adGroupId )->type('');
     }

     if ( defined $creative->destinationUrl ) {
      push @creative_params, SOAP::Data->name(
	'destinationUrl' => $creative->destinationUrl )->type('');
     }

     if ( defined $creative->displayUrl ) {
      push @creative_params, SOAP::Data->name(
	'displayUrl' => $creative->displayUrl )->type('');
     }

     # if we have image defined then it's an image, otherwise it's a text
     if ( defined $creative->image ) {
      my $image	= $creative->image;
      my @image_params;
      if ( defined $image->data ) {
       push @image_params, SOAP::Data->name(
	 'data' => SOAP::Data->type( base64 => $image->data ) )->type('');
      }
      if ( defined $image->name ) {
       push @image_params, SOAP::Data->name(
	 'name' => $image->name )->type('');
      }
      if ( defined $image->type ) {
       push @image_params, SOAP::Data->name(
	 'type' => $image->type )->type('');
      }
      push @creative_params, SOAP::Data->name(
	'image'	=> \SOAP::Data->value(@image_params) )->type('');
     } else {
      if ( defined $creative->headline ) {
       push @creative_params, SOAP::Data->name(
	 'headline' => $creative->headline )->type('');
      }
      if ( defined $creative->description1 ) {
       push @creative_params, SOAP::Data->name(
	 'description1' => $creative->description1 )->type('');
      }
      if ( defined $creative->description2 ) {
       push @creative_params, SOAP::Data->name(
	 'description2' => $creative->description2 )->type('');
      }
     }

     if ( defined $creative->exemptionRequest ) {
      push @creative_params, SOAP::Data->name(
	'exemptionRequest' => $creative->exemptionRequest )->type('');
     }
     push @params, SOAP::Data->name(
      'creative' => \SOAP::Data->value(@creative_params) )->type('');
    }


    my $result	= $self->_create_service_and_call({
     service	=> 'CreativeService',
     method	=> 'addCreativeList',
     params	=> \@params,
    });
    
    my @data;
    foreach my $c ( $result->valueof("//addCreativeListResponse/addCreativeListReturn") ) {
     if ( $c->{image} ) {
      $c->{image} = 
       $self->_create_object_from_hash($c->{image}, 'Google::Adwords::Image');
     }
     push @data, $self->_create_object_from_hash($c, 'Google::Adwords::Creative');
    }

    return	@data;
}


### INSTANCE METHOD ################################################
# Usage      : 
#   my $ret = $obj->deleteCreative($adGroupId, $creativeId);
# Purpose    : Mark a creative as deleted
# Returns    : Always return 1
# Parameters : The adgroupid and the creative id to be deleted
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub deleteCreative
{
    my ($self, $adgroupid, $creativeid) = @_;

    my @params;
    push @params,
     SOAP::Data->name(
      'adGroupId' => $adgroupid )->type('');
    push @params,
     SOAP::Data->name(
      'creativeId' => $creativeid )->type('');

    my $result	= $self->_create_service_and_call({
     service	=> 'CreativeService',
     method	=> 'deleteCreative',
     params	=> \@params,
    });

    return	1;
}

### INSTANCE METHOD ################################################
# Usage      : 
#   my $ret = $obj->deleteCreativeList(
#       {
#           adGroupId => 1,
#           creativeId => 1,
#       },
#       {
#           adGroupId => 5,
#           creativeId => 2,
#       },
#   );
# Purpose    : Mark a list of creatives as deleted
# Returns    : Always return 1
# Parameters : A list of hashrefs
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub deleteCreativeList
{
    my ($self, @pairs) = @_;

    my @adgroupids;
    my @creativeids;

    for ( @pairs ) {
     push @adgroupids, $_->{adGroupId};
     push @creativeids, $_->{creativeId};
    }

    my @params;
    push @params,
     SOAP::Data->name(
      'adGroupIds' => @adgroupids )->type('');
    push @params,
     SOAP::Data->name(
      'creativeIds' => @creativeids )->type('');

    my $result	= $self->_create_service_and_call({
     service	=> 'CreativeService',
     method	=> 'deleteCreativeList',
     params	=> \@params,
    });

    return	1;
}


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
    my ($self, $adgroupid) = @_;

    my @params;
    push @params,
     SOAP::Data->name(
      'adGroupId' => $adgroupid )->type('');

    my $result	= $self->_create_service_and_call({
     service	=> 'CreativeService',
     method	=> 'getActiveCreatives',
     params	=> \@params,
    });
    
    my @data;
    foreach my $c ( $result->valueof("//getActiveCreativesResponse/getActiveCreativesReturn") ) {
     if ( $c->{image} ) {
      $c->{image} = 
       $self->_create_object_from_hash($c->{image}, 'Google::Adwords::Image');
     }
     push @data, $self->_create_object_from_hash($c, 'Google::Adwords::Creative');
    }

    return	@data;
}

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
    my ($self, $adgroupid) = @_;

    my @params;
    push @params,
     SOAP::Data->name(
      'adGroupId' => $adgroupid )->type('');

    my $result	= $self->_create_service_and_call({
     service	=> 'CreativeService',
     method	=> 'getAllCreatives',
     params	=> \@params,
    });
    
    my @data;
    foreach my $c ( $result->valueof("//getAllCreativesResponse/getAllCreativesReturn") ) {
     if ( $c->{image} ) {
      $c->{image} = 
       $self->_create_object_from_hash($c->{image}, 'Google::Adwords::Image');
     }
     push @data, $self->_create_object_from_hash($c, 'Google::Adwords::Creative');
    }

    return	@data;
}

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
    my ($self, $adgroupid, $creativeid) = @_;

    my @params;
    push @params,
     SOAP::Data->name(
      'adGroupId' => $adgroupid )->type('');
    push @params,
     SOAP::Data->name(
      'creativeId' => $creativeid )->type('');

    my $result	= $self->_create_service_and_call({
     service	=> 'CreativeService',
     method	=> 'getCreative',
     params	=> \@params,
    });

    my $data	= $result->valueof("//getCreativeResponse/getCreativeReturn");
    if ( $data->{image} ) {
     $data->{image} = 
       $self->_create_object_from_hash($data->{image}, 'Google::Adwords::Image');
    }

    my $creative= 
     $self->_create_object_from_hash($data, 'Google::Adwords::Creative');

    return	$creative;
}


1;

=pod

=head1 NAME
 
Google::Adwords::CreativeService - Interact with the Google Adwords
CreativeService API calls
 
 
=head1 VERSION
 
This documentation refers to Google::Adwords::CreativeService version 0.2
 
 
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

    my $adgroupid	= 123456789;

    # get all the creatives for an adgroup
    my @getallcreatives	= $creative_service->getAllCreatives($adgroupid);
    for ( @getallcreatives ) {
        print "Creative name : " . $_->name . " , Id : " . $_->id . "\n";
    }

    # get a specific creative from an AdGroup
    my $creativeid	= 987654321;

    my $getcreative	= $creative_service->getCreative($adgroupid, $creativeid);
    print "Get creative: " . $getcreative->name . ", Id : " . $getcreative->id . "\n";

    # activate a creative
    my $ret = $creative_service->activateCreative($adgroupid, $creativeid);

    # activate a list of creative
    my @activate_list = (
        {
            adGroupId => 1234,
            creativeId => 12,
        },
        {
            adGroupId => 5789,
            creativeId => 209,
        },
    );
    my $ret = $creative_service->activateCreativeList(@activate_list);

    # delete a creative
    my $ret	= $creative_service->deleteCreative($adgroupid, $creativeid);
    
    # add a creative
    my $creative_text = Google::Adwords::Creative->new
            ->adGroupId($adgroupid)
            ->destinationUrl('http://www.example.com')
            ->displayUrl('http://www.example.com')
            ->headline('API : creative')
            ->description1('desc1 added via API')
            ->description2('desc2 added via API');

    my $addcreative	= $creative_service->addCreative($creative_text);
    print "Added Creative ID: " . $addcreative->id . "\n";

    # add a image creative
    my $data_blurb = read_file('image.gif');

    my $image	= Google::Adwords::Image->new
            ->name('Image #1')
            ->data($data_blurb)
            ->type('image');
    
    my $creative_image = Google::Adwords::Creative->new
            ->adGroupId($adgroupid)
            ->destinationUrl('http://www.example.com')
            ->displayUrl('http://www.example.com')
            ->image( $image );
    
    my $addcreative	= $creative_service->addCreative($creative_image);
    print "Added Creative ID: " . $addcreative->id . "\n";
    print "Image Height: " . $addcreative->image->height . "\n";

  
=head1 DESCRIPTION

This module provides an interface to the Google Adwords CreativeService API
calls. Please read L<Google::Adwords::Creative> on how to setup and receive
information about your creatives.

  
=head1 METHODS 

=head2 B<activateCreative()>

=head3 Description

=over 4

Mark a Creative as active. Active Creatives will be served.

Creatives are active by default when they are first created, but it is
possible to create them in the deleted (inactive) state, or to inactivate them
by marking them as deleted. A "deleted" creative can be undeleted and made
active again by the activateCreative operation.

To undo this operation, call deleteCreative.

=back

=head3 Usage

=over 4

    my $ret = $obj->activateCreative($adGroupId, $creativeId);

=back

=head3 Parameters

=over 4

=item 1) $adGroupId : id of the Adgroup

=item 2) $creativeId : id of the Creative

=back

=head3 Returns
 
=over 4

1 on success

=back

=head2 B<activateCreativeList()>

=head3 Description

=over 4

Mark a list of Creatives as active. Each pair of (adGroupId, creativeId)
parameters specifies one Creative to activate. See activateCreative.

To undo this operation, call deleteCreativeList.

=back

=head3 Usage

=over 4

    my @pairs = (
        {
            adGroupId => 1244,
            creativeId => 15,
        },
        {
            adGroupId => 4561,
            creativeId => 29,
        },
    );
    my $ret = $obj->activateCreativeList(@pairs);

=back

=head3 Parameters

A list of hashrefs with keys (each forming a pair) :

=over 4

=item * adGroupId : id of the Adgroup

=item * creativeId : id of the Creative

=back

=head3 Returns
 
=over 4

1 on success

=back

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

=head2 B<deleteCreative()>

=head3 Description

=over 4

Mark a Creative as deleted. Deleted Creatives will not be served. If the
Creative is already deleted, this does nothing.

=back

=head3 Usage

=over 4

    my $ret = $obj->deleteCreative($adGroupId, $creativeId);

=back

=head3 Parameters

=over 4

=item * 1) $adGroupId : the id of the adgroup
=item * 2) $creativeId : the id of the creative

=back

=head3 Returns
 
=over 4

1 on success

=back

=head2 B<deleteCreativeList()>

=head3 Description

=over 4

Mark a list of Creatives as deleted. Each pair of (adGroupId, creativeId)
parameters specifies one Creative to delete. To undo this operation, call
activateCreativeList.

=back

=head3 Usage

=over 4

    my @pairs = (
        {
            adGroupId => 1244,
            creativeId => 15,
        },
        {
            adGroupId => 4561,
            creativeId => 29,
        },
    );
    my $ret = $obj->deleteCreativeList(@pairs);

=back

=head3 Parameters

A list of hashrefs (each representing a pair) with keys :

=over 4

=item * adGroupId : id of the Adgroup

=item * creativeId : id of the Creative

=back

=head3 Returns
 
=over 4

1 on success

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

=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::Creative>

=item * L<Google::Adwords::Image>

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

