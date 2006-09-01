package Google::Adwords::Service;
use strict; use warnings;

use version; our $VERSION = qv('0.0.1');

use base qw/ Class::Accessor::Chained Google::Adwords /;
use SOAP::Lite; # +trace => 'debug';
use Data::Dumper;
use Readonly;

Readonly my $user_agent => 'SOAP::Lite';
Readonly my $endpoint => 'https://adwords.google.com/api/adwords/v4';
Readonly my $endpoint_sandbox => 'https://sandbox.google.com/api/adwords/v4';
Readonly my $soap_timeout => 10;

__PACKAGE__->mk_accessors(qw/
    email
    password
    token
    use_sandbox
/);

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

    bless $self, $class;
    return $self;
}


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
        SOAP::Header->name("email")->value($self->email),
        SOAP::Header->name("password")->value($self->password),
        SOAP::Header->name("useragent")->value($user_agent),
        SOAP::Header->name("token")->value($self->token),
        SOAP::Header->name("clientEmail")->value('client_2+' . $self->email),
    );

    return @headers;
}


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

    if ($self->use_sandbox) {
        return $endpoint_sandbox;
    }
    else {
        return $endpoint;
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
    my ($self, $args_ref) = @_;

    my $endpoint = $self->_endpoint . '/' . $args_ref->{'service'};
    my $service = SOAP::Lite->proxy($endpoint, timeout => $soap_timeout);

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
    my ($self, $args_ref) = @_;

    # get the headers
    my @headers = $self->_get_soap_headers();

    # create the method
    my $method = SOAP::Data->name($args_ref->{'method'});
        
    # call the SOAP service
    my $result;
    eval {
        $result = $args_ref->{'service'}->call(
            $method => @headers, @{$args_ref->{'params'}},
        );
    };
    if ($@) {
        # TODO: return an error object
        die "SOAP timeout";
    }
    
    # check for SOAP faults
    if ($result->fault) {
        die "Fault Code: " . $result->faultcode;
    }
    
    return $result; 
}


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
    my ($self, $args_ref) = @_;

    # create the SOAP service
    my $service = $self->_create_soap_service({
        service => $args_ref->{'service'},
    });
        
    # call the service
    my $result = $self->_call({
        service => $service,
        method => $args_ref->{'method'},   
        params => $args_ref->{'params'},
    });

    return $result;
}


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
    my ($self, $hashref, $class_name) = @_;

    my $obj = $class_name->new($hashref);
    return $obj;
}

1;

=pod

=head1 NAME
 
Google::Adwords::Service - Base class for the Service modules
 
 
=head1 VERSION
 
This documentation refers to Google::Adwords::Service version 0.0.1
 
 
=head1 DESCRIPTION
 
This module is not supposed to be used directly. Use the child 
Service modules.
 
=head1 METHODS

These accessors are available across all the child Service modules

=head2 B<new()>

=head3 Description

=over 4

Creates a new Google::Adwords::Service object

=back

=head3 Usage

=over 4

my $ginfo = Google::Adwords::Service->new();

=back

=head3 Parameters

=over 4

NONE

=back

=head3 Returns
 
=over 4

A Google::Adwords::Service object

=back

=head2 B<email()>

=over 4

Set/Get your Google Adwords account name (your email address). This 
value should be set before calling any other API methods

=back

=head2 B<password()>

=over 4

Set/Get your Google Adwords account password. This 
value should be set before calling any other API methods

=back

=head2 B<token()>

=over 4

Set/Get your Google Adwords developer token. This 
value should be set before calling any other API methods

=back

=head2 B<use_sandbox()>

=over 4

If you do $obj->use_sandbox(1), then this module will use the 
sandbox for all API calls. 

=back

 
=head1 DEPENDENCIES
 
* SOAP::Lite

 
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

