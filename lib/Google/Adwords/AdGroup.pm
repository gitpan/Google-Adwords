package Google::Adwords::AdGroup;
use strict; use warnings;

use version; our $VERSION = qv('0.0.1');

use base 'Google::Adwords::Data';
use Data::Dumper;

my @fields = qw/
    campaignId
    id
    maxContentCpc
    maxCpc
    maxCpm
    name
    status
/;

__PACKAGE__->mk_accessors(@fields);

1;

=pod

=head1 NAME
 
Google::Adwords::AdGroup - A Google Adwords AdGroup Object
 
 
=head1 VERSION
 
This documentation refers to Google::Adwords::AdGroup version 0.0.1
 
 
=head1 SYNOPSIS
 
    use Google::Adwords::AdGroup;
    use Google::Adwords::AdGroupService;

    # create a new adgroup object
    my $adgroup = Google::Adwords::AdGroup->new;

    # in campaign having ID 4567
    my $campaign_id = 4567;

    # set values for the adgroup object
    $adgroup->name('My Final Try');
    $adgroup->maxCpc(2000000);

    # create the adgroup service object
    my $adgroup_service = Google::Adwords::AdGroupService->new();

    # need to login to the Adwords service
    $adgroup_service->email($email_address)
                     ->password($password)
                     ->token($developer_token);

    # if you use a MCC
    #$adgroup_service->clientEmail($client_email);

    # now create the adgroup 
    my $adgroup_response = $adgroup_service->addAdGroup($campaign_id, $adgroup);

    print "New adgroup ID is :" . $adgroup_response->id;
 
  
=head1 DESCRIPTION
 
This object should be used with the AdGroupService API calls
 
 
=head1 METHODS 
 
B<Mutators (read/write)>

* name

* campaignId

* maxCpm

* maxCpc

* maxContentCpc

* status

B<Accessors (read only)>

* id


=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::AdGroupService>

=back


=head1 AUTHOR
 
Rohan Almeida <rohan@almeida.in>

Mathieu Jondet <mathieu@eulerian.com>
 
=head1 LICENCE AND COPYRIGHT
 
Copyright (c) 2006 Rohan Almeida <rohan@almeida.in>. All rights
reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

