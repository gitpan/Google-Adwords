package Google::Adwords::NetworkTarget;
use strict;
use warnings;

use version; our $VERSION = qv('0.1');

use base 'Google::Adwords::Data';

my @fields = qw/
    _networkTypes
    /;

__PACKAGE__->mk_accessors(@fields);

sub new
{
    my $proto = shift;

    my $class = ref $proto || $proto;

    if (@_)
    {
        my $obj     = $class->SUPER::new();
        my $hashref = shift;
        for ( keys %{$hashref} )
        {
            $obj->$_( $hashref->{$_} );
        }
        return $obj;
    }
    else
    {
        return $class->SUPER::new();
    }
} # end sub new

# networkTypes should always return an array ref
sub networkTypes
{
    my $self = shift;

    # if its a put
    if (@_)
    {
        my $put_ref = [];

        for (@_)
        {
            if ( ref $_ ne 'ARRAY' )
            {
                push @{$put_ref}, $_;
            }
            else
            {
                push @{$put_ref}, @{$_};
            }
        }

        $self->set( '_networkTypes', $put_ref );
        return $self;
    } # end if (@_)

    return $self->get('_networkTypes');
} # end sub networkTypes

1;

=pod

=head1 NAME
 
Google::Adwords::AccountInfo - A Google Adwords AccountInfo object.
 
=head1 VERSION
 
This documentation refers to Google::Adwords::AccountInfo version 0.0.1
 
 
=head1 SYNOPSIS
 
    use Google::Adwords::AccountInfo;

    my $accountinfo = Google::Adwords::AccountInfo->new
                        ->currencyCode('EUR')
                        ->descriptiveName('My Account');

=head1 DESCRIPTION
 
This object should be used with the AccountService API calls
 
 
=head1 METHODS 
 
B<Mutators (read/write)>

* defaultAdsCoverage

 It's a Google::Adwords::CoverageType object.

* emailPromotionsPreferences

 It's a Google::Adwords::EmailPromotionsPreferences object.

* languagePreference

* primaryBusinessCategory

B<Accessors (read only)>

* billingAddress

 It's a Google::Adwords::Address object.

* currencyCode

* customerId

* primaryAddress

 It's a Google::Adwords::Address object.

* termsAndConditions

* timeZoneEffectiveDate

* timeZoneId

=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::AccountService>

=item * L<Google::Adwords::Address>

=item * L<Google::Adwords::CoverageType>

=item * L<Google::Adwords::EmailPromotionsPreferences>

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



