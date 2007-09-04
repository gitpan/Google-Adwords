package Google::Adwords::GeoTarget;
use strict;
use warnings;

use version; our $VERSION = qv('0.0.1');

use base 'Google::Adwords::Data';

my @fields = qw/
    cityTargets
    countryTargets
    metroTargets
    proximityTargets
    regionTargets
    targetAll
    /;

__PACKAGE__->mk_accessors(@fields);

1;

=pod

=head1 NAME
 
Google::Adwords::GeoTarget - GeoTargeting options
 
=head1 SYNOPSIS
 
    use Google::Adwords::GeoTarget;
    use Google::Adwords::CountryTargets;

    # Set target countries as US and India
    my $geo_target = Google::Adwords::GeoTarget->new();
    my $targets = Google::Adwords::CountryTargets->new();
    $targets->countries([ 'US', 'IN' ]);
    $geo_target->countryTargets($targets);


=head1 METHODS 
 
B<Mutators (read/write)>

* cityTargets - A Google::Adwords::CityTargets object

* countryTargets - A Google::Adwords::CountryTargets object

* metroTargets - A Google::Adwords::MetroTargets object

* proximityTargets - TODO

* regionTargets - A Google::Adwords::RegionTargets object

* targetAll  - true/false

=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::CityTargets>

=item * L<Google::Adwords::CountryTargets>

=item * L<Google::Adwords::MetroTargets>

=item * L<Google::Adwords::RegionTargets>


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


