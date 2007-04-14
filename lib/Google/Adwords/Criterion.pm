package Google::Adwords::Criterion;
use strict;
use warnings;

use version; our $VERSION = qv('0.2.1');

use base 'Google::Adwords::Data';

my @fields = qw/
    adGroupId
    criterionType
    destinationUrl
    exemptionRequest
    id
    language
    negative
    paused
    status
    maxCpc
    minCpc
    proxyMaxCpc
    text
    type
    maxCpm
    url
    /;

__PACKAGE__->mk_accessors(@fields);

1;

=pod

=head1 NAME
 
Google::Adwords::Criterion - A Google Adwords Criterion object.
 
=head1 VERSION
 
This documentation refers to Google::Adwords::Criterion version 0.2.1
 
 
=head1 SYNOPSIS
 
    use Google::Adwords::CriterionService;
    use Google::Adwords::Criterion;

    # create the CriterionService object
    my $criterion_service = Google::Adwords::CriterionService->new();

    # need to login to the Adwords service
    $criterion_service->email($email_address)
                     ->password($password)
                     ->developerToken($developer_token)
                     ->applicationToken($app_token);

    # if you have a MCC
    $criterion_service->clientEmail($client_email);
    # or 
    $criterion_service->clientCustomerId($customer_id);

    my $adgroupid	= 123456789;

    # get all the criteria for an adgroup
    my @getallcriteria	= $criterion_service->getAllCriteria($adgroupid);
    for ( @getallcriteria ) {
        print "Criterion text : " . $_->text . " , Id : " . $_->id . "\n";
    }

    # get a specific criterion from an AdGroup
    my $criterionid	= 987654321;

    my $getcriterion = $criterion_service->getCriteria($adgroupid, [ $criterionid ]);
    print "Get criterion: " . $getcriterion->text . ", Id : " . $getcriterion->id . "\n";

    # remove a criterion
    my $ret	= $criterion_service->removeCriteria($adgroupid, [ $criterionid ]);
    
    # add a criterion
    my $criterion_keyword = Google::Adwords::Criterion->new
            ->adGroupId($adgroupid)
            ->criterionType('Keyword')
            ->type('Broad')
            ->text('Aarohan & Technologies');

    my $addcriterion	= $criterion_service->addCriteria($criterion_keyword);
    print "Added Criterion ID: " . $addcriterion->id . "\n";



=head1 DESCRIPTION
 
This object should be used with the CriterionService API calls
 
 
=head1 METHODS 
 
B<Accessors>

* adGroupId

* criterionType

* destinationUrl

* exemptionRequest

* id

* language

* negative

* paused

* status

* maxCpc

* minCpc

* proxyMaxCpc

* text

* type

* maxCpm

* url

=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::CriterionService>

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


