package Google::Adwords::CountryTargets;
use strict;
use warnings;

use version; our $VERSION = qv('0.0.1');

use base 'Google::Adwords::Data';

my @fields = qw/
    countries
    /;

__PACKAGE__->mk_accessors(@fields);

1;

=pod

=head1 NAME
 
Google::Adwords::CountryTargets - Contains country targets
 
 
=head1 SYNOPSIS
 
    use Google::Adwords::CountryTargets;

    my $targets = Google::Adwords::CountryTargets->new();
    $targets->countries([ 'US', 'IN' ]);


=head1 METHODS 
 
B<Mutators (read/write)>

* countries


=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::GeoTarget>

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


