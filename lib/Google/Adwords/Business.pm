package Google::Adwords::Business;
use strict;
use warnings;

use version; our $VERSION = qv('0.0.1');

use base 'Google::Adwords::Data';

my @fields = qw/
    address
    city
    countryCode
    key
    latitude
    longitude
    name
    phoneNumber
    postalCode
    region
    timestamp
    /;

__PACKAGE__->mk_accessors(@fields);

sub get_fields
{
    return @fields;
}

1;

=pod

=head1 NAME
 
Google::Adwords::Business - A Google Adwords Business object.
 
=head1 VERSION
 
This documentation refers to Google::Adwords::Business version 0.0.1
 
 
=head1 SYNOPSIS
 
    use Google::Adwords::AdService;
    use Google::Adwords::Business;

    # create the AdService object
    my $service = Google::Adwords::AdService->new();

    # need to login to the Adwords service
    $service->email($email_address)
            ->password($password)
            ->developerToken($developer_token)
            ->applicationToken($app_token);

    # if you have a MCC
    $service->clientEmail($client_email);
    # or 
    $service->clientCustomerId($customerid);

    # find businesses
    my @businesses = $service->findBusinesses({
        name            => 'Google',
        address         => 'Street Address,
        countryCode     => 'US',
    });
    
    for (@businesses) {
        "Phone Number: " . $_->phoneNumber . "\n";
    }


=head1 DESCRIPTION
 
This object should be used with the AdService API calls
 
 
=head1 METHODS 
 
B<Accessors>

* address

* city

* countryCode

* key

* latitude

* longitude

* name

* phoneNumber

* postalCode

* region

* timestamp



=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::AdService>

=back

=head1 AUTHOR
 
Rohan Almeida <rohan@almeida.in>
 
 
=head1 LICENSE AND COPYRIGHT
 
Copyright (c) 2006 Rohan Almeida <rohan@almeida.in>. All rights
reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


