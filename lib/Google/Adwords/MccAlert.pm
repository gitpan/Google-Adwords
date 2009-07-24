package Google::Adwords::MccAlert;
use strict;
use warnings;

use version; our $VERSION = qv('0.1');

use base 'Google::Adwords::Data';

my @fields = qw/
    clientCompanyName
    clientCustomerId
    clientLogin
    clientName
    priority
    triggerTime
    type
    /;

__PACKAGE__->mk_accessors(@fields);

1;

=pod

=head1 NAME
 
Google::Adwords::MccAlert - A Google Adwords MccAlert object.
 
=head1 VERSION
 
This documentation refers to Google::Adwords::MccAlert version 0.1
 
 
=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::AccountService>

=back

=head1 AUTHOR
 
Rohan Almeida <rohan@almeida.in>

 
=head1 LICENSE AND COPYRIGHT
 
Copyright (c) 2009 Rohan Almeida <rohan@almeida.in>. All rights
reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.



