package Google::Adwords::AdSchedule;
use strict;
use warnings;

use version; our $VERSION = qv('0.0.1');

use base 'Google::Adwords::Data';

my @fields = qw/
    _intervals
    status
    /;

__PACKAGE__->mk_accessors(@fields);

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

# intervals should always return an array ref
sub intervals
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

        $self->set( '_intervals', $put_ref );
        return $self;
    } # end if (@_)

    return $self->get('_intervals');
} # end sub intervals

1;

=pod

=head1 NAME
 
Google::Adwords::AdSchedule - A Google Adwords AdSchedule object.
 
=head1 VERSION
 
This documentation refers to Google::Adwords::AdSchedule version 0.0.1
 
 
=head1 SYNOPSIS
 
    # Create the Campaign object
    my $campaign = Google::Adwords::Campaign->new();

    # Campaign Details
    $campaign->name('Campaign with an Ad Schedule');
    $campaign->dailyBudget(100000);
    $campaign->languageTargeting({
        languages => 'en',
    });

    # Ad schedule
    my $schedule1 = Google::Adwords::SchedulingInterval->new();
    $schedule1->day('Monday')
              ->startHour(1)
              ->endHour(10)
              ->multiplier(1)
    ;

    my $ad_schedule = Google::Adwords::AdSchedule->new();
    $ad_schedule->status('Enabled');
    $ad_schedule->intervals([ $schedule1 ]);

    # Associate the Ad Schedule with the Campaign
    $campaign->schedule($ad_schedule);


=head1 DESCRIPTION
 
This object should be used with the CampaignService API calls
 
 
=head1 METHODS 
 
B<Mutators (read/write)>

* intervals - An arrayref of L<Google::Adwords::SchedulingInterval> objects

* status    - Values of 'Enabled' or 'Disabled'

=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::CampaignService>

=item * L<Google::Adwords::SchedulingInterval>

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


