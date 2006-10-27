package Google::Adwords::AdGroupEstimate;

use base 'Google::Adwords::Data';

my @fields = qw/
    id
    keywordEstimates
/;

__PACKAGE__->mk_accessors(@fields);

1;

__END__

=pod

=head1 NAME
 
Google::Adwords::AdGroupEstimate - A Google Adwords AdGroupEstimate Object
 

=head1 VERSION
 
This documentation refers to Google::Adwords::AdGroupEstimate version 0.0.1

=head1 DESCRIPTION
  
This object is a read-only object used in calls from Google Adwords API.

More info is available here - 

http://www.google.com/apis/adwords/developer/AdGroupEstimate.html

 
 
=head1 METHODS 
 
B<Accessors (read-only)>

* id - The existing ad group id, if any, to which this estimate corresponds. If the ad group is new (meaning that all the estimated keywords are new), the id is -1.

* keywordEstimates - The keyword estimates for this ad group. Each Google::Adwords::KeywordEstimate contains the estimation results, such as estimated clicks per day, for that keyword.

=head1 AUTHOR
 
Mathieu Jondet <mathieu@eulerian.com

Rohan Almeida <rohan@almeida.in>

 
 
=head1 LICENCE AND COPYRIGHT
 
Copyright (c) 2006 Rohan Almeida <rohan@almeida.in>. All rights
reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

