package Google::Adwords::CoverageType;
use strict; use warnings;

use version; our $VERSION = qv('0.0.1');

use base 'Google::Adwords::Data';

my @fields = qw/
    optInContentNetwork
    optInSearchNetwork
/;

__PACKAGE__->mk_accessors(@fields);

1;

=pod

=head1 NAME
 
Google::Adwords::CoverageType - A Google Adwords CoverageType object.
 
=head1 VERSION
 
This documentation refers to Google::Adwords::CoverageType version 0.0.1
 
 
=head1 SYNOPSIS
 
    use Google::Adwords::CoverageType;

    my $coveragetype = Google::Adwords::CoverageType->new
                        ->optInContentNetwork(1)
                        ->optInSearchNetwork(0);

=head1 DESCRIPTION
 
This object should be used with the AccountService API calls
 
 
=head1 METHODS 
 
B<Mutators (read/write)>

* optInContentNetwork

* optInSearchNetwork

=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::AccountService>

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



