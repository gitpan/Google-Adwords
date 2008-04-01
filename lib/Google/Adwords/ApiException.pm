package Google::Adwords::ApiException;
use strict;
use warnings;

use version; our $VERSION = qv('0.0.1');

use base 'Google::Adwords::Data';

my @fields = qw/
    code
    _errors
    message
    trigger
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

sub errors
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

        $self->set( '_errors', $put_ref );
        return $self;
    } # end if (@_)

    return $self->get('_errors');
} # end sub errors

1;

=pod

=head1 NAME
 
Google::Adwords::Creative - A Google Adwords Creative object.
 
=head1 VERSION
 
This documentation refers to Google::Adwords::Creative version 0.0.1
 
 
=head1 SYNOPSIS
 
    use Google::Adwords::CreativeService;
    use Google::Adwords::Creative;

    # create the CreativeService object
    my $creative_service = Google::Adwords::CreativeService->new();

    # need to login to the Adwords service
    $creative_service->email($email_address)
                     ->password($password)
                     ->developerToken($developer_token)
                     ->applicationToken($app_token);

    # if you have a MCC
    $creative_service->clientEmail($client_email);

    # get a specific creative from an AdGroup
    my $adgroupid = 1123
    my $creativeid      = 7819;

    my $creative = $creative_service->getCreative($adgroupid, $creativeid);
    print "Creative Info: \n" 
        . " ID: " . $creative->id . "\n"
        . " Dest URL: " . $creative->destinationUrl . "\n"
        . " Display URL: " . $creative->displayUrl . "\n"
    ;


=head1 DESCRIPTION
 
This object should be used with the CreativeService API calls
 
 
=head1 METHODS 
 
B<Mutators (read/write)>

* adGroupId - The ID of the AdGroup owning this Creative.

* description1 - The first line of description text in the Creative.

* description2 - The second line of description text in the Creative.

* destinationUrl - The destination URL associated with this Creative. May be
overriden on a per-keyword basis by Keyword.destinationUrl. Must be in the
full "http://" URL format. Example: http://www.google.com

* displayUrl - The URL shown in a Creative. The full "http://" URL format is
not required. Example: www.google.com

* exemptionRequest - Optional field that specifies a reason for allowing
submission of a Creative or Keyword that violates the ad policies described
by Google's AdWords Editorial Guidelines. Maximum length of the
exemptionRequest string is 300 characters.

* headline - The headline of a text Creative.

* image - A Google::Adwords::Image object.

B<Accessors (read only)>
    

* id - The ID of this Creative.

* disapproved - Whether this Creative has been disapproved by Google.
Disapproved Creatives will not be served. Creatives might be disapproved for
a variety of reasons.

* deleted - Whether this Creative is deleted. Deleted Creatives are not
served.

=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::CreativeService>

=item * L<Google::Adwords::Image>

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


