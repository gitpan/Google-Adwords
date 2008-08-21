package Google::Adwords::ConversionOptimizerSettings;
use strict;
use warnings;

use version; our $VERSION = qv('0.1');

use base 'Google::Adwords::Data';

my @fields = qw/
    enabled
    maxCpaBidForAllAdGroups
    /;

__PACKAGE__->mk_accessors(@fields);

1;

=pod

=head1 NAME
 
Google::Adwords::ConversionOptimizerSettings - A Google Adwords ConversionOptimizerSettings 
Object
 
 
=head1 VERSION
 
This documentation refers to Google::Adwords::ConversionOptimizerSettings
version 0.1
 
 
=head1 SYNOPSIS
 
    # Create the Campaign object
    my $campaign = Google::Adwords::Campaign->new();

    # Campaign Details
    $campaign->name('Campaign with an Ad Schedule');
    $campaign->dailyBudget(100000);
    $campaign->languageTargeting({
        languages => 'en',
    });

    # BudgetOptimizerSettings object
    my $budget_optimizer = Google::Adwords::BudgetOptimizerSettings->new;
    $budget_optimizer->bidCeiling(200000);
    $budget_optimizer->enabled(1);

    # Associate the budget optimizer with the Campaign
    $campaign->budgetOptimizerSettings($budget_optimizer);


  
=head1 DESCRIPTION
 
This object should be used with the CampaignService API calls
 
 
=head1 METHODS 
 
B<Mutators (read/write)>

* bidCeiling

* enabled

* takeOnOptimizedBids


=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::Campaign>

=item * L<Google::Adwords::CampaignService>

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

