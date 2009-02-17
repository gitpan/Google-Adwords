package Google::Adwords::AccountService;
use strict;
use warnings;

use version; our $VERSION = qv('0.4');

use base 'Google::Adwords::Service';

# data types
use Google::Adwords::AccountInfo;
use Google::Adwords::EmailPromotionsPreferences;
use Google::Adwords::Address;
use Google::Adwords::CoverageType;
use Google::Adwords::CreditCard;
use Google::Adwords::NetworkTarget;

### INSTANCE METHOD ################################################
# Usage      :
#   my $accountinfo = $obj->getAccountInfo();
# Purpose    : Return the AdWords account specified by the client account header
# Returns    : A Google::Adwords::AccountInfo object.
# Parameters : none
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getAccountInfo
{
    my ($self) = @_;

    my $result = $self->_create_service_and_call(
        {
            service => 'AccountService',
            method  => 'getAccountInfo',
        }
    );

    # get response data in a hash
    my $data
        = $result->valueof("//getAccountInfoResponse/getAccountInfoReturn");

    my $account_info = $self->_create_object_from_hash( $data,
        'Google::Adwords::AccountInfo' );

    # primaryAddress
    if ( defined $account_info->primaryAddress )
    {
        $account_info->primaryAddress(
            $self->_create_object_from_hash(
                $data->{primaryAddress},
                'Google::Adwords::Address'
            )
        );
    }

    # billingAddress
    if ( defined $account_info->billingAddress )
    {
        $account_info->billingAddress(
            $self->_create_object_from_hash(
                $data->{billingAddress},
                'Google::Adwords::Address'
            )
        );
    }

    # emailPromotionsPreferences
    if ( defined $account_info->emailPromotionsPreferences )
    {
        $account_info->emailPromotionsPreferences(
            $self->_create_object_from_hash(
                $data->{emailPromotionsPreferences},
                'Google::Adwords::EmailPromotionsPreferences'
            )
        );
    }

    # defaultNetworkTargeting
    if ( defined $account_info->defaultNetworkTargeting )
    {

        #print Dumper $data->{defaultNetworkTargeting};
        $account_info->defaultNetworkTargeting(
            $self->_create_object_from_hash(
                $data->{defaultNetworkTargeting},
                'Google::Adwords::NetworkTarget',
            )
        );
    }

    return $account_info;
} # end sub getAccountInfo

### INSTANCE METHOD ################################################
# Usage      :
#   my @emails = $obj->getClientAccounts();
# Purpose    :
#   Gets the primary email address for each account managed
#   by the effective user. If the effective user user has no
#   client accounts, an empty array is returned.
# Returns    : A list of account login emails.
# Parameters : none
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getClientAccounts
{
    my $self = shift;

    my $result = $self->_create_service_and_call(
        {
            service => 'AccountService',
            method  => 'getClientAccounts',
        }
    );

    # get response data in a array
    my @data = $result->valueof(
        "//getClientAccountsResponse/getClientAccountsReturn");

    return @data;
} # end sub getClientAccounts

### INSTANCE METHOD ################################################
# Usage      :
#   my $ret = $obj->updateAccountInfo($account);
# Purpose    : Updates the database to reflect the changes in the account object
# Returns    : Always return 1.
# Parameters : A Google::Adwords::AccountInfo object.
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub updateAccountInfo
{
    my ( $self, $account ) = @_;

    if ( not defined $account )
    {
        die "Must provide a account info object.";
    }

    my @params;
    my @account_params;

    # billingAddress
    if ( defined $account->billingAddress )
    {
        my @billing_address;
        my $billing_address = $account->billingAddress;
        for (
            qw/ addressLine1 addressLine2 city companyName countryCode
            emailAddress faxNumber name phoneNumber postalCode state /
            )
        {
            if ( defined $billing_address->$_ )
            {
                push @billing_address,
                    SOAP::Data->name( $_ => $billing_address->$_ )->type('');
            }
        }
        push @account_params,
            SOAP::Data->name(
            'billingAddress' => \SOAP::Data->value(@billing_address) )
            ->type('');
    } # end if ( defined $account->billingAddress...

    # currencyCode
    if ( defined $account->currencyCode )
    {
        push @account_params,
            SOAP::Data->name( 'currencyCode' => $account->currencyCode )
            ->type('');
    }

    # customerId
    if ( defined $account->customerId )
    {
        push @account_params,
            SOAP::Data->name( 'customerId' => $account->customerId )
            ->type('');
    }

    # defaultNetworkTargeting
    if ( defined $account->defaultNetworkTargeting )
    {
        my @def_targeting;
        my $def_net_targeting = $account->defaultNetworkTargeting;
        if ( defined $def_net_targeting->networkTypes )
        {
            for ( @{ $def_net_targeting->networkTypes } )
            {
                push @def_targeting,
                    SOAP::Data->name( networkTypes => $_ )->type('');
            }
        }

        push @account_params,
            SOAP::Data->name(
            'defaultNetworkTargeting' => \SOAP::Data->value(@def_targeting) )
            ->type('');
    } # end if ( defined $account->defaultNetworkTargeting...

    # descriptiveName
    if ( defined $account->descriptiveName )
    {
        push @account_params,
            SOAP::Data->name( 'descriptiveName' => $account->descriptiveName )
            ->type('');
    }

    # emailPromotionsPreferences
    if ( defined $account->emailPromotionsPreferences )
    {
        my @emailpromprefs_params;
        my $emailpromprefs = $account->emailPromotionsPreferences;
        for (
            qw/ accountPerformanceEnabled disapprovedAdsEnabled
            marketResearchEnabled newsletterEnabled promotionsEnabled /
            )
        {
            if ( defined $emailpromprefs->$_ )
            {
                push @emailpromprefs_params,
                    SOAP::Data->name( $_ => $emailpromprefs->$_ )->type('');
            }
        }
        push @account_params,
            SOAP::Data->name( 'emailPromotionsPreferences' =>
                \SOAP::Data->value(@emailpromprefs_params) )->type('');
    } # end if ( defined $account->emailPromotionsPreferences...

    # languagePreference
    if ( defined $account->languagePreference )
    {
        push @account_params,
            SOAP::Data->name(
            'languagePreference' => $account->languagePreference )->type('');
    }

    # primaryAddress
    if ( defined $account->primaryAddress )
    {
        my @primary_address;
        my $primary_address = $account->primaryAddress;
        for (
            qw/ addressLine1 addressLine2 city companyName countryCode
            emailAddress faxNumber name phoneNumber postalCode state /
            )
        {
            if ( defined $primary_address->$_ )
            {
                push @primary_address,
                    SOAP::Data->name( $_ => $primary_address->$_ )->type('');
            }
        }
        push @account_params,
            SOAP::Data->name(
            'primaryAddress' => \SOAP::Data->value(@primary_address) )
            ->type('');
    } # end if ( defined $account->primaryAddress...

    # primaryBusinessCategory
    if ( defined $account->primaryBusinessCategory )
    {
        push @account_params,
            SOAP::Data->name(
            'primaryBusinessCategory' => $account->primaryBusinessCategory )
            ->type('');
    }

    push @params,
        SOAP::Data->name( 'account' => \SOAP::Data->value(@account_params) )
        ->type('');

    my $result = $self->_create_service_and_call(
        {
            service => 'AccountService',
            method  => 'updateAccountInfo',
            params  => \@params,
        }
    );

    return 1;
} # end sub updateAccountInfo

1;

=pod

=head1 NAME
 
Google::Adwords::AccountService - Interact with the Google Adwords
AccountService API calls
 
 
=head1 VERSION
 
This documentation refers to Google::Adwords::AccountService version 0.3
 
 
=head1 SYNOPSIS

    use Google::Adwords::AccountService;
    use Google::Adwords::AccountInfo;
    use Google::Adwords::CoverageType;
    use Google::Adwords::EmailPromotionsPreferences;
    use Google::Adwords::CreditCard;
    use Google::Adwords::Address;

    my $service = Google::Adwords::AccountService->new();

    # login to the Adwords server
    $service->email($email)
            ->password($password)
            ->clientEmail($cemail)
           or
            ->clientCustomerId($ccustomerid)
            ->applicationToken($app_token)
            ->developerToken($dev_token);

    # getAccountInfo
    my $account = $service->getAccountInfo();
    print "currencyCode : " . $account->currencyCode . "\n";
    print "descriptiveName : " . $account->descriptiveName . "\n";

    # getClientAccounts
    my @emailaccounts = $service->getClientAccounts();
    print "getClientAccounts : " . join('|', @emailaccounts) . "\n";

    # updateAccountInfo
    $account->primaryBusinessCategory('Advertising, Marketing, SEO');
    my $ret_updateaccountinfo = $service->updateAccountInfo($account);

=head1 DESCRIPTION

This module provides an interface to the Google Adword AccountService API
calls. 

  
=head1 METHODS 

=head2 B<getAccountInfo()>

=head3 Description

=over 4

Return the AdWords account specified by the client account header.

=back

=head3 Usage

=over 4

     my $accountinfo = $obj->getAccountInfo();

=back

=head3 Parameters

=over 4

None.

=back

=head3 Returns
 
=over 4

A Google::Adwords::AccountInfo object.

=back

=head2 B<getClientAccounts()>

=head3 Description

=over 4

Gets the primary email address for each account managed by the effective user.
If the effective user user has no client accounts, an empty array is returned.

=back

=head3 Usage

=over 4

    my @emails = $obj->getClientAccounts();

=back

=head3 Parameters

=over 4

None.

=back

=head3 Returns
 
=over 4

An array of account login emails.

=back

=head2 B<updateAccountInfo()>

=head3 Description

=over 4

Updates the database to reflect the changes in the account object.

=back

=head3 Usage

=over 4

    my $ret = $obj->updateAccountInfo($account);

=back

=head3 Parameters

=over 4

=item * $account : a Google::Adwords::AccountInfo object.

=back

=head3 Returns
 
=over 4

1 on success

=back

=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::AccountInfo>

=item * L<Google::Adwords::CoverageType>

=item * L<Google::Adwords::EmailPromotionsPreferences>

=item * L<Google::Adwords::CreditCard>

=item * L<Google::Adwords::Address>

=back

=head1 AUTHORS
 
Rohan Almeida <rohan@almeida.in>
 
Mathieu Jondet <mathieu@eulerian.com>
 
=head1 LICENSE AND COPYRIGHT
 
Copyright (c) 2006 Rohan Almeida <rohan@almeida.in>. All rights
reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

