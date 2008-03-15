package Google::Adwords::ReportJob;
use strict;
use warnings;

use base 'Google::Adwords::Data';

my @fields = qw/
    _adGroups
    _adGroupStatuses
    adWordsType
    _aggregationTypes
    _campaigns
    _campaignStatuses
    _keywords
    _keywordStatuses
    keywordType
    _selectedColumns
    selectedReportType
    _clientEmails
    crossClient
    endDay
    id
    includeZeroImpression
    name
    startDay
    status
    /;

__PACKAGE__->mk_accessors(@fields);

sub get_fields
{
    return (
        qw/
            adGroups
            adGroupStatuses
            adWordsType
            aggregationTypes
            campaigns
            campaignStatuses
            keywords
            keywordStatuses
            keywordType
            selectedColumns
            selectedReportType
            clientEmails
            crossClient
            endDay
            id
            includeZeroImpression
            name
            startDay
            status
            /
    );
} # end sub get_fields

sub new
{
    my $proto = shift;

    my $class = ref $proto || $proto;

    if (@_)
    {
        my $obj     = $class->SUPER::new();
        my $hashref = shift;
        for ( keys %{$hashref} )
        {
            $obj->$_( $hashref->{$_} );
        }
        return $obj;
    }
    else
    {
        return $class->SUPER::new();
    }
} # end sub new

sub adGroups
{
    my $self = shift;

    # if its a put
    if (@_)
    {
        my $put_ref = [];

        for (@_)
        {
            if ( ref $_ ne 'ARRAY' )
            {
                push @{$put_ref}, $_;
            }
            else
            {
                push @{$put_ref}, @{$_};
            }
        }

        $self->set( '_adGroups', $put_ref );
    } # end if (@_)

    return $self->get('_adGroups');
} # end sub adGroups

sub adGroupStatuses
{
    my $self = shift;

    # if its a put
    if (@_)
    {
        my $put_ref = [];

        for (@_)
        {
            if ( ref $_ ne 'ARRAY' )
            {
                push @{$put_ref}, $_;
            }
            else
            {
                push @{$put_ref}, @{$_};
            }
        }

        $self->set( '_adGroupStatuses', $put_ref );
    } # end if (@_)

    return $self->get('_adGroupStatuses');
} # end sub adGroupStatuses

sub aggregationTypes
{
    my $self = shift;

    # if its a put
    if (@_)
    {
        my $put_ref = [];

        for (@_)
        {
            if ( ref $_ ne 'ARRAY' )
            {
                push @{$put_ref}, $_;
            }
            else
            {
                push @{$put_ref}, @{$_};
            }
        }

        $self->set( '_aggregationTypes', $put_ref );
    } # end if (@_)

    return $self->get('_aggregationTypes');
} # end sub aggregationTypes

sub campaigns
{
    my $self = shift;

    # if its a put
    if (@_)
    {
        my $put_ref = [];

        for (@_)
        {
            if ( ref $_ ne 'ARRAY' )
            {
                push @{$put_ref}, $_;
            }
            else
            {
                push @{$put_ref}, @{$_};
            }
        }

        $self->set( '_campaigns', $put_ref );
    } # end if (@_)

    return $self->get('_campaigns');
} # end sub campaigns

sub campaignStatuses
{
    my $self = shift;

    # if its a put
    if (@_)
    {
        my $put_ref = [];

        for (@_)
        {
            if ( ref $_ ne 'ARRAY' )
            {
                push @{$put_ref}, $_;
            }
            else
            {
                push @{$put_ref}, @{$_};
            }
        }

        $self->set( '_campaignStatuses', $put_ref );
    } # end if (@_)

    return $self->get('_campaignStatuses');
} # end sub campaignStatuses

sub clientEmails
{
    my $self = shift;

    # if its a put
    if (@_)
    {
        my $put_ref = [];

        for (@_)
        {
            if ( ref $_ ne 'ARRAY' )
            {
                push @{$put_ref}, $_;
            }
            else
            {
                push @{$put_ref}, @{$_};
            }
        }

        $self->set( '_clientEmails', $put_ref );
    } # end if (@_)

    return $self->get('_clientEmails');
} # end sub clientEmails

sub keywords
{
    my $self = shift;

    # if its a put
    if (@_)
    {
        my $put_ref = [];

        for (@_)
        {
            if ( ref $_ ne 'ARRAY' )
            {
                push @{$put_ref}, $_;
            }
            else
            {
                push @{$put_ref}, @{$_};
            }
        }

        $self->set( '_keywords', $put_ref );
    } # end if (@_)

    return $self->get('_keywords');
} # end sub keywords

sub keywordStatuses
{
    my $self = shift;

    # if its a put
    if (@_)
    {
        my $put_ref = [];

        for (@_)
        {
            if ( ref $_ ne 'ARRAY' )
            {
                push @{$put_ref}, $_;
            }
            else
            {
                push @{$put_ref}, @{$_};
            }
        }

        $self->set( '_keywordStatuses', $put_ref );
    } # end if (@_)

    return $self->get('_keywordStatuses');
} # end sub keywordStatuses

sub selectedColumns
{
    my $self = shift;

    # if its a put
    if (@_)
    {
        my $put_ref = [];

        for (@_)
        {
            if ( ref $_ ne 'ARRAY' )
            {
                push @{$put_ref}, $_;
            }
            else
            {
                push @{$put_ref}, @{$_};
            }
        }

        $self->set( '_selectedColumns', $put_ref );
    } # end if (@_)

    return $self->get('_selectedColumns');
} # end sub selectedColumns

1;

__END__

=pod

=head1 NAME
 
Google::Adwords::ReportJob - A Google Adwords ReportJob Object
 
 
=head1 VERSION
 
This documentation refers to Google::Adwords::ReportJob version 0.0.1

=head1 DESCRIPTION
  
This object is used with the ReportService module
 
=head1 METHODS 
 
B<Mutators (read/write)>

* adGroups

* adGroupStatuses

* adWordsType

* aggregationType

* campaigns

* campaignStatuses

* clientEmails

* crossClient

* customOptions

* endDay

* id

* includeZeroImpression

* keywords

* keywordStatuses

* keywordType

* name

* startDay

* status

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

