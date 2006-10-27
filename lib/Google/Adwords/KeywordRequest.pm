package Google::Adwords::KeywordRequest;

use base 'Google::Adwords::Data';

my @fields = qw/
    id
    maxCpc
    negative
    text
    type
/;

__PACKAGE__->mk_accessors(@fields);

1;

__END__

=pod

=head1 NAME
 
Google::Adwords::KeywordRequest - A Google Adwords KeywordRequest Object
 

=head1 VERSION
 
This documentation refers to Google::Adwords::KeywordRequest version 0.0.1

=head1 DESCRIPTION
  
This object is a read/write object used in calls from Google Adwords API.

More info is available here - 

http://www.google.com/apis/adwords/developer/KeywordRequest.html

 
 
=head1 METHODS 
 
B<Mutators (read/write)>
  
* id - The id of the keyword. Optional - if omitted indicates a new keyword.

* maxCpc - The bid (maximum cost per click) for this keyword in micros.

* negative - If set to 1, the keyword is used to filter out variations. Otherwise, acts as a source of variations.

* text - The text of the source keyword.

* type - The type of the source keyword, which determines how variations are generated : Broad, Phrase or Exact.

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

