package Google::Adwords::ClientUsageRecord;
use strict;
use warnings;

use version; our $VERSION = qv('0.0.1');

use base 'Google::Adwords::Data';

my @fields = qw/
    clientEmail
    quotaUnits
    /;

__PACKAGE__->mk_accessors(@fields);

1;

=pod

=head1 NAME
 
Google::Adwords::ClientUsageRecord - A Google Adwords ClientUsageRecord object.
 
=head1 VERSION
 
This documentation refers to Google::Adwords::ClientUsageRecord version 0.0.1
 
 
=head1 SYNOPSIS
 
    use Google::Adwords::InfoService;

    my $ginfo = Google::Adwords::InfoService->new();

    $ginfo->email('email@domain.com')
          ->password('password')
          ->developerToken('developer_token')
          ->applicationToken('application_token');

    # If you use a MCC
    $ginfo->clientEmail('clientemail@domain.com');

    my @usage_records = $ginfo->getUnitCountForClients({
        clientEmails => [ $email1, $email2 ],
        startdate => $start_date,
        endDate => $end_date,
    });

    print "Quota Units for client " 
        . $usage_records[0]->clientEmail 
        . ' is '
        . $usage_records[0]->quotaUnits 
        . "\n";

=head1 DESCRIPTION
 
This object should be used with the InfoService::getUnitCountForClients API call
 
 
=head1 METHODS 
 
B<Accessors (read only)>

=over 4

=item * clientEmail - The login for identifying this client account

=item * quotaUnits - The number of quota units recorded for this client

=back


=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::InfoService>

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



