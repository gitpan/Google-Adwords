package Google::Adwords::SeedKeyword;
use strict;
use warnings;

use version; our $VERSION = qv('0.0.1');

use base 'Google::Adwords::Data';

my @fields = qw/
    negative
    text
    type
    /;

__PACKAGE__->mk_accessors(@fields);

1;

__END__

=pod

=head1 NAME
 
Google::Adwords::SeedKeyword - A Google Adwords SeedKeyword Object
 

=head1 VERSION
 
This documentation refers to Google::Adwords::SeedKeyword version 0.0.1

=head1 DESCRIPTION
  
This object is a read/write object used in calls from Google Adwords API.

More info is available here - 

L<http://www.google.com/apis/adwords/developer/SeedKeyword.html>

 
 
=head1 METHODS 
 
B<Mutators (read/write)>
    
* negative - If set to 1, the keyword is used to filter out variations. Otherwise, acts as a source of variations.

* text - The text of the source keyword.

* type - The type of the source keyword, which determines how variations are generated : Broad, Phrase or Exact.

=head1 AUTHOR
 
Mathieu Jondet <mathieu@eulerian.com>

Rohan Almeida <rohan@almeida.in>

 
 
=head1 LICENSE AND COPYRIGHT
 
Copyright (c) 2006 Rohan Almeida <rohan@almeida.in>. All rights
reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

