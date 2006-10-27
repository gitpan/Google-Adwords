package Google::Adwords::CampaignEstimate;

use base 'Google::Adwords::Data';

my @fields = qw/
    id
    adGroupEstimates
/;

__PACKAGE__->mk_accessors(@fields);

1;

__END__

=pod

=head1 NAME
 
Google::Adwords::CampaignEstimate - A Google Adwords CampaignEstimate Object
 

=head1 VERSION
 
This documentation refers to Google::Adwords::CampaignEstimate version 0.0.1

=head1 DESCRIPTION
  
This object is a read-only object used in calls from Google Adwords API.

More info is available here - 

http://www.google.com/apis/adwords/developer/CampaignEstimate.html

 
 
=head1 METHODS 
 
B<Accessors (read-only)>

* id - The existing campaign id, if any, to which this estimate corresponds. If the campaign is new, the id is -1.

* adGroupEstimates - The ad group estimates for this campaign. Each Google::Adwords::AdGroupEstimate contains Google::Adwords::KeywordEstimate objects.

=head1 AUTHOR
 
Mathieu Jondet <mathieu@eulerian.com

Rohan Almeida <rohan@almeida.in>

 
 
=head1 LICENCE AND COPYRIGHT
 
Copyright (c) 2006 Rohan Almeida <rohan@almeida.in>. All rights
reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

