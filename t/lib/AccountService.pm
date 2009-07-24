package AccountService;
use base qw/ Service /;

use Test::More;
use Test::MockModule;

use Google::Adwords::EmailPromotionsPreferences;
use Google::Adwords::CreditCard;
use Google::Adwords::Address;
use Google::Adwords::NetworkTarget;
use Data::Dumper;

sub test_class { return "Google::Adwords::AccountService"; }

# tests to run
my %tests = (
    getAccountInfo    => 1,
    getClientAccounts => 0,
    updateAccountInfo => 0,
    getMccAlerts      => 1,
);

sub start_of_each_test : Test(setup)
{
    my $self = shift;

    # set debug to whatever was passed in as param
    $self->{obj}->debug( $self->{debug} );
}

sub getAccountInfo : Test(no_plan)
{
    my ($self) = @_;

    $sub_name = ( caller 0 )[3];
    $sub_name =~ s/^.+:://;
    if ( not $tests{$sub_name} )
    {
        return;
    }

    if ( $self->{sandbox} )
    {

        my $account_info = $self->{obj}->getAccountInfo();

        ok(
            $account_info->primaryAddress->emailAddress eq
                $self->{obj}->clientEmail,
            'getAccountInfo'
        );
        ok(
            ref $account_info->defaultNetworkTargeting->networkTypes eq
                'ARRAY',
            'defaultNetworkTargeting'
        );
        ok(
            $account_info->defaultNetworkTargeting->networkTypes->[0] eq
                'GoogleSearch',
            'defaultNetworkTargeting'
        );

        ok(
            $account_info->emailPromotionsPreferences
                ->accountPerformanceEnabled eq 'false',
            'emailPromotionsPreferences'
        );

    } # end if ( $self->{sandbox} ...
    else
    {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock(
            call => sub {
                my $xml .= <<'EOF';
<getAccountInfoResponse xmlns="">
   <ns1:getAccountInfoReturn xmlns:ns1="https://adwords.google.com/api/adwords/v11">
    <ns1:currencyCode>INR</ns1:currencyCode>
    <ns1:customerId>2019</ns1:customerId>
    <ns1:defaultNetworkTargeting>
     <ns1:networkTypes>ContentNetwork</ns1:networkTypes>
    </ns1:defaultNetworkTargeting>
    <ns1:descriptiveName></ns1:descriptiveName>
    <ns1:emailPromotionsPreferences>
     <ns1:accountPerformanceEnabled>false</ns1:accountPerformanceEnabled>
     <ns1:disapprovedAdsEnabled>false</ns1:disapprovedAdsEnabled>
     <ns1:marketResearchEnabled>false</ns1:marketResearchEnabled>
     <ns1:newsletterEnabled>false</ns1:newsletterEnabled>
     <ns1:promotionsEnabled>false</ns1:promotionsEnabled>
    </ns1:emailPromotionsPreferences>
    <ns1:languagePreference>en_US</ns1:languagePreference>
    <ns1:primaryAddress>
     <ns1:addressLine1></ns1:addressLine1>
     <ns1:addressLine2></ns1:addressLine2>
     <ns1:city></ns1:city>
     <ns1:companyName></ns1:companyName>
     <ns1:countryCode></ns1:countryCode>
     <ns1:emailAddress>client_1+rohan.almeida@gmail.com</ns1:emailAddress>
     <ns1:faxNumber></ns1:faxNumber>
     <ns1:name></ns1:name>
     <ns1:phoneNumber></ns1:phoneNumber>
     <ns1:postalCode></ns1:postalCode>
     <ns1:state></ns1:state>
    </ns1:primaryAddress>
    <ns1:timeZoneEffectiveDate>1205415885000</ns1:timeZoneEffectiveDate>
    <ns1:timeZoneId>America/New_York</ns1:timeZoneId>
   </ns1:getAccountInfoReturn>
  </getAccountInfoResponse>
EOF

                $xml = $self->gen_full_response($xml);
                my $env = SOAP::Deserializer->deserialize($xml);
                return $env;
            }
        );

        my $account_info = $self->{obj}->getAccountInfo();

        ok( $account_info->currencyCode eq 'INR', 'getAccountInfo' );
        ok( $account_info->customerId == 2019, 'getAccountInfo' );
        ok(
            $account_info->emailPromotionsPreferences->newsletterEnabled eq
                'false',
            'getAccountInfo'
        );
        ok(
            $account_info->primaryAddress->emailAddress eq
                'client_1+rohan.almeida@gmail.com',
            'getAccountInfo'
        );
        ok(
            ref $account_info->defaultNetworkTargeting->networkTypes eq
                'ARRAY',
            'defaultNetworkTargeting'
        );

    }

} # end sub getAccountInfo :

sub getClientAccounts : Test(no_plan)
{
    my $self = shift;

    $sub_name = ( caller 0 )[3];
    $sub_name =~ s/^.+:://;
    if ( not $tests{$sub_name} )
    {
        return;
    }

    if ( $self->{sandbox} )
    {

        my @emails = $self->{obj}->getClientAccounts();

        return;
    }
    else
    {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock(
            call => sub {
                my $xml .= <<'EOF';
  <getClientAccountsResponse xmlns="" />
EOF

                $xml = $self->gen_full_response($xml);
                my $env = SOAP::Deserializer->deserialize($xml);
                return $env;
            }
        );

        my @emails = $self->{obj}->getClientAccounts;
        ok( scalar @emails == 0, 'getClientAccounts' );

    }

} # end sub getClientAccounts :

sub updateAccountInfo : Test(no_plan)
{
    my $self = shift;

    $sub_name = ( caller 0 )[3];
    $sub_name =~ s/^.+:://;
    if ( not $tests{$sub_name} )
    {
        return;
    }

    if ( $self->{sandbox} )
    {

        my $account_info = Google::Adwords::AccountInfo->new;

        my $billing_address = Google::Adwords::Address->new;
        $billing_address->addressLine1('Flat No');
        $billing_address->city('Mumbai');

        my $net_target = Google::Adwords::NetworkTarget->new();
        $net_target->networkTypes( [qw/ GoogleSearch ContentNetwork /] );

        #$account_info->billingAddress($billing_address);
        my $email_promo = Google::Adwords::EmailPromotionsPreferences->new();
        $email_promo->accountPerformanceEnabled('false');

        $account_info->emailPromotionsPreferences($email_promo);
        $account_info->defaultNetworkTargeting($net_target);

        my $ret = $self->{obj}->updateAccountInfo($account_info);

        return;

    } # end if ( $self->{sandbox} ...
    else
    {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock(
            call => sub {
                my $xml .= <<'EOF';
  <updateAccountInfoResponse xmlns="" />
EOF

                $xml = $self->gen_full_response($xml);
                my $env = SOAP::Deserializer->deserialize($xml);
                return $env;
            }
        );

        my $account_info = Google::Adwords::AccountInfo->new;

        my $billing_address = Google::Adwords::Address->new;
        $billing_address->addressLine1('Flat No');
        $billing_address->city('Mumbai');

        $account_info->billingAddress($billing_address);

        my $ret = $self->{obj}->updateAccountInfo($account_info);

        ok( $ret == 1, 'updateAccountInfo' );

    }
} # end sub updateAccountInfo :

sub getMccAlerts : Test(no_plan)
{
    my $self = shift;

    $sub_name = ( caller 0 )[3];
    $sub_name =~ s/^.+:://;
    if ( not $tests{$sub_name} )
    {
        return;
    }

    if ( $self->{sandbox} )
    {

        my @mcc_alerts = $self->{obj}->getMccAlerts();

        return;
    }
    else
    {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock(
            call => sub {
                my $xml .= <<'EOF';
  <getMccAlertsResponse xmlns="" />
EOF

                $xml = $self->gen_full_response($xml);
                my $env = SOAP::Deserializer->deserialize($xml);
                return $env;
            }
        );

        my @mcc_alerts = $self->{obj}->getMccAlerts;
        ok( scalar @mcc_alerts == 0, 'getMccAlerts' );

    }

} # end sub getClientAccounts :

1;

