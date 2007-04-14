package Google::Adwords::StatsRecord;
use strict;
use warnings;

use base 'Google::Adwords::Data';

my @fields = qw/
    averagePosition
    clicks
    conversionRate
    conversions
    cost
    id
    impressions
    /;

__PACKAGE__->mk_accessors(@fields);

1;

__END__

=pod

=head1 NAME
 
Google::Adwords::StatsRecord - A Google Adwords StatsRecord Object
 

=head1 VERSION
 
This documentation refers to Google::Adwords::StatsRecord version 0.0.1

=head1 DESCRIPTION
  
This object is a read-only object used in returned calls from Google Adwords API.

More info is available here - 

L<http://www.google.com/apis/adwords/developer/StatsRecord.html>

 
 
=head1 METHODS 
 
B<Accessors (read only)>
    
* averagePosition - The average position of impressions that were shown for
this record's entity

* clicks - The number of clicks collected by this record's entity.

* conversionRate - The ratio of conversions over convertible clicks for this 
record's entity.

* conversions - The number of clicks that were actually converted for this
record's entity.

* cost - The total cost incurred (in micro-units of currency) by this record's
entity.

* id - The Id of this record's entity

* impressions - The number of impressions shown on behalf of this record's
entity


=head1 AUTHOR
 
Mathieu Jondet <mathieu@eulerian.com

Rohan Almeida <rohan@almeida.in>

 
 
=head1 LICENSE AND COPYRIGHT
 
Copyright (c) 2006 Rohan Almeida <rohan@almeida.in>. All rights
reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

