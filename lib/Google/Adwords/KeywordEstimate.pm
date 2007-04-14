package Google::Adwords::KeywordEstimate;
use strict;
use warnings;

use base 'Google::Adwords::Data';

my @fields = qw/
    id
    lowerAvgPosition
    lowerClicksPerDay
    lowerCpc
    upperAvgPosition
    upperClicksPerDay
    upperCpc
    /;

__PACKAGE__->mk_accessors(@fields);

1;

__END__

=pod

=head1 NAME
 
Google::Adwords::KeywordEstimate - A Google Adwords KeywordEstimate Object
 

=head1 VERSION
 
This documentation refers to Google::Adwords::KeywordEstimate version 0.0.1

=head1 DESCRIPTION
  
This object is a read-only object used in calls from Google Adwords API.

More info is available here - 

http://www.google.com/apis/adwords/developer/KeywordEstimate.html

 
 
=head1 METHODS 
 
B<Accessors (read-only)>

* id - The existing keyword id, if any, to which this estimate corresponds. For a new keyword, the id is -1.

* lowerAvgPosition - The estimated lower position for ads triggered by this keyword.

* lowerClicksPerDay - The estimated minimum number of clicks per day for this keyword.

* lowerCpc - The estimated minimum cost per clicks for this keyword.

* upperAvgPosition - The estimated upper position for ads triggered by this keyword.

* upperClicksPerDay - The estimated upper number of clicks per day for this keyword.

* upperCpc - The estimated upper cost per click for this keyword.

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

