package Google::Adwords::ApiError;
use strict;
use warnings;

use version; our $VERSION = qv('0.1');

use base 'Google::Adwords::Data';

my @fields = qw/
    code
    detail
    isExemptable
    field
    index
    textIndex
    textLength
    trigger
    /;

__PACKAGE__->mk_accessors(@fields);

1;

=pod

=head1 NAME
 
Google::Adwords::ApiError - Represents the details of a user error.
 
=head1 VERSION
 
This documentation refers to Google::Adwords::ApiError version 0.1
 
 
=head1 SYNOPSIS
 


=head1 DESCRIPTION
 
Represents the details of a user error. Errors are accumulated during the
processing of a call and then thrown as part of an ApiException.
 
 
=head1 METHODS 
 
B<Accessors>

* code - Integer that identifies this error.

* detail - The error message.

* isExemptable - True if user can request an exemption for this violation. For
example, this field is true for a trademark violation on a keyword, which
allows you to request an exemption.

* field - Name of the field in the API data object where the error occurred.

* index - Index into input array of the element that caused this error. For 
example, given an array of Criterion passed in to addCriteria, if the 5th
element caused this error, index would be value 4.

* textIndex - The character index into the text string that caused the error. 
For example, if the problem is with the 5th character in the text of an ad,
textIndex would be value 4.

* textLength - The number of characters in the string that caused the error.

* trigger - The text that is in violation of policy.

=head1 AUTHOR
 
Rohan Almeida <rohan@almeida.in>
 
 
=head1 LICENSE AND COPYRIGHT
 
Copyright (c) 2006,2007 Rohan Almeida <rohan@almeida.in>. All rights
reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


