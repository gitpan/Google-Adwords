package Google::Adwords::InfoService;
use strict;
use warnings;

use version; our $VERSION = qv('0.1.1');

use base 'Google::Adwords::Service';

use Google::Adwords::ClientUsageRecord;

### INSTANCE METHOD ################################################
# Usage      : my $quota = $obj->getUsageQuotaThisMonth();
# Purpose    : ????
# Returns    : ????
# Parameters : ????
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getUsageQuotaThisMonth
{
    my ($self) = @_;

    # create the SOAP service
    my $result = $self->_create_service_and_call(
        {
            service => 'InfoService',
            method  => 'getUsageQuotaThisMonth',
        }
    );

    return $result->valueof(
        "//getUsageQuotaThisMonthResponse/getUsageQuotaThisMonthReturn");
} # end sub getUsageQuotaThisMonth

### INSTANCE METHOD ################################################
# Usage      : my $quota = $obj->getFreeUsageQuotaThisMonth();
# Purpose    : ????
# Returns    : ????
# Parameters : ????
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getFreeUsageQuotaThisMonth
{
    my ($self) = @_;

    # create the SOAP service
    my $result = $self->_create_service_and_call(
        {
            service => 'InfoService',
            method  => 'getFreeUsageQuotaThisMonth',
        }
    );

    return $result->valueof(
"//getFreeUsageQuotaThisMonthResponse/getFreeUsageQuotaThisMonthReturn"
    );
} # end sub getFreeUsageQuotaThisMonth

### INSTANCE METHOD ################################################
# Usage      :
#   my $cost = $obj->getMethodCost({
#       service => $service_name,
#       method => $method_name,
#       date => $date,
#   });
# Purpose    : ????
# Returns    : ????
# Parameters : ????
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getMethodCost
{
    my ( $self, $args_ref ) = @_;

    my @params;
    push @params,
        SOAP::Data->name( 'service' => $args_ref->{'service'} )->type('');
    push @params,
        SOAP::Data->name( 'method' => $args_ref->{'method'} )->type('');
    push @params, SOAP::Data->name( 'date' => $args_ref->{'date'} )->type('');

    # call the service
    my $result = $self->_create_service_and_call(
        {
            service => 'InfoService',
            method  => 'getMethodCost',
            params  => \@params,
        }
    );

    return $result->valueof("//getMethodCostResponse/getMethodCostReturn");
} # end sub getMethodCost

### INSTANCE METHOD ################################################
# Usage      :
#   my $cost = $obj->getOperationCount({
#       startDate => $date,
#       endDate => $date,
#   });
# Purpose    : ????
# Returns    : ????
# Parameters : ????
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getOperationCount
{
    my ( $self, $args_ref ) = @_;

    my @params;
    push @params,
        SOAP::Data->name( 'startDate' => $args_ref->{'startDate'} )->type('');
    push @params,
        SOAP::Data->name( 'endDate' => $args_ref->{'endDate'} )->type('');

    # call the service
    my $result = $self->_create_service_and_call(
        {
            service => 'InfoService',
            method  => 'getOperationCount',
            params  => \@params,
        }
    );

    return $result->valueof(
        "//getOperationCountResponse/getOperationCountReturn");
} # end sub getOperationCount

### INSTANCE METHOD ################################################
# Usage      :
#   my $units_count = $obj->getUnitCount({
#       startDate => $date,
#       endDate => $date,
#   });
# Purpose    : ????
# Returns    : ????
# Parameters : ????
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getUnitCount
{
    my ( $self, $args_ref ) = @_;

    my @params;
    push @params,
        SOAP::Data->name( 'startDate' => $args_ref->{'startDate'} )->type('');
    push @params,
        SOAP::Data->name( 'endDate' => $args_ref->{'endDate'} )->type('');

    # create the SOAP service
    my $result = $self->_create_service_and_call(
        {
            service => 'InfoService',
            method  => 'getUnitCount',
            params  => \@params,
        }
    );

    return $result->valueof("//getUnitCountResponse/getUnitCountReturn");
} # end sub getUnitCount

### INSTANCE METHOD ################################################
# Usage      :
#   my $units_count = $obj->getUnitCountForMethod({
#       service => $service_name,
#       method => $method_name,
#       startDate => $date,
#       endDate => $date,
#   });
# Purpose    : ????
# Returns    : ????
# Parameters : ????
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getUnitCountForMethod
{
    my ( $self, $args_ref ) = @_;

    my @params;
    push @params,
        SOAP::Data->name( 'service' => $args_ref->{'service'} )->type('');
    push @params,
        SOAP::Data->name( 'method' => $args_ref->{'method'} )->type('');
    push @params,
        SOAP::Data->name( 'startDate' => $args_ref->{'startDate'} )->type('');
    push @params,
        SOAP::Data->name( 'endDate' => $args_ref->{'endDate'} )->type('');

    # call the service
    # create the SOAP service
    my $result = $self->_create_service_and_call(
        {
            service => 'InfoService',
            method  => 'getUnitCountForMethod',
            params  => \@params,
        }
    );

    return $result->valueof(
        "//getUnitCountForMethodResponse/getUnitCountForMethodReturn");
} # end sub getUnitCountForMethod

### INSTANCE METHOD ################################################
# Usage      :
#   my @usage_records = $obj->getUnitCountForClients({
#       clientEmails => [ $emai1, $email2 ],
#       startDate => $date,
#       endDate => $date,
#   });
# Purpose    : ????
# Returns    : ????
# Parameters : ????
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getUnitCountForClients
{
    my ( $self, $args_ref ) = @_;

    my @params;

    push @params,
        SOAP::Data->name( 'startDate' => $args_ref->{'startDate'} )->type('');
    push @params,
        SOAP::Data->name( 'endDate' => $args_ref->{'endDate'} )->type('');

    # clientEmails
    my @client_emails = ();
    if (   ( exists $args_ref->{'clientEmails'} )
        && ( scalar @{ $args_ref->{'clientEmails'} } > 0 ) )
    {
        for ( @{ $args_ref->{'clientEmails'} } ) {
            push @client_emails, $_;
        }
    }
    push @params,
        SOAP::Data->name( 'clientEmails' => @client_emails )->type('');

    # call the service
    # create the SOAP service
    my $result = $self->_create_service_and_call(
        {
            service => 'InfoService',
            method  => 'getUnitCountForClients',
            params  => \@params,
        }
    );

    my @ret;
    for (
        $result->valueof(
            "//getUnitCountForClientsResponse/getUnitCountForClientsReturn")
        )
    {
        push @ret,
            $self->_create_object_from_hash( $_,
            'Google::Adwords::ClientUsageRecord' );
    }

    return @ret;
} # end sub getUnitCountForClients

1;

=pod

=head1 NAME
 
Google::Adwords::InfoService - Interact with the Google Adwords InfoService
API calls
 
 
=head1 VERSION
 
This documentation refers to Google::Adwords::InfoService version 0.0.2
 
 
=head1 SYNOPSIS
 
    use Google::Adwords::InfoService;

    my $ginfo = Google::Adwords::InfoService->new();

    $ginfo->email('email@domain.com')
          ->password('password')
          ->developerToken('developer_token')
          ->applicationToken('application_token');

    # If you use a MCC
    $ginfo->clientEmail('clientemail@domain.com');

    my $quota = $ginfo->getFreeUsageQuotaThisMonth;
    print "Free quota this month is $quota\n"; 

    my $operations_count = $ginfo->getOperationCount({
        startDate => $start_date,
        endDate => $end_date,
    });
    print "Number of operations: $operations_count\n";

  
=head1 METHODS 
 
=head2 B<getUsageQuotaThisMonth()>

=head3 Description

=over 4

Retrieves this month's total usage quota, including free quota usage, or the
developer token being used to make this call.

=back

=head3 Usage

=over 4

    my $quota = $ginfo->getUsageQuotaThisMonth();

=back

=head3 Parameters

=over 4

NONE

=back

=head3 Returns
 
=over 4

$quota - A number

=back

=head2 B<getFreeUsageQuotaThisMonth()>

=head3 Description

=over 4

Designed specifically for AdWords Commercial Developer Program participants.
Retrieves this month's free usage quota for the developer token being used to
make this call. For those not enrolled in the AdWords Commercial Developer
Program, this value will be identical to that returned for
getUsageQuotaThisMonth.

=back

=head3 Usage

=over 4

    my $quota = $ginfo->getFreeUsageQuotaThisMonth();

=back

=head3 Parameters

=over 4

NONE

=back

=head3 Returns
 
=over 4

$quota - A number

=back

=head2 B<getMethodCost()>

=head3 Description

=over 4

Retrieves the cost, in quota units per operation, of the given method on a
specific date. Methods default to a cost of 1.

=back

=head3 Usage

=over 4

    my $cost = $ginfo->getMethodCost({
        service => $service_name,
        method => $method_name,
        date => $date,
    });

=back

=head3 Parameters

=over 4

A hashref with keys:

* service - The name of the service containing the method, for example,
"ReportService".

* method - The method whose quota cost is being queried, for example
"scheduleReportJob".

* date   - The date for which to retrieve the cost of the method. An error 
occurs if this date is in the future. Format is YYYY-MM-DD


=back

=head3 Returns
 
=over 4

$cost - the cost, in quota units per operation

=back

=head2 B<getOperationCount()>

=head3 Description

=over 4

Retrieves the number of operations recorded for the developer token being used
to make this call over the given date range. The time zone is implicitly
assumed to be Pacific time (PST or PDT). The given dates are inclusive; to get
the operation count for a single day, supply it as both the start and end
date.


=back

=head3 Usage

=over 4

    my $count = $ginfo->getOperationCount({
        startDate => $date,
        endDate => $date,
    });

=back

=head3 Parameters

=over 4

A hashref with keys:

* startDate  - the beginning of the date range, inclusive. YYYY-MM-DD format.

* ebdDate    - the end of the date range, inclusive. YYYY-MM-DD format.


=back

=head3 Returns
 
=over 4

$count - the number of operations recorded in the given date range

=back

=head2 B<getUnitCount()>

=head3 Description

=over 4

Retrieves the number of quota units recorded for the developer token being
used to make this call over the given date range. The time zone is implicitly
assumed to be Pacific time (PST or PDT). The given dates are inclusive; to get
the unit count for a single day, supply it as both the start and end date.


=back

=head3 Usage

=over 4

    my $count = $ginfo->getUnitCount({
        startDate => $date,
        endDate => $date,
    });

=back

=head3 Parameters

=over 4

A hashref, with keys:

* startDate  - the beginning of the date range, inclusive. YYYY-MM-DD format.

* endDate    - the end of the date range, inclusive. YYYY-MM-DD format.

=back

=head3 Returns
 
=over 4

$count - the number of quota units recorded over the given date range

=back

=head2 B<getUnitCountForMethod()>

=head3 Description

=over 4

Retrieves the number of quota units recorded for the developer token being
used to make this call over the given date range for a specific method. The
time zone is implicitly assumed to be Pacific time (PST or PDT). The given
dates are inclusive; to get the unit count for a single day, supply it as both
the start and end date.

=back

=head3 Usage

=over 4

    my $count = $ginfo->getUnitCountForMethod({
        service => $service_name,
        method => $method_name,
        startDate => $date,
        endDate => $date,
    });

=back

=head3 Parameters

=over 4

A hashref, with keys:

* service - The name of the service containing the method, for example,
"ReportService".

* method - The method whose quota cost is being queried, for example
"scheduleReportJob".

* startDate  - the beginning of the date range, inclusive. YYYY-MM-DD format.

* endDate    - the end of the date range, inclusive. YYYY-MM-DD format.


=back

=head3 Returns
 
=over 4

$count - the number of quota units recorded over the given date range

=back

=head2 B<getUnitCountForClients()>

=head3 Description

=over 4

Retrieves the number of quota units recorded for a subset of clients over the
given date range. The time zone is implicitly assumed to be Pacific time (PST
or PDT). The given dates are inclusive; to get the unit count for a single
day, supply it as both the start and end date.

=back

=head3 Usage

=over 4

    my @usage_records = $ginfo->getUnitCountForClients({
        clientEmails => [ $emai1, $email2 ],
        startDate => $date,
        endDate => $date,
    });

=back

=head3 Parameters

=over 4

A hashref, with keys:

* clientEmails => arrayref of client emails

* startDate  - the beginning of the date range, inclusive. YYYY-MM-DD format.

* endDate    - the end of the date range, inclusive. YYYY-MM-DD format.


=back

=head3 Returns
 
=over 4

@usage_records => A list of Google::Adwords::ClientUsageRecord objects

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

 
