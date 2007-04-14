package Google::Adwords::CreditCard;
use strict;
use warnings;

use version; our $VERSION = qv('0.0.1');

use base 'Google::Adwords::Data';

my @fields = qw/
    cardNumber
    cardType
    cardVerificationNumber
    expirationMonth
    expirationYear
    issueNumber
    startMonth
    startYear
    status
    taxNumber
    /;

__PACKAGE__->mk_accessors(@fields);

1;

=pod

=head1 NAME
 
Google::Adwords::CreditCard - A Google Adwords CreditCard object.
 
=head1 VERSION
 
This documentation refers to Google::Adwords::CreditCard version 0.0.1
 
 
=head1 SYNOPSIS
 
    use Google::Adwords::CreditCard;

    my $creditcard	= Google::Adwords::CreditCard->new
                ->cardNumber(123456789)
                ->cardType('VISA')
                ->cardVerificationNumber(123)
                ->expirationMonth(1)
                ->expirationYear(2008);
  
=head1 DESCRIPTION
 
This object should be used with the AccountService API calls
 
 
=head1 METHODS 
 
B<Mutators (read/write)>

* cardNumber

* cardType

* cardVerificationNumber

* expirationMonth

* expirationYear

* issueNumber

* startMonth

* startYear

* status

* taxNumber

=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::AccountService>

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


