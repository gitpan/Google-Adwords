package Google::Adwords::SchedulingInterval;
use strict; use warnings;

use version; our $VERSION = qv('0.0.1');

use base 'Google::Adwords::Data';

my @fields = qw/
    day
    endHour
    endMinute
    multiplier
    startHour
    startMinute
/;

__PACKAGE__->mk_accessors(@fields);

1;

=pod

=head1 NAME
 
Google::Adwords::SchedulingInterval - A Google Adwords SchedulingInterval object.
 
=head1 VERSION
 
This documentation refers to Google::Adwords::SchedulingInterval version 0.0.1
 
 
=head1 SYNOPSIS
 
    # Create the Campaign object
    my $campaign = Google::Adwords::Campaign->new();

    # Campaign Details
    $campaign->name('Campaign with an Ad Schedule');
    $campaign->dailyBudget(100000);
    $campaign->languageTargeting({
        languages => 'en',
    });

    # Ad scheduling interval
    my $schedule1 = Google::Adwords::SchedulingInterval->new();
    $schedule1->day('Monday')
              ->startHour(1)
              ->endHour(10)
              ->multiplier(1)
    ;

    # Ad Schedule
    my $ad_schedule = Google::Adwords::AdSchedule->new();
    $ad_schedule->status('Enabled');
    $ad_schedule->intervals([ $schedule1 ]);

    # Associate the Ad Schedule with the Campaign
    $campaign->schedule($ad_schedule);



=head1 DESCRIPTION
 
This object should be used with the CampaignService API calls
 
 
=head1 METHODS 
 
B<Mutators (read/write)>

* day 

* endHour

* endMinute

* multiplier

* startHour

* startMinute


=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::CampaignService>

=item * L<Google::Adwords::AdSchedule>

=back

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


