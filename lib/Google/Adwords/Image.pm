package Google::Adwords::Image;
use strict; use warnings;

use version; our $VERSION = qv('0.0.1');

use base 'Google::Adwords::Data';

my @fields = qw/
    data
    height
    imageUrl
    mimeType
    name
    thumbnailUrl
    type
    width
/;

__PACKAGE__->mk_accessors(@fields);

sub get_fields
{
    return @fields;
}

1;

=pod

=head1 NAME
 
Google::Adwords::Image - A Google Adwords Image object.
 
 
=head1 VERSION
 
This documentation refers to Google::Adwords::Image version 0.0.1
 
 
=head1 SYNOPSIS
 
    use Google::Adwords::CreativeService;
    use Google::Adwords::Creative;
    use Google::Adwords::Image;
  
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

    # Lets add an image creative
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
 
This object should be used with the CreativeService API calls
 
 
=head1 METHODS 
 
B<Mutators (read/write)>

* data

 This field is a binary string of data that will be base64 encoded. 
 The easiest is to slurp the file with File::Slurp::read_file and
 provide the binary string to the data method.

* name - The name of this image. This field is required at creation time, but
cannot be changed afterwards.

* type - The type of this image
 
B<Accessors (read only)>

* height - The height of this image in pixels. This field is calculated by the
CreativeService and cannot be changed.

* width - The width of this image in pixels. This field is calculated by the
CreativeService and cannot be changed.

* imageUrl - After you have created an image ad, you can use this URL to fetch
the image or to link to it. This field is determined by the CreativeService
and cannot be changed.

* thumbnailUrl - After you have created an image ad, you can use this URL to
fetch or link to a thumbnail version of the image. The thumbnail image is
created by the CreativeService and the URL to it cannot be changed. This
field will be null if a thumbnail image cannot be generated.

* mimeType - The mime type of this image. This field is determined by the
CreativeService and cannot be changed.

=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::CreativeService>

=item * L<Google::Adwords::Creative>

=item * L<File::Slurp>

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

