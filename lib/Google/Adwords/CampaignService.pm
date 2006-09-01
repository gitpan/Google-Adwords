package Google::Adwords::CampaignService;
use strict; use warnings;

use version; our $VERSION = qv('0.0.1');

use base 'Google::Adwords::Service';
use Date::Manip;
use Data::Dumper;


### INSTANCE METHOD ################################################
# Usage      : 
#   my $campaign = $obj->addCampaign({
#       campaign => $campaign_obj
#   });
# Purpose    : Add a new campaign
# Returns    : ????
# Parameters : ????
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub addCampaign
{
    my ($self, $args_ref) = @_;

    my $campaign = $args_ref->{'campaign'};

    # daily_budget should be present
    if (not defined $campaign->dailyBudget) {
        die "dailyBudget should be set for the campaign object";
    }

    my @campaign_params;
    push @campaign_params, SOAP::Data->name(
        'dailyBudget' => $campaign->dailyBudget )->type('');

    # campaign name
    if (defined $campaign->name) {
        push @campaign_params, SOAP::Data->name(
            'name' => $campaign->name )->type('');
    }

    # status
    if (defined $campaign->status) {
        push @campaign_params, SOAP::Data->name(
            'status' => $campaign->status )->type('');
    }

    # end_day
    if (defined $campaign->endDay) {
        push @campaign_params, SOAP::Data->name(
            'endDay' => $campaign->endDay )->type('');
    }


    # language_targeting
    if (defined $campaign->languageTargeting) {
        my $langs_ref = $campaign->languageTargeting;
        if (scalar @{$langs_ref->{'languages'}} > 0) {
            push @campaign_params, SOAP::Data->name(
            'languageTargeting' 
                => \SOAP::Data->name('languages' 
                    => @{$langs_ref->{'languages'}})->type('')
            )->type('');
        }
    }

    # geo_targeting
    if (defined $campaign->geoTargeting) {
        my $geo_ref = $campaign->geoTargeting;
        my @geo_data;

        for (qw/countries cities metros regions/) {
            if ((defined $geo_ref->{$_}) and
                (scalar @{$geo_ref->{$_}} > 0))
            {
                push @geo_data, SOAP::Data->name($_  
                    => @{$geo_ref->{$_}})->type('');
            }
        }
        
        push @campaign_params, SOAP::Data->name(
            'geoTargeting' => \SOAP::Data->value(@geo_data),
        )->type('');
    }

    # network_targeting
    if (defined $campaign->networkTargeting) {
        my $network_ref = $campaign->networkTargeting;
        if (scalar @{$network_ref->{'networkTypes'}} > 0) {
            push @campaign_params, SOAP::Data->name(
            'networkTargeting' 
                => \SOAP::Data->name('networkTypes' 
                    => @{$network_ref->{'networkTypes'}})->type('')
            )->type('');
        }
    }

    my @params;
    push @params, SOAP::Data->name(
        'campaign' => \SOAP::Data->value(@campaign_params) )->type('');

    # create the SOAP service
    my $result = $self->_create_service_and_call({
        service => 'CampaignService',
        method => 'addCampaign',   
        params => \@params,
    });

    # get response data in a hash
    my $data = $result->valueof("//addCampaignResponse/addCampaignReturn");

    # format dates
    $data->{'startDay'} 
        = UnixDate(ParseDate($data->{'startDay'}), "%Y-%m-%d %H:%M:%S");
    $data->{'endDay'} 
        = UnixDate(ParseDate($data->{'endDay'}), "%Y-%m-%d %H:%M:%S");

    # get campaign object
    my $campaign_response 
        = $self->_create_object_from_hash($data, 'Google::Adwords::Campaign');
    
    return $campaign_response;
}

1;

=pod

=head1 NAME
 
Google::Adwords::CampaignService - Interact with the Google Adwords
CampaignService API calls
 
 
=head1 VERSION
 
This documentation refers to Google::Adwords::CampaignService version 0.0.1
 
 
=head1 SYNOPSIS
 
    use Google::Adwords::Campaign;
    use Google::Adwords::CampaignService;

    # create a new campaign object
    my $campaign = Google::Adwords::Campaign;

    # set values for the campaign object
    $campaign->name('My Final Try');
    $campaign->dailyBudget(10000000);

    # target a certain city in US
    $campaign->geoTargeting({
       cities => [ 'Pelican, AK US' ], 
    });
  
    # create the campaign service object
    my $campaign_service = Google::Adwords::CampaignService->new();

    # need to login to the Adwords service
    $campaign_service->email($email_address)
                     ->password($password)
                     ->token($developer_token);

    # now create the campaign
    my $campaign_response = $campaign_service->addCampaign({
        campaign => $campaign,
    });

    print "New campaign ID is :" . $campaign_response->id;
 
  
  
=head1 METHODS 
 
=head2 B<addCampaign()>

=head3 Description

=over 4

Create a new campaign.

=back

=head3 Usage

=over 4

    my $campaign = $obj->addCampaign({
        campaign => $campaign_obj
    });

=back

=head3 Parameters

Takes a hashref with following params:

=over 4

1) campaign - A Google::Adwords::Campaign object

=back

=head3 Returns
 
=over 4

$campaign => The new campaign details as a Google::Adwords::Campaign object

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

