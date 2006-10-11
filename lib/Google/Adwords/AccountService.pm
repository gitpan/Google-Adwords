package Google::Adwords::AccountService;
use strict; use warnings;

use version; our $VERSION = qv('0.2');

use base 'Google::Adwords::Service';

# data types
use Google::Adwords::AccountInfo;
use Google::Adwords::EmailPromotionsPreferences;
use Google::Adwords::Address;
use Google::Adwords::CoverageType;
use Google::Adwords::CreditCard;

### INSTANCE METHOD ################################################
# Usage      : 
#   my $ret = $obj->createAdWordsAccount({
#       loginEmail  => $loginEmail, 
#       password    => $password, 
#       languagePreference => $lgPref, 
#       emailPrefs  => $emailPrefs, 
#       currencyCode => $curCode, 
#       cardInfo => $creditcard, 
#       contactInfo => $address, 
#       defaultAdsCoverage => $coverageType, 
#       timeZoneId => $timeZoneId
#   });
#
# Purpose    : 
#   Create a new AdWords account for an online advertiser. 
#   If this operation succeeds, the new account is ready for use. 
#   Customers need explicit permission from Google to use this method.
#
# Returns    : Returns 1 on success
# Parameters : ???
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub createAdWordsAccount
{
    my ($self, $args_ref) = @_;

    my @params;

    # loginEmail / password / languagePreference
    for (qw/loginEmail password languagePreference currencyCode/) {
        push @params, SOAP::Data->name(
            $_ => $args_ref->{$_} )->type('');
    }

    # emailPrefs
    my @emailprefs_params;
    if ( exists $args_ref->{emailPrefs} ) {
     my $emailprefs_obj = $args_ref->{emailPrefs};
     for ( qw/ marketResearchEnabled newsletterEnabled promotionsEnabled / ) {
      push @emailprefs_params, SOAP::Data->name(
       $_ => ( $emailprefs_obj->$_ ) ? 'true' : 'false' )->type('')
     }
    }
    push @params, SOAP::Data->name(
     'emailPrefs' => \SOAP::Data->value(@emailprefs_params) )->type('');

    # CreditCard
    my @creditcard_params;
    if ( exists $args_ref->{cardInfo} ) {
     my $cc_obj = $args_ref->{cardInfo};
     for ( qw/ cardNumber cardType cardVerificationNumber expirationMonth 
               expirationYear issueNumber startMonth startYear status taxNumber / ) {
      if ( defined $cc_obj->$_ ) {
       push @creditcard_params, SOAP::Data->name(
	        $_ => $cc_obj->$_ )->type('');
      }
     }
    }
    push @params, SOAP::Data->name(
     'cardInfo' => \SOAP::Data->value( @creditcard_params ) )->type('');
   
    # Address
    my @address_params;
    if ( exists $args_ref->{contactInfo} ) {
     my $add_obj = $args_ref->{contactInfo};
     for ( qw/ addressLine1 addressLine2 city companyName countryCode
       emailAddress faxNumber name phoneNumber postalCode state / ) {
      if ( defined $add_obj->$_ ) {
       push @address_params, SOAP::Data->name(
	        $_ => $add_obj->$_ )->type('');
      }
     }
    }
    push @params, SOAP::Data->name(
     'contactInfo' => \SOAP::Data->value( @address_params ) )->type('');

    # defaultAdsCoverage
    my @coveragetype_params;
    if ( exists $args_ref->{defaultAdsCoverage} ) {
     for ( qw/ optInContentNetwork optInSearchNetwork / ) {
      push @coveragetype_params, SOAP::Data->name(
       $_ => ( $args_ref->{defaultAdsCoverage}->$_ ) ? 'true' : 'false' )->type('');
     }
    }
    push @params, SOAP::Data->name(
     'defaultAdsCoverage' => \SOAP::Data->value( @coveragetype_params ) )->type('');

    
    # timeZoneId
    if ( exists $args_ref->{timeZoneId} ) {
     push @params, SOAP::Data->name(
       'timeZoneId' => $args_ref->{timeZoneId} )->type('');
    }

    
    my $result	= $self->_create_service_and_call({
     service	=> 'AccountService',
     method	=> 'createAdWordsAccount',
     params	=> \@params,
    });

    return	1;
}

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

    my $result	= $self->_create_service_and_call({
     service	=> 'AccountService',
     method	=> 'getAccountInfo',
    });

    # get response data in a hash
    my $data = $result->valueof("//getAccountInfoResponse/getAccountInfoReturn");

    my $account_info = 
     $self->_create_object_from_hash($data, 'Google::Adwords::AccountInfo');

    # primaryAddress 
    if (defined $account_info->primaryAddress) {
        $account_info->primaryAddress( 
            $self->_create_object_from_hash($data->{primaryAddress},
                'Google::Adwords::Address')
        );
    }

    # billingAddress
    if (defined $account_info->billingAddress) {
        $account_info->billingAddress(
            $self->_create_object_from_hash($data->{billingAddress},
                'Google::Adwords::Address')
        );
    }


    # defaultAdsCoverage
    if (defined $account_info->defaultAdsCoverage) {
        $account_info->defaultAdsCoverage(
            $self->_create_object_from_hash($data->{defaultAdsCoverage},
                'Google::Adwords::CoverageType')
        );
    }

    
    # emailPromotionsPreferences
    if (defined $account_info->emailPromotionsPreferences) {
        $account_info->emailPromotionsPreferences(
            $self->_create_object_from_hash($data->{emailPromotionsPreferences},
                'Google::Adwords::EmailPromotionsPreferences')
        );
    }


    return $account_info;
}

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
    my $self	= shift;
    
    my $result	= $self->_create_service_and_call({
     service	=> 'AccountService',
     method	=> 'getClientAccounts',
    });

    # get response data in a array
    my @data = $result->valueof("//getClientAccountsResponse/getClientAccountsReturn");

    return	@data;
}

### INSTANCE METHOD ################################################
# Usage      : 
#   my $creditcard = $obj->getCreditCard();
# Purpose    : Return credit card information for the current account. 
# Returns    : A Google::Adwords::CreditCard object.
# Parameters : none
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getCreditCard
{
    my $self	= shift;
    
    my $result	= $self->_create_service_and_call({
     service	=> 'AccountService',
     method	=> 'getCreditCard',
    });

    # get response data in a hash
    my $data = $result->valueof("//getCreditCardResponse/getCreditCardReturn");

    my $creditcard = $self->_create_object_from_hash($data, 'Google::Adwords::CreditCard');
    return	$creditcard;
}

### INSTANCE METHOD ################################################
# Usage      : 
#   my $ret = $obj->setCreditCard($creditcard, $address);
# Purpose    : Set the credit card information for the current account.
# Returns    : Always return 1.
# Parameters : 
#   A Google::Adwords::CreditCard object and a Google::Adwords::Address object.
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub setCreditCard
{
    my ($self, $creditcard, $address) = @_;

    if ( not defined $creditcard ) {
     die "Must provided a creditcard object.";
    }
    
    if ( not defined $address ) {
     die "Must provided an address object.";
    }

    my @params;

    my @creditcard_params;
    for ( qw/ cardNumber cardType cardVerificationNumber expirationMonth
     	expirationYear issueNumber startMonth startYear status taxNumber / ) {
     if ( defined $creditcard->$_ ) {
      push @creditcard_params, SOAP::Data->name(
       $_ => $creditcard->$_ )->type('');
     }
    }
    
    my @address_params;
    for ( qw/ addressLine1 addressLine2 city companyName countryCode
     	emailAddress faxNumber name phoneNumber postalCode state / ) {
     if ( defined $address->$_ ) {
      push @address_params, SOAP::Data->name(
       $_ => $address->$_ )->type('');
     }
    }

    push @params, SOAP::Data->name(
     'cardInfo' => \SOAP::Data->value( @creditcard_params ) )->type('');
    push @params, SOAP::Data->name(
     'contactInfo' => \SOAP::Data->value( @address_params ) )->type('');

    my $result	= $self->_create_service_and_call({
     service	=> 'AccountService',
     method	=> 'setCreditCard',
     params	=> \@params,
    });

    return	1;
}

### INSTANCE METHOD ################################################
# Usage      : 
#   my $ret = $obj->setLocalTimezone($timezone);
# Purpose    : Set the local timezone for this Account.
# Returns    : Always return 1.
# Parameters : The timezone.
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub setLocalTimezone
{
    my ($self, $timezone) = @_;

    if ( not defined $timezone ) {
     die "Must provide a timezone.";
    }
 
    my @params;
    push @params, SOAP::Data->name(
      'timezoneID' => $timezone )->type('');
    
    my $result	= $self->_create_service_and_call({
     service	=> 'AccountService',
     method	=> 'setLocalTimezone',
     params	=> \@params,
    });

    return	1;
}

### INSTANCE METHOD ################################################
# Usage      : 
#   my $ret = $obj->setLoginInfo($login,$newPassword);
# Purpose    : Set the login information for the current user.
# Returns    : Always return 1.
# Parameters : The login and the password.
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub setLoginInfo
{
    my ($self, $login, $password) = @_;

    if ( not defined $login ) {
     die "Must provide a login.";
    }
 
    if ( not defined $password ) {
     die "Must provide a password.";
    }

    my @params;
    push @params, SOAP::Data->name(
      'login' => $login )->type('');
    push @params, SOAP::Data->name(
      'newPassword' => $password )->type('');
    
    my $result	= $self->_create_service_and_call({
     service	=> 'AccountService',
     method	=> 'setLoginInfo',
     params	=> \@params,
    });

    return	1;
}

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
    my ($self, $account) = @_;

    if ( not defined $account ) {
     die "Must provide a account info object.";
    }

    my @params;
    my @account_params;

    # billingAddress
    if ( defined $account->billingAddress ) {
     my @billing_address;
     my $billing_address = $account->billingAddress;
     for ( qw/ addressLine1 addressLine2 city companyName countryCode
       emailAddress faxNumber name phoneNumber postalCode state / ) {
        if (defined $billing_address->$_) {
            push @billing_address, SOAP::Data->name(
                $_ => $billing_address->$_ )->type('');
        }
     }
     push @account_params, SOAP::Data->name(
      'billingAddress' => \SOAP::Data->value(@billing_address) )->type('');
    }

    # currencyCode
    if ( defined $account->currencyCode ) {
     push @account_params, SOAP::Data->name(
      'currencyCode' => $account->currencyCode )->type('');
    }
    
    # customerId
    if ( defined $account->customerId ) {
     push @account_params, SOAP::Data->name(
      'customerId' => $account->customerId )->type('');
    }

    # defaultAdsCoverage
    if ( defined $account->defaultAdsCoverage ) {
     my @coveragetype_params;
     my $coveragetype = $account->defaultAdsCoverage;
     for ( qw/ optInContentNetwork optInSearchNetwork / ) {
        if (defined $coveragetype->$_) {
            push @coveragetype_params, SOAP::Data->name(
                $_ => ( $coveragetype->$_ ) ? 'true' : 'false' )->type('');
        }
     }
     push @account_params, SOAP::Data->name(
      'defaultAdsCoverage' => \SOAP::Data->value(@coveragetype_params) )->type('');
    }

    # descriptiveName
    if ( defined $account->descriptiveName ) {
     push @account_params, SOAP::Data->name(
      'descriptiveName' => $account->descriptiveName )->type('');
    }

    # emailPromotionsPreferences
    if ( defined $account->emailPromotionsPreferences ) {
     my @emailpromprefs_params;
     my $emailpromprefs = $account->emailPromotionsPreferences;
     for ( qw/ marketResearchEnabled newsletterEnabled promotionsEnabled / ) {
        if (defined $emailpromprefs->$_) {
            push @emailpromprefs_params, SOAP::Data->name(
                $_ => ( $emailpromprefs->$_ ) ? 'true' : 'false' )->type('');
        }
     }
     push @account_params, SOAP::Data->name(
      'emailPromotionsPreferences' => \SOAP::Data->value(@emailpromprefs_params) )->type('');
    }

    # languagePreference
    if ( defined $account->languagePreference ) {
     push @account_params, SOAP::Data->name(
      'languagePreference' => $account->languagePreference )->type('');
    }

    # primaryAddress
    if ( defined $account->primaryAddress ) {
     my @primary_address;
     my $primary_address = $account->primaryAddress;
     for ( qw/ addressLine1 addressLine2 city companyName countryCode
       emailAddress faxNumber name phoneNumber postalCode state / ) {
        if (defined $primary_address->$_) {
            push @primary_address, SOAP::Data->name(
                $_ => $primary_address->$_ )->type('');
        }
     }
     push @account_params, SOAP::Data->name(
      'primaryAddress' => \SOAP::Data->value(@primary_address) )->type('');
    }

    # primaryBusinessCategory
    if ( defined $account->primaryBusinessCategory ) {
     push @account_params, SOAP::Data->name(
      'primaryBusinessCategory' => $account->primaryBusinessCategory)->type('');
    }

    push @params, SOAP::Data->name(
     'account' => \SOAP::Data->value( @account_params ) )->type('');

    my $result	= $self->_create_service_and_call({
     service	=> 'AccountService',
     method	=> 'updateAccountInfo',
     params	=> \@params,
    });

    return	1;
}


1;

=pod

=head1 NAME
 
Google::Adwords::AccountService - Interact with the Google Adwords
AccountService API calls
 
 
=head1 VERSION
 
This documentation refers to Google::Adwords::AccountService version 0.2
 
 
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
            ->applicationToken($app_token)
            ->developerToken($dev_token);

    # getAccountInfo
    my $account = $service->getAccountInfo();
    print "currencyCode : " . $account->currencyCode . "\n";
    print "descriptiveName : " . $account->descriptiveName . "\n";

    # getClientAccounts
    my @emailaccounts = $service->getClientAccounts();
    print "getClientAccounts : " . join('|', @emailaccounts) . "\n";

    # getCreditCard
    my $creditcard	= $service->getCreditCard();

    # setLoginInfo
    my $ret_setlogininfo= $service->setLoginInfo('email@example.com', 'toto');

    # setLocalTimezone to brrr ...
    my $ret_setlocaltimezone = $service->setLocalTimezone('America/Anchorage');

    # setCreditCard
    my $cc = Google::Adwords::CreditCard->new
                    ->cardNumber(12345678912346)
                    ->cardType('VISA')
                    ->cardVerificationNumber(123)
                    ->expirationMonth(1)
                    ->expirationYear(2008);

    my $addr = Google::Adwords::Address->new
                    ->addressLine1('down the street')
                    ->city('Paris')
                    ->companyName('Up there')
                    ->countryCode('FR')
                    ->emailAddress('me@example.com')
                    ->name('Up there')
                    ->phoneNumber('+33112345678')
                    ->postalCode('75020');

    my $ret_setcreditcard = $service->setCreditCard($cc, $addr);
 
    # createAdWordsAccount
    my $emailPrefs = Google::Adwords::EmailPromotionsPreferences->new
                        ->marketResearchEnabled(1)
                        ->newsletterEnabled(1)
                        ->promotionsEnabled(0);

    my $covType = Google::Adwords::CoverageType->new
                        ->optInContentNetwork(0)
                        ->optInSearchNetwork(1);
    
    my $ret = $service->createAdWordsAccount({
        loginEmail  => $loginEmail, 
        password    => $password, 
        languagePreference => $lgPref, 
        emailPrefs  => $emailPrefs, 
        currencyCode => $curCode, 
        cardInfo => $creditcard, 
        contactInfo => $address, 
        defaultAdsCoverage => $covType, 
        timeZoneId => $timeZoneId
    });

    # updateAccountInfo
    $account->primaryBusinessCategory('Advertising, Marketing, SEO');
    my $ret_updateaccountinfo = $service->updateAccountInfo($account);

=head1 DESCRIPTION

This module provides an interface to the Google Adword AccountService API
calls. 

  
=head1 METHODS 

=head2 B<createAdWordsAccount()>

=head3 Description

=over 4

Create a new AdWords account for an online advertiser. If this operation
succeeds, the new account is ready for use. Customers need explicit permission
from Google to use this method.

=back

=head3 Usage

=over 4
  
    my $ret = $obj->createAdWordsAccount({
        loginEmail  => $loginEmail,
        password    => $password,
        languagePreference => $lgPref,
        emailPrefs  => $emailPrefs,
        currencyCode => $curCode,
        cardInfo => $creditcard,
        contactInfo => $address,
        defaultAdsCoverage => $coverageType,
        timeZoneId => $timeZoneId
    });

=back

=head3 Parameters

Takes a hashref with following keys:

=over 4

=item * loginEmail : the login email.

=item * password : the password.

=item * languagePreference : the language preference.

=item * emailPrefs : a Google::Adwords::EmailPromotionsPreferences object.

=item * currencyCode : the currency code.

=item * cardInfo : a Google::Adwords::CreditCard object.

=item * contactInfo : a Google::Adwords::Address object.

=item * defaultAdsCoverage : a Google::Adwords::CoverageType object.

=item * timeZoneId : the id of the timezone.

=back

=head3 Returns
 
=over 4

1 on success

=back

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

=head2 B<getCreditCard()>

=head3 Description

=over 4

Return credit card information for the current account.

=back

=head3 Usage

=over 4

    my $creditcard = $obj->getCreditCard();

=back

=head3 Parameters

=over 4

None.

=back

=head3 Returns
 
=over 4

A Google::Adwords::CreditCard object.

=back

=head2 B<setCreditCard()>

=head3 Description

=over 4

Set the credit card information for the current account.

=back

=head3 Usage

=over 4

    my $ret = $obj->setCreditCard($creditcard, $address);

=back

=head3 Parameters

=over 4

=item * $creditcard : a Google::Adwords::CreditCard object.

=item * $address : a Google::Adwords::Address object.

=back

=head3 Returns
 
=over 4

1 on success

=back

=head2 B<setLocalTimezone()>

=head3 Description

=over 4

Set the local timezone for this Account.

=back

=head3 Usage

=over 4

    my $ret = $obj->setLocalTimezone($timezone);

=back

=head3 Parameters

=over 4

=item * $timezone : the timezone.

=back

=head3 Returns
 
=over 4

1 on success

=back

=head2 B<setLoginInfo()>

=head3 Description

=over 4

Set the login information for the current user.

=back

=head3 Usage

=over 4

    my $ret = $obj->setLoginInfo($login, $newPassword);

=back

=head3 Parameters

=over 4

=item * $login : the login.

=item * $newPassword : the password.

=back

=head3 Returns
 
=over 4

1 on success

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
 
=head1 LICENCE AND COPYRIGHT
 
Copyright (c) 2006 Rohan Almeida <rohan@almeida.in>. All rights
reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

