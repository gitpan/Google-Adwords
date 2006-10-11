package AccountService;
use base qw/ Service /;

use Test::More;
use Test::MockModule;

use Google::Adwords::EmailPromotionsPreferences;
use Google::Adwords::CreditCard;
use Google::Adwords::Address;
use Data::Dumper;

sub test_class { return "Google::Adwords::AccountService"; }

sub createAdWordsAccount : Test(no_plan)
{
    my ($self) = @_;

    #return;
    
    if ($self->{sandbox}) {

        $self->{obj}->debug(1);
            
        return;

    }

    else {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v6">39</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v6">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v6">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v6">f7912565442e4adeb1bf30cbbf2f8fd2</requestId>
 </soapenv:Header>
 <soapenv:Body>
  <createAdWordsAccountResponse xmlns="" />
 </soapenv:Body>
</soapenv:Envelope>
EOF

            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $emailprefs = Google::Adwords::EmailPromotionsPreferences->new;
        $emailprefs->marketResearchEnabled(1);
        $emailprefs->newsletterEnabled(1);
        $emailprefs->promotionsEnabled(0);

        my $cc = Google::Adwords::CreditCard->new;
        $cc->cardNumber('28181298487');
        $cc->cardType('VISA');
        $cc->expirationMonth('01');
        $cc->expirationYear('2008');
        
        my $contact_info = Google::Adwords::Address->new;
        $contact_info->addressLine1('Flat No. 101');
        $contact_info->city('Mumbai');
        $contact_info->countryCode('IN');


        my $ret = $self->{obj}->createAdWordsAccount({
            loginEmail => 'test@email.com',
            password => 'password',
            languagePreference => 'en',
            emailPrefs => $emailprefs,
            cardInfo => $cc,
            contactInfo => $contact_info,
        });

        
        ok ($ret == 1, 'createAdWordsAccount'); 
    }
    
}

sub getAccountInfo : Test(no_plan)
{
    my ($self) = @_;

    #return;

    if ($self->{sandbox}) {
        $self->{obj}->debug(1);
    
        my $account_info = $self->{obj}->getAccountInfo();

        ok ($account_info->primaryAddress->emailAddress 
                eq $self->{obj}->clientEmail, 'getAccountInfo');
        
    }
    else {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:xsd="http://www.w3.org/2001/XMLSchema
" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0" xmlns="https://ad
words.google.com/api/adwords/v6">55</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0" xmlns="https://adwo
rds.google.com/api/adwords/v6">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0" xmlns="https://adwords.g
oogle.com/api/adwords/v6">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0" xmlns="https://adwor
ds.google.com/api/adwords/v6">5d055e6ef65a48ae1ea590d3019a12c7</requestId>
 </soapenv:Header>
 <soapenv:Body>
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
 </soapenv:Body>
</soapenv:Envelope>
EOF

            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

    
        my $account_info = $self->{obj}->getAccountInfo();

        ok ($account_info->currencyCode eq 'INR', 'getAccountInfo'); 
        ok ($account_info->customerId == 1133, 'getAccountInfo');
        ok ($account_info->defaultAdsCoverage->optInSearchNetwork eq 'true',
                'getAccountInfo');
        ok ($account_info->emailPromotionsPreferences->newsletterEnabled 
                eq 'false', 'getAccountInfo');
        ok ($account_info->primaryAddress->emailAddress 
                eq 'client_1+rohan.almeida@gmail.com', 'getAccountInfo');

    }

}

sub getClientAccounts : Test(no_plan)
{
    my $self = shift;

    #return;

    if ($self->{sandbox}) {
        $self->{obj}->debug(1);
        
        my @emails = $self->{obj}->getClientAccounts();

        return; 
    }
    else {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:xsd="http://www.w3.org/2001/XMLSchema
" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0" xmlns="https://ad
words.google.com/api/adwords/v6">55</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0" xmlns="https://adwo
rds.google.com/api/adwords/v6">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0" xmlns="https://adwords.g
oogle.com/api/adwords/v6">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0" xmlns="https://adwor
ds.google.com/api/adwords/v6">5d055e6ef65a48ae1ea590d3019a12c7</requestId>
 </soapenv:Header>
 <soapenv:Body>
  <getClientAccountsResponse xmlns="" />
 </soapenv:Body>
</soapenv:Envelope>
EOF

            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

    
        my @emails = $self->{obj}->getClientAccounts;
        ok (scalar @emails == 0, 'getClientAccounts');

    }


}

sub getCreditCard : Test(no_plan)
{
    my $self = shift;

    #return;

    if ($self->{sandbox}) {
        $self->{obj}->debug(1);
        
        #my $cc_obj = $self->{obj}->getCreditCard;

        return;
    }
    else {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:xsd="http://www.w3.org/2001/XMLSchema
" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0" xmlns="https://ad
words.google.com/api/adwords/v6">55</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0" xmlns="https://adwo
rds.google.com/api/adwords/v6">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0" xmlns="https://adwords.g
oogle.com/api/adwords/v6">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0" xmlns="https://adwor
ds.google.com/api/adwords/v6">5d055e6ef65a48ae1ea590d3019a12c7</requestId>
 </soapenv:Header>
 <soapenv:Body>
  <getCreditCardResponse xmlns="">
    <getCreditCardReturn>
      <cardType>VISA</cardType>
      <expirationMonth>08</expirationMonth>
    </getCreditCardReturn>
  </getCreditCardResponse>
 </soapenv:Body>
</soapenv:Envelope>
EOF

            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $cc = $self->{obj}->getCreditCard;
        
        ok ($cc->cardType eq 'VISA', 'getCreditCard');
        ok ($cc->expirationMonth eq '08', 'getCreditCard');

    }
}


sub setCreditCard : Test(no_plan)
{
    my $self = shift;

    #return;

    if ($self->{sandbox}) {
        $self->{obj}->debug(1);
    
        my $cc = Google::Adwords::CreditCard->new;
        $cc->cardNumber('289918293789289');
        $cc->cardType('VISA');

        my $address = Google::Adwords::Address->new;
        $address->addressLine1('Flat No. 101');
        $address->addressLine2('Street');
        $address->city('Mumbai');
        $address->countryCode('IN');

        #my $ret = $self->{obj}->setCreditCard($cc, $address);

        return;

    }
    else {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:xsd="http://www.w3.org/2001/XMLSchema
" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0" xmlns="https://ad
words.google.com/api/adwords/v6">55</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0" xmlns="https://adwo
rds.google.com/api/adwords/v6">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0" xmlns="https://adwords.g
oogle.com/api/adwords/v6">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0" xmlns="https://adwor
ds.google.com/api/adwords/v6">5d055e6ef65a48ae1ea590d3019a12c7</requestId>
 </soapenv:Header>
 <soapenv:Body>
  <setCreditCardResponse xmlns="" />
 </soapenv:Body>
</soapenv:Envelope>
EOF

            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $cc = Google::Adwords::CreditCard->new;
        $cc->cardNumber('289918293789289');
        $cc->cardType('VISA');

        my $address = Google::Adwords::Address->new;
        $address->addressLine1('Flat No. 101');
        $address->addressLine2('Street');
        $address->city('Mumbai');
        $address->countryCode('IN');

        my $ret = $self->{obj}->setCreditCard($cc, $address);

        ok ($ret == 1, 'setCreditCard');

    }
}

sub setLocalTimezone : Test(no_plan)
{
    my $self = shift;

    #return;

    if ($self->{sandbox}) {
        $self->{obj}->debug(1);
    
        #my $ret = $self->{obj}->setLocalTimezone('Asia/Calcutta');

        return;

    }
    else {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:xsd="http://www.w3.org/2001/XMLSchema
" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0" xmlns="https://ad
words.google.com/api/adwords/v6">55</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0" xmlns="https://adwo
rds.google.com/api/adwords/v6">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0" xmlns="https://adwords.g
oogle.com/api/adwords/v6">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0" xmlns="https://adwor
ds.google.com/api/adwords/v6">5d055e6ef65a48ae1ea590d3019a12c7</requestId>
 </soapenv:Header>
 <soapenv:Body>
  <setLocalTimezoneResponse xmlns="" />
 </soapenv:Body>
</soapenv:Envelope>
EOF

            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $ret = $self->{obj}->setLocalTimezone('Asia/Calcutta');

        ok ($ret == 1, 'setLocalTimezone');

    }
}

sub setLoginInfo : Test(no_plan)
{
    my $self = shift;

    #return;

    if ($self->{sandbox}) {
        $self->{obj}->debug(1);
    
        #my $ret = $self->{obj}->setLoginInfo('user', 'newpass');

        return;

    }
    else {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:xsd="http://www.w3.org/2001/XMLSchema
" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0" xmlns="https://ad
words.google.com/api/adwords/v6">55</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0" xmlns="https://adwo
rds.google.com/api/adwords/v6">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0" xmlns="https://adwords.g
oogle.com/api/adwords/v6">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0" xmlns="https://adwor
ds.google.com/api/adwords/v6">5d055e6ef65a48ae1ea590d3019a12c7</requestId>
 </soapenv:Header>
 <soapenv:Body>
  <setLoginInfoResponse xmlns="" />
 </soapenv:Body>
</soapenv:Envelope>
EOF

            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $ret = $self->{obj}->setLoginInfo('login', 'newpass');

        ok ($ret == 1, 'setLoginInfo');

    }
}

sub updateAccountInfo : Test(no_plan)
{
    my $self = shift;

    #return;

    if ($self->{sandbox}) {
        $self->{obj}->debug(1);
    
        my $account_info = Google::Adwords::AccountInfo->new;

        my $billing_address = Google::Adwords::Address->new;
        $billing_address->addressLine1('Flat No');
        $billing_address->city('Mumbai');

        $account_info->billingAddress($billing_address);


        #my $ret = $self->{obj}->updateAccountInfo($account_info);
        
        return;

    }
    else {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:xsd="http://www.w3.org/2001/XMLSchema
" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0" xmlns="https://ad
words.google.com/api/adwords/v6">55</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0" xmlns="https://adwo
rds.google.com/api/adwords/v6">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0" xmlns="https://adwords.g
oogle.com/api/adwords/v6">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0" xmlns="https://adwor
ds.google.com/api/adwords/v6">5d055e6ef65a48ae1ea590d3019a12c7</requestId>
 </soapenv:Header>
 <soapenv:Body>
  <updateAccountInfoResponse xmlns="" />
 </soapenv:Body>
</soapenv:Envelope>
EOF

            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $account_info = Google::Adwords::AccountInfo->new;

        my $billing_address = Google::Adwords::Address->new;
        $billing_address->addressLine1('Flat No');
        $billing_address->city('Mumbai');

        $account_info->billingAddress($billing_address);

        my $ret = $self->{obj}->updateAccountInfo($account_info);
        
        ok ($ret == 1, 'updateAccountInfo');

    }
}


1;

