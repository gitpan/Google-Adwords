package Google::Adwords::CampaignRequest;
use strict;
use warnings;

use base 'Google::Adwords::Data';

my @fields = qw/
    id
    adGroupRequests
    geoTargeting
    languageTargeting
    networkTargeting
    /;

__PACKAGE__->mk_accessors(@fields);

1;

__END__

=pod

=head1 NAME
 
Google::Adwords::CampaignRequest - A Google Adwords CampaignRequest Object
 

=head1 VERSION
 
This documentation refers to Google::Adwords::CampaignRequest version 0.0.1

=head1 DESCRIPTION
  
This object is a read/write object used in calls from Google Adwords API.

More info is available here - 

http://www.google.com/apis/adwords/developer/CampaignRequest.html

 
 
=head1 METHODS 
 
B<Mutators (read/write)>

* id - The id of the campaign to be estimated. Optional - if omitted, indicates a new campaign.

* adGroupRequests - The adgroups to be estimated. You must set at least one ad group whether the campaign exists already or is new. It's a list of Google::Adwords::AdGroupRequest objects.

* geoTargeting - The geographic targeting rules for this campaign. Optional - if omitted, targeting will be inherited from the existing campaign if specified or else global targeting will be used.

* languageTargeting - The languages targeted by this campaign. 

* networkTargeting - The advertising networks targeted by this campaign.

=head1 AUTHOR
 
Mathieu Jondet <mathieu@eulerian.com

Rohan Almeida <rohan@almeida.in>

 
 
=head1 LICENSE AND COPYRIGHT
 
Copyright (c) 2006 Rohan Almeida <rohan@almeida.in>. All rights
reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

