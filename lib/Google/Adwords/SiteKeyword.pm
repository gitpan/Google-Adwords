package Google::Adwords::SiteKeyword;
use strict; use warnings;

use version; our $VERSION = qv('0.0.1');

use base 'Google::Adwords::Data';

my @fields = qw/
    advertiserCompetitionScale
    groupId
    searchVolumeScale
    text
/;

__PACKAGE__->mk_accessors(@fields);

1;

__END__

=pod

=head1 NAME
 
Google::Adwords::SiteKeyword - A Google Adwords SiteKeyword Object
 

=head1 VERSION
 
This documentation refers to Google::Adwords::SiteKeyword version 0.0.1

=head1 DESCRIPTION
  
This object is a read-only object used in returned calls from Google Adwords API.

More info is available here - 

L<http://www.google.com/apis/adwords/developer/SiteKeyword.html>

 
 
=head1 METHODS 
 
B<Accessors (read only)>
    
* advertiserCompetitionScale - The level of competition from advertisers for this keyword, on a scale from 0 to 5. Set to -1 if data is not available.

* groupId - The index into the groups array. It represents the group in SiteKeywordGroups this keyword belongs to.

* searchVolumeScale - The amount of searches related to this keyword, on a scale from 0 to 5. Set to -1 if data is not available.

* text - The text of the keyword.

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

