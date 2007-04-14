package Google::Adwords::ReportJob;
use strict;
use warnings;

use base 'Google::Adwords::Data';

my @fields = qw/
    adGroups
    adGroupStatuses
    adWordsType
    aggregationType
    campaigns
    campaignStatuses
    clientEmails
    crossClient
    customOptions
    endDay
    id
    includeZeroImpression
    keywords
    keywordStatuses
    keywordType
    name
    startDay
    status
    /;

__PACKAGE__->mk_accessors(@fields);

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

