package AccountService;
use base qw/ Service /;

use Test::More;
use Test::MockModule;

use Google::Adwords::EmailPromotionsPreferences;
use Google::Adwords::CreditCard;
use Google::Adwords::Address;
use Data::Dumper;

sub test_class { return "Google::Adwords::AccountService"; }

# tests to run
my %tests = (
    getAccountInfo    => 1,
    getClientAccounts => 1,
    updateAccountInfo => 1,
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

    }
    else
    {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock(
            call => sub {
                my $xml .= <<'EOF';
  <getAccountInfoResponse xmlns="">
   <ns1:getAccountInfoReturn
xmlns:ns1="https://adwords.google.com/api/adwords/v6">
    <ns1:currencyCode>INR</ns1:currencyCode>
    <ns1:customerId>1133</ns1:customerId>
    <ns1:defaultAdsCoverage>
     <ns1:optInContentNetwork>true</ns1:optInContentNetwork>
     <ns1:optInSearchNetwork>true</ns1:optInSearchNetwork>
    </ns1:defaultAdsCoverage>
    <ns1:descriptiveName></ns1:descriptiveName>
    <ns1:emailPromotionsPreferences>
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
    <ns1:termsAndConditions>http://www.google.com/apis/adwords/terms.html</ns1:termsAndConditions>
    <ns1:timeZoneEffectiveDate>1158321517000</ns1:timeZoneEffectiveDate>
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
        ok( $account_info->customerId == 1133, 'getAccountInfo' );
        ok( $account_info->defaultAdsCoverage->optInSearchNetwork eq 'true',
            'getAccountInfo' );
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

        #my @emails = $self->{obj}->getClientAccounts();

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

        $account_info->billingAddress($billing_address);

        #my $ret = $self->{obj}->updateAccountInfo($account_info);

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

1;

