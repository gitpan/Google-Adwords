package Google::Adwords::Service;
use strict;
use warnings;

use version; our $VERSION = qv('0.13.2');

use base qw/ Class::Accessor::Chained Google::Adwords /;
use SOAP::Lite;
use Readonly;

Readonly my $default_api_version => 'v11';
Readonly my $user_agent          => "Google::Adwords v1.9.3";
Readonly my $endpoint            => 'https://adwords.google.com/api/adwords';
Readonly my $endpoint_sandbox    => 'https://sandbox.google.com/api/adwords';
Readonly my $default_timeout => 35;    # HTTP timeout in seconds

__PACKAGE__->mk_accessors(
    qw/
        email
        password
        developerToken
        applicationToken
        useragent
        api_version
        use_sandbox
        clientEmail
        clientCustomerId
        timeout
        debug
        requestId
        operations
        units
        responseTime
        /
);

### CLASS METHOD ##################################################
# Usage      : Google::Adwords::Service->new();
# Purpose    : ????
# Returns    : ????
# Parameters : ????
# Throws     : no exceptions
# Comments   : This method should never be called directly
# See Also   : n/a
####################################################################
sub new
{
    my $class = shift;

    my $self = {};

    # don't use sandbox by default
    $self->{'use_sandbox'} = 0;

    # no debugging by default
    $self->{'debug'} = 0;

    # set default timeout
    $self->{'timeout'} = $default_timeout;

    # default useragent
    $self->{'useragent'} = $user_agent;

    # Adwords API version
    $self->{api_version} = $default_api_version;

    bless $self, $class;
    return $self;
} # end sub new

### INTERNAL UTILITY #################################################
# Usage      : ????
# Purpose    : ????
# Returns    : ????
# Parameters : ????
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub _get_soap_headers
{
    my ($self) = @_;

    my @headers = (
        SOAP::Header->name("email")->value( $self->email )->type(''),
        SOAP::Header->name("password")->value( $self->password )->type(''),
        SOAP::Header->name("useragent")->value( $self->useragent )->type(''),
        SOAP::Header->name("developerToken")->value( $self->developerToken )
            ->type(''),
        SOAP::Header->name("applicationToken")
            ->value( $self->applicationToken )->type(''),
    );

    # check for clientEmail header
    if ( defined $self->clientEmail )
    {
        push @headers,
            SOAP::Header->name("clientEmail")->value( $self->clientEmail )
            ->type('');
    }

    # or the clientCustomerId header
    if ( defined $self->clientCustomerId )
    {
        push @headers, SOAP::Header->name("clientCustomerId")
            ->value( $self->clientCustomerId )->type('');
    }

    return @headers;
} # end sub _get_soap_headers

### INTERNAL UTILITY ##############################################
# Usage      : $self->_endpoint();
# Purpose    : Return the endpoint URL to use
# Returns    : ????
# Parameters : ????
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub _endpoint
{
    my ($self) = @_;

    if ( $self->use_sandbox )
    {
        return $endpoint_sandbox . '/' . $self->api_version;
    }
    else
    {
        return $endpoint . '/' . $self->api_version;
    }
}

### INTERNAL UTILITY ##################################################
# Usage      :
#   $service = $obj->_create_soap_service({
#       service => $service_name,
#   });
# Purpose    : Create the SOAP service
# Returns    : $service => SOAP::Lite object
# Parameters : ????
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub _create_soap_service
{
    my ( $self, $args_ref ) = @_;

    my $endpoint = $self->_endpoint . '/' . $args_ref->{'service'};
    my $service = SOAP::Lite->proxy( $endpoint, timeout => $self->timeout );

    if ( $self->debug )
    {
        SOAP::Lite->import( +trace => 'debug' );
    }

    return $service;
}

### INTERNAL UTILITY ####################################################
# Usage      :
#   $result = $self->_call({
#       service => $service,
#       method => $method_name,
#       params => $params_ref, (optional)
#   );
# Purpose    : Call the SOAP service
# Returns    : ????
# Parameters : ????
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub _call
{
    my ( $self, $args_ref ) = @_;

    # get the headers
    my @headers = $self->_get_soap_headers();

    # create the method
    my $method = SOAP::Data->name( $args_ref->{'method'} );

    # Blank out the earlier response header values
    $self->requestId('');
    $self->responseTime('');
    $self->operations('');
    $self->units('');

    # set uri endpoint if requested
    if ( ( defined $args_ref->{'with_uri'} ) && ( $args_ref->{'with_uri'} ) )
    {
        $method->uri( $endpoint . '/' . $self->api_version )->prefix('');
    }

    # call the SOAP service
    my $result;
    eval {
        $result = $args_ref->{'service'}->call(
            $method => @headers,
            @{ $args_ref->{'params'} },
        );
    };
    if ($@)
    {

        # TODO: return an error object
        die "Error: $@\n";
    }

    # check for SOAP faults
    if ( $result->fault )
    {
        die "Fault Code: "
            . $result->faultcode . "\n"
            . "Fault Description: "
            . $result->faultstring . "\n";
    }

    # get the SOAP response headers
    for (qw/requestId responseTime operations units/)
    {
        $self->$_( $result->headerof("//$_")->value );
    }

    return $result;
} # end sub _call

### INTERNAL UTILITY ###################################################
# Usage      :
#   $result = $self->_create_service_and_call({
#       service => $service_name,
#       method => $method_name,
#       params => \@params,
#   });
# Purpose    : ????
# Returns    : ????
# Parameters : ????
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub _create_service_and_call
{
    my ( $self, $args_ref ) = @_;

    # create the SOAP service
    my $service = $self->_create_soap_service(
        { service => $args_ref->{'service'}, } );

    # call the service
    my $result = $self->_call(
        {
            service  => $service,
            method   => $args_ref->{'method'},
            params   => $args_ref->{'params'},
            with_uri => $args_ref->{'with_uri'},
        }
    );

    return $result;
} # end sub _create_service_and_call

### INTERNAL UTILITY ####################################################
# Usage      : $obj = $self->_create_object_from_hash($hashref, $class_name);
# Purpose    : Create a object from a hash ref
# Returns    : $obj => an object of type $class_name
# Parameters : ????
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub _create_object_from_hash
{
    my ( $self, $hashref, $class_name ) = @_;

    # XXX wtf?
    if ( ref $hashref ne 'HASH' )
    {
        $hashref = {};
    }

    my $obj = $class_name->new($hashref);
    return $obj;
}

1;

=pod

=head1 NAME
 
Google::Adwords::Service - Base class for the Service modules
 
 
=head1 VERSION
 
This documentation refers to Google::Adwords::Service version 0.13.2
 
 
=head1 DESCRIPTION
 
This module is not supposed to be used directly. Use the child 
Service modules. See the L<Google::Adwords> documentation for the list of available
child Service modules.
 
=head1 METHODS

These accessors/methods are available across all the child Service modules

=head2 B<new()>

=head3 Description

    Creates a new Google::Adwords::*Service object

=head3 Usage

    my $service = Google::Adwords::CampaignService->new();

=head3 Parameters

    NONE

=head3 Returns
 
    A Google::Adwords::*Service object

=head2 B<email()>

    Set your Google Adwords account name (your email address). This 
    value should be set before calling any other API methods

=head2 B<password()>

    Set your Google Adwords account password. This 
    value should be set before calling any other API methods

=head2 B<developerToken()>

    Set your Google Adwords developer token. This 
    value should be set before calling any other API methods

=head2 B<applicationToken()>

    Set your Google Adwords application token. This 
    value should be set before calling any other API methods

=head2 B<clientEmail()>

    Use this if you have a MCC (My Client Center) account. Set the actual
    client email which will be used for the API calls.

=head2 B<clientCustomerId()>

    Use this if you have a MCC (My Client Center) account. Set the actual
    client customerid which will be used for the API calls.
    One of clientEmail and clientCustomerId must be set but NOT both.

=head2 B<useragent()>

    Set this to an arbitrary string that identifies the customer sending the
    request. Default value is "Google::Adwords $VERSION"

=head2 B<api_version()>

    The Adwords API version you want to use. In format 'v*'. So, to use 
    version 7 of the API, set this to a value of 'v7'. Default value is 'v9'.

=head2 B<use_sandbox()>

    If you do $obj->use_sandbox(1), then this module will use the 
    sandbox for all API calls. 

=head2 B<timeout()>

    Set the SOAP timeout value in seconds. Default value is 35 seconds.

=head2 B<debug()>

    Use $obj->debug(1) if you want to trace the request/response XML

=head2 B<api_version()>

    Returns version information for the Adwords API


B<The following accessors are available after an API call is done. These give
information about the response>

=head2 B<requestId()>

=over 4

Get the unique ID that identifies this request.

=back

=head2 B<operations()>

=over 4

number of operations in the request

=back

=head2 B<units()>

=over 4

number of quota units the request used

=back

=head2 B<responseTime()>

=over 4

elapsed time between the web service receiving the request and sending the
response

=back

 
=head1 DEPENDENCIES
 
=over 4

=item * SOAP::Lite

=item * Class::Accessor::Chained

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

