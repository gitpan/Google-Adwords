package Google::Adwords::Ad;
use strict; use warnings;

use version; our $VERSION = qv('0.0.1');

use base 'Google::Adwords::Data';

my @fields = qw/
    adGroupId
    adType
    destinationUrl
    disapproved
    displayUrl
    exemptionRequest
    id
    status
    description1
    description2
    headline
    image
    address
    businessImage
    businessKey
    businessName
    city
    countryCode
    customIcon
    customIconId
    phoneNumber
    postalCode
    region
    stockIcon
    targetRadiusInKm
    description
    markupLanguages
    mobileCarriers
    postPriceAnnotation
    prePriceAnnotation
    priceString
    productImage
/;

__PACKAGE__->mk_accessors(@fields);

sub get_fields
{
    return @fields;
}

1;

=pod

=head1 NAME
 
Google::Adwords::Ad - A Google Adwords Ad object.
 
=head1 VERSION
 
This documentation refers to Google::Adwords::Ad version 0.0.1
 
 
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
  	#$service->clientCustomerId($customerid);

        # Add the two ads
        my @added_ads = $service->addAds($ad1, $ad2);
  


=head1 DESCRIPTION
 
This object should be used with the AdService API calls
 
 
=head1 METHODS 
 
B<Accessors>

* adGroupId

* adType

* destinationUrl

* disapproved

* displayUrl

* exemptionRequest

* id

* status

* description1

* description2

* headline

* image

* address

* businessImage

* businessKey

* businessName

* city

* countryCode

* customIcon

* customIconId

* phoneNumber

* postalCode

* region

* stockIcon

* targetRadiusInKm

* description

* markupLanguages

* mobileCarriers

* postPriceAnnotation

* prePriceAnnotation

* priceString

* productImage


=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::AdService>

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


