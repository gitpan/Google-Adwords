package Google::Adwords::AdService;
use strict;
use warnings;

use version; our $VERSION = qv('0.5');

use base 'Google::Adwords::Service';

# data types for AdService
use Google::Adwords::Ad;
use Google::Adwords::Business;
use Google::Adwords::StatsRecord;
use Google::Adwords::Image;
use Google::Adwords::ApiError;
use Google::Adwords::GeoTarget;
use Google::Adwords::CityTargets;
use Google::Adwords::CountryTargets;
use Google::Adwords::MetroTargets;
use Google::Adwords::RegionTargets;

use HTML::Entities;

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
    my ( $self, $ad ) = @_;

    my @params;

    # Get fields of the base Ad object
    my @fields_base_ad = Google::Adwords::Ad->get_fields();
    for (@fields_base_ad)
    {
        if ( defined $ad->$_ )
        {

            # If this is an ImageAd
            if (
                ( $_    eq 'image' )            # ImageAd
                or ( $_ eq 'businessImage' )    # LocalBusinessAd
                or ( $_ eq 'customIcon' )       # LocalBusinessAd
                or ( $_ eq 'productImage' )     # CommerceAd
                )
            {
                my $image = $ad->$_;
                my @image_params;
                my @image_fields = Google::Adwords::Image->get_fields();

                for (@image_fields)
                {
                    if ( defined $image->$_ )
                    {

                      # for the data field, we need to set the type explicitly
                        if ( $_ eq 'data' )
                        {
                            push @image_params,
                                SOAP::Data->name(
                                'data' => SOAP::Data->type(
                                    base64 => $image->data
                                )
                                )->type('');
                        }
                        else
                        {
                            push @image_params,
                                SOAP::Data->name( $_ => $image->$_ )
                                ->type('');
                        }
                    } # end if ( defined $image->$_...
                } # end for (@image_fields)

                push @params, SOAP::Data->name(
                    $_ => \SOAP::Data->value(@image_params) )->type('');
            } # end if ( ( $_ eq 'image' )...
            else
            {
                push @params, SOAP::Data->name( $_ => $ad->$_ )->type('');
            }
        } # end if ( defined $ad->$_ )
    } # end for (@fields_base_ad)

    return @params;
} # end sub _create_request_params

### INTERNAL UTILITY #####################################################
# Usage      : $obj = $self->_parse_ad_response($ad_ref);
# Purpose    : Create an Ad object from the Ad input hashref
# Returns    : ????
# Parameters : ????
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub _parse_ad_response
{
    my ( $self, $r ) = @_;

    if (   ( exists $r->{image} )
        or ( exists $r->{businessImage} )
        or ( exists $r->{customIcon} )
        or ( exists $r->{productImage} ) )
    {
        $r->{image} = $self->_create_object_from_hash( $r->{image},
            'Google::Adwords::Image' );
    }

    return $self->_create_object_from_hash( $r, 'Google::Adwords::Ad' );
}

### INSTANCE METHOD ################################################
# Usage      :
#   my @ads = $obj->addAds($ad1, $ad2);
# Purpose    : Create a new batch of Ads
# Returns    : List of created Ad objects
# Parameters : A Google::Adwords::Creative object
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub addAds
{
    my ( $self, @ads ) = @_;

    # for each ad, adGroupId must be filled in
    for (@ads)
    {
        if ( not defined $_->adGroupId )
        {
            die "adGroupId must be filled in for the Ad object\n";
        }
    }

    my @ads_params;
    foreach my $ad (@ads)
    {
        my @ad_params = $self->_create_request_params($ad);
        push @ads_params, @ad_params;
    }

    my @params;
    push @params, SOAP::Data->name( 'ads' => \SOAP::Data->value(@ads_params) )
        ->type('');

    my $result = $self->_create_service_and_call(
        {
            service  => 'AdService',
            method   => 'addAds',
            params   => \@params,
            with_uri => 1,
        }
    );

    # Parse SOAP response
    my @ret;
    foreach my $r ( $result->valueof("//addAdsResponse/addAdsReturn") )
    {
        push @ret, $self->_parse_ad_response($r);
    }

    return @ret;
} # end sub addAds

### INSTANCE METHOD ########################################################
# Usage      :
#
#   my @businesses = $self->findBusinesses({
#       name    => 'business name',
#       address => 'address of business',
#       countryCode => 'IN',
#   });
#
# Purpose    : Find businesses
# Returns    : ????
# Parameters : ????
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub findBusinesses
{
    my ( $self, $args_ref ) = @_;

    my @params;

    for (qw/name address countryCode/)
    {
        if ( not exists $args_ref->{$_} )
        {
            die "$_ must be defined for the Business object\n";
        }
        push @params,
            SOAP::Data->name( $_ => encode_entities( $args_ref->{$_} ) )
            ->type('');
    }

    my $result = $self->_create_service_and_call(
        {
            service => 'AdService',
            method  => 'findBusinesses',
            params  => \@params,
        }
    );

    my @data;
    foreach my $c (
        $result->valueof("//findBusinessesResponse/findBusinessesReturn") )
    {
        push @data, $self->_create_object_from_hash( $c,
            'Google::Adwords::Business' );
    }

    return @data;
} # end sub findBusinesses

### INSTANCE METHOD ################################################
# Usage      :
#   my @ads = $obj->getActiveAds($adgroupid1, $adgroupid2);
# Purpose    : Get all the active creatives for the given adgroups
# Returns    : A list of Google::Adwords::Ad objects
# Parameters : List of adgroupids from which we want the active Ads
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getActiveAds
{
    my ( $self, @adgroup_ids ) = @_;

    my @params;
    push @params, SOAP::Data->name( 'adGroupIds' => @adgroup_ids )->type('');

    my $result = $self->_create_service_and_call(
        {
            service => 'AdService',
            method  => 'getActiveAds',
            params  => \@params,
        }
    );

    # Parse SOAP response
    my @ret;
    foreach my $r (
        $result->valueof("//getActiveAdsResponse/getActiveAdsReturn") )
    {
        push @ret, $self->_parse_ad_response($r);
    }

    return @ret;
} # end sub getActiveAds

### INSTANCE METHOD ################################################
# Usage      :
#   my $ad = $obj->getAd($adgroup_id, $ad_id);
# Purpose    : Get a given Ad in a given adgroup
# Returns    : The requested Ad as a Google::Adwords::Ad object.
# Parameters : The targeted adgroup id and ad id
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getAd
{
    my ( $self, $adgroup_id, $ad_id ) = @_;

    my @params;
    push @params, SOAP::Data->name( 'adGroupId' => $adgroup_id )->type('');
    push @params, SOAP::Data->name( 'adId'      => $ad_id )->type('');

    my $result = $self->_create_service_and_call(
        {
            service => 'AdService',
            method  => 'getAd',
            params  => \@params,
        }
    );

    my $data = $result->valueof("//getAdResponse/getAdReturn");
    return $self->_parse_ad_response($data);
} # end sub getAd

### INSTANCE METHOD ################################################
# Usage      :
#   my @ad_stats = $obj->getAdStats({
#       adGroupId       => 1234
#           adIds       => [ 3982, 2787, 17872 ],
#           startDay    => $startDay,
#           endDay      => $endDay,
#   });
# Purpose    : Get stats on a set of Ads
# Returns    :  A list of StatsRecord object for each Ad
# Parameters :
#   adGroupId : The ad group that contains the Ads to be queried
#       creativeIds  : array reference of Ad Ids
#       startDay : starting day of the stats YYYY-MM-DD
#       endDay : end day of the stats YYYY-MM-DD
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getAdStats
{
    my ( $self, $args_ref ) = @_;

    if ( not defined $args_ref->{adGroupId} )
    {
        die "adGroupId param must be provided to getAdStats\n";
    }

    my $ra_id    = $args_ref->{adIds}    || [];
    my $startDay = $args_ref->{startDay} || '';
    my $endDay   = $args_ref->{endDay}   || '';

    my @params;
    push @params,
        SOAP::Data->name( 'adGroupId' => $args_ref->{adGroupId} )->type('');
    push @params, SOAP::Data->name( 'adIds'    => @{$ra_id} )->type('');
    push @params, SOAP::Data->name( 'startDay' => $startDay )->type('');
    push @params, SOAP::Data->name( 'endDay'   => $endDay )->type('');

    my $result = $self->_create_service_and_call(
        {
            service => 'AdService',
            method  => 'getAdStats',
            params  => \@params,
        }
    );

    my @data;
    foreach
        my $c ( $result->valueof("//getAdStatsResponse/getAdStatsReturn") )
    {
        push @data,
            $self->_create_object_from_hash( $c,
            'Google::Adwords::StatsRecord' );
    }

    return @data;
} # end sub getAdStats

### INSTANCE METHOD ################################################
# Usage      :
#   my @ads = $obj->getAllAds($adgroup_id1, $adgroup_id2);
# Purpose    : Get all the Ads for the given adgroup_ids
# Returns    : A list of Google::Adwords::Ad objects
# Parameters : The adgroupids from which we want all the Ads
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getAllAds
{
    my ( $self, @adgroup_ids ) = @_;

    my @params;
    push @params, SOAP::Data->name( 'adGroupIds' => @adgroup_ids )->type('');

    my $result = $self->_create_service_and_call(
        {
            service => 'AdService',
            method  => 'getAllAds',
            params  => \@params,
        }
    );

    # Parse SOAP response
    my @ret;
    foreach my $r ( $result->valueof("//getAllAdsResponse/getAllAdsReturn") )
    {
        push @ret, $self->_parse_ad_response($r);
    }

    return @ret;
} # end sub getAllAds

### INSTANCE METHOD ########################################################
# Usage      :
#
#   my @businesses = $self->getMyBusinesses();
#
# Purpose    : Find businesses
# Returns    : ????
# Parameters : ????
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getMyBusinesses
{
    my ($self) = @_;

    my @params;
    my $result = $self->_create_service_and_call(
        {
            service => 'AdService',
            method  => 'getMyBusinesses',
            params  => \@params,
        }
    );

    my @data;
    foreach my $c (
        $result->valueof("//getMyBusinessesResponse/getMyBusinessesReturn") )
    {
        push @data, $self->_create_object_from_hash( $c,
            'Google::Adwords::Business' );
    }

    return @data;
} # end sub getMyBusinesses

### INSTANCE METHOD ###################################################
# Usage      : $ret = $obj->updateAds(@ads);
# Purpose    : update status of Ads
# Returns    : 1 on success
# Parameters :
#   @ads => List of Ad objects
# Throws     : no exceptions
# Comments   : Only the status field can be updated
# See Also   : n/a
#######################################################################
sub updateAds
{
    my ( $self, @ads ) = @_;

    my @params;

    foreach my $ad (@ads)
    {
        my @ad_params;

        if ( not defined $ad->id )
        {
            die "id must be set for the Ad object\n";
        }
        if ( not defined $ad->adGroupId )
        {
            die "adGroupId must be set for the Ad object\n";
        }
        if ( not defined $ad->status )
        {
            die "status must be set for the Ad object\n";
        }
        if ( not defined $ad->adType )
        {
            die "adType must be set for the Ad object\n";
        }

        push @ad_params, SOAP::Data->name( 'id' => $ad->id )->type('');
        push @ad_params,
            SOAP::Data->name( 'adGroupId' => $ad->adGroupId )->type('');
        push @ad_params,
            SOAP::Data->name( 'adType' => $ad->adType )->type('');
        push @ad_params,
            SOAP::Data->name( 'status' => $ad->status )->type('');

        push @params,
            SOAP::Data->name( 'ads' => \SOAP::Data->value(@ad_params) )
            ->type('');
    }

    my $result = $self->_create_service_and_call(
        {
            service => 'AdService',
            method  => 'updateAds',
            params  => \@params,
        }
    );

    return 1;
} # end sub updateAds

### INSTANCE METHOD #####################################################
# Usage      :
#   my @api_errors = $obj->checkAds({
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
sub checkAds
{
    my ( $self, $args_ref ) = @_;

    my @params;

    # The Ads
    foreach my $ad ( @{ $args_ref->{ads} } )
    {
        if ( not defined $ad->id )
        {
            die "id must be set for the Ad object\n";
        }
    }

    my @ads_params;
    foreach my $ad ( @{ $args_ref->{ads} } )
    {
        my @ad_params = $self->_create_request_params($ad);
        push @ads_params, @ad_params;
    }
    push @params, SOAP::Data->name( 'ads' => \SOAP::Data->value(@ads_params) )
        ->type('');

    # languageTarget
    if ( defined $args_ref->{languageTarget} )
    {
        push @params,
            SOAP::Data->name(
            'languageTarget' => \SOAP::Data->name(
                'languages' => @{ $args_ref->{languageTarget} }
                )->type('')
            )->type('');
    }

    # geoTargeting
    if ( defined $args_ref->{geoTarget} )
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

        if ( scalar @geo_data > 0 )
        {
            push @params, SOAP::Data->name(
                'geoTarget' => \SOAP::Data->value(@geo_data), )->type('');
        }
    } # end if ( defined $args_ref...

    my $result = $self->_create_service_and_call(
        {
            service => 'AdService',
            method  => 'checkAds',
            params  => \@params,
        }
    );

    my @data;
    foreach my $c ( $result->valueof("//checkAdsResponse/checkAdsReturn") )
    {
        push @data, $self->_create_object_from_hash( $c,
            'Google::Adwords::ApiError' );
    }

    return @data;
} # end sub checkAds

1;

=pod

=head1 NAME
 
Google::Adwords::AdService - Interact with the Google Adwords AdService API calls
 
 
=head1 VERSION
 
This documentation refers to Google::Adwords::AdService version 0.5
 
 
=head1 SYNOPSIS

        use Google::Adwords::AdService;
        use Google::Adwords::Ad;
        use Google::Adwords::Image;

        use File::Slurp;

        my $adgroup_id = 20048;

        # Create Text Ad
        my $ad1 = Google::Adwords::Ad->new
            ->adType('TextAd')
            ->headline('The World is Flat')
            ->description1('Yes')
            ->description2('It is')
            ->adGroupId($adgroup_id)
            ->destinationUrl('http://aarohan.biz')
            ->displayUrl('aarohan.biz')

        # Create an Image Ad
        my $ad2 = Google::Adwords::Ad->new
            ->adType('ImageAd')
            ->adGroupId($adgroup_id)
            ->destinationUrl('http://aarohan.biz')
            ->displayUrl('aarohan.biz');

        # The image stuff
        my $image_data = read_file('picture.jpg');
        my $image = Google::Adwords::Image->new;
        $image->name('picture.jpg');
        $image->data($image_data);

        # Associate the image with the Image Ad
        $ad2->image($image);

        # Create the AdService
        my $service = Google::Adwords::AdService->new();

        # login details
        $service->email('email@domain.com')
                ->password('password')
                ->developerToken($developer_token)
                ->applicationToken($app_token);

        # if you use a MCC
        #$service->clientEmail('clientemail@domain.com');
        # or 
        #$service->clientCustomerId('xxx-xxx-xxxx');

        # Add the two ads
        my @added_ads = $service->addAds($ad1, $ad2);
  

=head1 DESCRIPTION

This module provides an interface to the Google Adwords AdService API calls.

  
=head1 METHODS 

=head2 B<addAds()>

=head3 Description

=over 4

Make a batch of new Ads. The adGroupId field of the Ad indicates which AdGroup to add
the Ad to. The adGroupId field is required, and the indicated AdGroup must exist
already. 

=back

=head3 Usage

    my @ads = $service->addAds($ad1, $ad2);

=head3 Parameters

=over 4

A list of Google::Adwords::Ad objects to be added.

=back

=head3 Returns
 
=over 4

A list of Google::Adwords::Ad objects just created with their IDs filled in.

=back

=head2 B<checkAds()>

=head3 Description

=over 4

Check a batch of Ads for policy errors. The number of Ads in the batch is
limited to the maximum number of Ads per adgroup.

=back

=head3 Usage

    my @api_errors = $service->checkAds({
        ads => \@ads,
        languageTarget => [ 'en', 'hi', ],
        geoTarget   => {
            countries => [ 'US', 'IN' ],
        },
    });

=head3 Parameters

A hashref with following keys - 

=over 4

* ads => an arrayref of Ad objects

* languageTarget => an arrayref of language codes

* geoTarget => a hashref of geotargeting info

=back

=head3 Returns
 
=over 4

A list of Google::Adwords::ApiError objects

=back

=head2 B<findBusinesses()>

=head3 Description

=over 4

Searches for businesses with similar attributes. This call is similar to querying
Google Local Search. All parameters are required.

=back

=head3 Usage

    my @businesses = $service->findBusinesses({
        name    => 'business name',
        address => 'address of business',
        countryCode => 'IN',
    });


=head3 Parameters

A hashref with following keys :

=over 4

=item * name    => Name of the business

=item * address => Location of the business

=item * countryCode => Two letter country code of the business address.

=back

=head3 Returns
 
=over 4

A list of matching businesses, each as a Google::Adwords::Business object

=back

=head2 B<getActiveAds()>

=head3 Description

=over 4

Return all active Ads associated with the list of AdGroup ids specified.

=back

=head3 Usage

    my @ads = $obj->getActiveAds($adgroupid1, $adgroupid2);

=head3 Parameters

=over 4

List of adgroupids from which we want the active Ads

=back

=head3 Returns
 
=over 4

A list of Google::Adwords::Ad objects

=back

=head2 B<getAd()>

=head3 Description

=over 4

Return information about one Ad.

=back

=head3 Usage

    my $ad = $service->getAd($adgroup_id, $ad_id);

=head3 Parameters

=over 4

=item 1) $adgroup_id => The ID of the AdGroup owning the Ad

=item 2) $ad_id => The ID of the Ad

=back

=head3 Returns
 
=over 4

The requested Ad as a Google::Adwords::Ad object.

=back

=head2 B<getAdStats()>

=head3 Description

=over 4

Get statistics for a list of ads in an ad group.

=back

=head3 Usage

    my @ad_stats = $service->getAdStats({
        adGroupId   => 1234,
        adIds       => [ 3982, 2787, 17872 ],
        startDay    => $startDay,
        endDay      => $endDay,
    });

=head3 Parameters

Takes a hashref with following keys,

=over 4

* adGroupId => The ad group that contains the Ads to be queried

* adIds => array reference of Ad IDs

* startDay => The starting day of the period for which statistics are to 
be collected in format YYYY-MM-DD

* endDay => The ending day of the period for which statistics are to be
collected in format YYYY-MM-DD


=back



=head3 Returns
 
=over 4

A list of Google::Adwords::StatsRecord objects

=back

=head2 B<getAllAds()>

=head3 Description

=over 4

Return all Ads (enabled, disabled, or paused) associated with the list of AdGroup ids
specified.

=back

=head3 Usage

    my @ads = $service->getAllAds($adgroup_id1, $adgroup_id2);

=head3 Parameters

=over 4

A list of AdGroup IDs that own the Ads

=back

=head3 Returns
 
=over 4

A list of Google::Adwords::Ad objects

=back

=head2 B<getMyBusinesses()>

=head3 Description

=over 4

Returns the list of businesses registered to the user in the Local Business Center.
The user is determined by the clientEmail header if it is specified. Otherwise, the
email header is used instead.

=back

=head3 Usage

    my @businesses = $self->getMyBusinesses();

=head3 Parameters

    NONE

=head3 Returns
 
=over 4

A list of Google::Adwords::Business objects

=back

=head2 B<updateAds()>

=head3 Description

=over 4

Update a batch of ads. Use the id field of the ad to indicate which ad to update.
Currently only the status field is updateable, all other fields will be ignored.

=back

=head3 Usage

    $ret = $obj->updateAds($ad1, $ad2);

=head3 Parameters

=over 4

A List of Google::Adwords::Ad objects to be updated

=back

=head3 Returns
 
=over 4

1 on success

=back

=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::Ad>

=item * L<Google::Adwords::Business>

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

