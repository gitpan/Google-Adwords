package Google::Adwords::EmailPromotionsPreferences;
use strict;
use warnings;

use version; our $VERSION = qv('0.2');

use base 'Google::Adwords::Data';

my @fields = qw/
    accountPerformanceEnabled
    disapprovedAdsEnabled
    marketResearchEnabled
    newsletterEnabled
    promotionsEnabled
    /;

__PACKAGE__->mk_accessors(@fields);

1;

=pod

=head1 NAME
 
Google::Adwords::EmailPromotionsPreferences - A Google Adwords 
EmailPromotionsPreferences object
 
=head1 VERSION
 
This documentation refers to Google::Adwords::EmailPromotionsPreferences version 0.0.1
 
 
=head1 SYNOPSIS
 
    use Google::Adwords::EmailPromotionsPreferences;

    my $emailpromotionsprefs = Google::Adwords::EmailPromotionsPreferences->new
                                ->marketResearchEnabled(1)
                                ->newsletterEnabled(0)
                                ->promotionsEnabled(1);
  
=head1 DESCRIPTION
 
This object should be used with the AccountService API calls
 
 
=head1 METHODS 
 
B<Mutators (read/write)>

* marketResearchEnabled

* newsletterEnabled

* promotionsEnabled

=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::AccountService>

=back

=head1 AUTHOR
 
Rohan Almeida <rohan@almeida.in>

 
=head1 LICENSE AND COPYRIGHT
 
Copyright (c) 2006 Rohan Almeida <rohan@almeida.in>. All rights
reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


