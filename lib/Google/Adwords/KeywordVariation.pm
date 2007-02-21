package Google::Adwords::KeywordVariation;
use strict; use warnings;

use version; our $VERSION = qv('0.0.1');

use base 'Google::Adwords::Data';

my @fields = qw/
    advertiserCompetitionScale
    language
    searchVolumeScale
    text
/;

__PACKAGE__->mk_accessors(@fields);

1;

__END__

=pod

=head1 NAME
 
Google::Adwords::KeywordVariation - A Google Adwords KeywordVariation Object
 

=head1 VERSION
 
This documentation refers to Google::Adwords::KeywordVariation version 0.0.1

=head1 DESCRIPTION
  
This object is a read-only object used in returned calls from Google Adwords API.

More info is available here - 

L<http://www.google.com/apis/adwords/developer/KeywordVariation.html>

 
 
=head1 METHODS 
 
B<Accessors (read only)>
    
* advertiserCompetitionScale - The level of competition from advertisers for this keyword, on a scale from 0 to 5. Set to -1 if data is not available.

* language - The language of the text.

* searchVolumeScale - The amount of searches related to this keyword, on a scale from 0 to 5. Set to -1 if data is not available.

* text - The actual keyword text of the variation.

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

