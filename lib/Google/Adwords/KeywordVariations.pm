package Google::Adwords::KeywordVariations;
use strict; use warnings;

use version; our $VERSION = qv('0.0.1');

use base 'Google::Adwords::Data';

my @fields = qw/
    additionalToConsider
    moreSpecific
/;

__PACKAGE__->mk_accessors(@fields);

1;

__END__

=pod

=head1 NAME
 
Google::Adwords::KeywordVariations - A Google Adwords KeywordVariations Object
 

=head1 VERSION
 
This documentation refers to Google::Adwords::KeywordVariations version 0.0.1

=head1 DESCRIPTION
  
This object is a read-only object used in returned calls from Google Adwords API.

More info is available here - 

L<http://www.google.com/apis/adwords/developer/KeywordVariations.html>

 
 
=head1 METHODS 
 
B<Accessors (read only)>
    
* additionalToConsider - Users who searched for your seed keyword(s) also searched for these, it is an arrayref of Google::Adwords::KeywordVariation objects.

* moreSpecific - Popular queries that include your seed keyword(s), it is an arrayref of Google::Adwords::KeywordVariation objects.

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

