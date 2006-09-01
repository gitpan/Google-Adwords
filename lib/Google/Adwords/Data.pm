package Google::Adwords::Data;
use strict; use warnings;

use version; our $VERSION = qv('0.0.1');

use base qw/ Class::Accessor::Chained Google::Adwords /;
use Data::Dumper;
use Readonly;

__PACKAGE__->mk_accessors(qw/
/);

1;

=pod

=head1 NAME
 
Google::Adwords::Data - Base class for the Data modules
 
 
=head1 VERSION
 
This documentation refers to Google::Adwords::Data version 0.0.1
 
 
=head1 DESCRIPTION
 
This module is not supposed to be used directly. Use the child 
data modules.
 
 
=head1 AUTHOR
 
Rohan Almeida <rohan@almeida.in>

 
 
=head1 LICENCE AND COPYRIGHT
 
Copyright (c) 2006 Rohan Almeida <rohan@almeida.in>. All rights
reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

