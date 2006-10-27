package Google::Adwords::AdGroupRequest;

use base 'Google::Adwords::Data';

my @fields = qw/
    id
    keywordRequests
    maxCpc
/;

__PACKAGE__->mk_accessors(@fields);

1;

__END__

=pod

=head1 NAME
 
Google::Adwords::AdGroupRequest - A Google Adwords AdGroupRequest Object
 

=head1 VERSION
 
This documentation refers to Google::Adwords::AdGroupRequest version 0.0.1

=head1 DESCRIPTION
  
This object is a read/write object used in calls from Google Adwords API.

More info is available here - 

http://www.google.com/apis/adwords/developer/AdGroupRequest.html

 
 
=head1 METHODS 
 
B<Mutators (read/write)>
  
* id - The id of the ad group to be estimated. All keywords in the ad group will be estimated. Optional - if omitted indicates a new ad group.

* keywordRequests - The keywords to be estimated. This list must contain at least one Google::Adwords::KeywordRequest object.

* maxCpc - The bid for this ad group in micros.

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

