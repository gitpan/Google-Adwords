package AdGroupService;
use base qw/ Service /;

use Test::More;
use Test::MockModule;
use Google::Adwords::AdGroup;

sub test_class { return "Google::Adwords::AdGroupService"; }

sub addAdGroup : Test(no_plan)
{
    my $self = shift;

    #return;

    if ($self->{sandbox}) {
        $self->{obj}->debug(1);
        
        my $adgroup = Google::Adwords::AdGroup->new();
        $adgroup->maxCpc(100000);
        my $campaign_id = 4937;

        my $adgroup_response = $self->{obj}->addAdGroup($campaign_id, $adgroup);
        ok ($adgroup_response->campaignId == 4937, 'addAdGroup');
    }
    else {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">113</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">54d9ad57aa6d1fa29a253bf66b4717ce</requestId>
 </soapenv:Header>
 <soapenv:Body>
  <addAdGroupResponse xmlns="">
   <ns1:addAdGroupReturn
xmlns:ns1="https://adwords.google.com/api/adwords/v5">
    <ns1:campaignId>4937</ns1:campaignId>
    <ns1:id>200507</ns1:id>
    <ns1:maxCpc>100000</ns1:maxCpc>
    <ns1:name>Ad Group #1</ns1:name>
    <ns1:status>Enabled</ns1:status>
   </ns1:addAdGroupReturn>
  </addAdGroupResponse>
 </soapenv:Body>
</soapenv:Envelope>
EOF

            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $adgroup = Google::Adwords::AdGroup->new();
        $adgroup->maxCpc(100000);
        my $campaign_id = 4937;

        my $adgroup_response = $self->{obj}->addAdGroup($campaign_id, $adgroup);
        ok ($adgroup_response->campaignId == 4937, 'addAdGroup');
        
        # check that we got the response headers
        ok ($self->{obj}->requestId eq '54d9ad57aa6d1fa29a253bf66b4717ce',
                'Response header');
        ok ($self->{obj}->responseTime == 113, 'Response header');
        ok ($self->{obj}->operations == 1, 'Response header');
        ok ($self->{obj}->units == 1, 'Response header');


    }

}

sub addAdGroupList : Test(no_plan)
{
    my $self = shift;

    #return;

    if ($self->{sandbox}) {
        
        $self->{obj}->debug(1);

        my $campaign_id = 1004;
        my @adgroups_to_add;

        my $adgroup1 = Google::Adwords::AdGroup->new;
        $adgroup1->maxCpc(300000);
        my $adgroup2 = Google::Adwords::AdGroup->new;
        $adgroup2->maxCpc(400000);

        push @adgroups_to_add, $adgroup1, $adgroup2;

        my @new_adgroups = $self->{obj}->addAdGroupList(
            $campaign_id, \@adgroups_to_add
        );

        ok ($new_adgroups[0]->campaignId == 4937, 'addAdGroupList');
        ok ($new_adgroups[1]->campaignId == 4937, 'addAdGroupList');
    }
    else {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">113</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">54d9ad57aa6d1fa29a253bf66b4717ce</requestId>
 </soapenv:Header>
 <soapenv:Body>
   <addAdGroupListResponse xmlns="">
   <ns1:addAdGroupListReturn
xmlns:ns1="https://adwords.google.com/api/adwords/v5">
    <ns1:campaignId>4937</ns1:campaignId>
    <ns1:id>200531</ns1:id>
    <ns1:maxCpc>300000</ns1:maxCpc>
    <ns1:name>Ad Group #6</ns1:name>
    <ns1:status>Enabled</ns1:status>
   </ns1:addAdGroupListReturn>
   <ns2:addAdGroupListReturn
xmlns:ns2="https://adwords.google.com/api/adwords/v5">
    <ns2:campaignId>4937</ns2:campaignId>
    <ns2:id>200532</ns2:id>
    <ns2:maxCpc>400000</ns2:maxCpc>
    <ns2:name>Ad Group #7</ns2:name>
    <ns2:status>Enabled</ns2:status>
   </ns2:addAdGroupListReturn>
  </addAdGroupListResponse>
 </soapenv:Body>
</soapenv:Envelope>
EOF

            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $campaign_id = 4937;
        my @adgroups_to_add;

        my $adgroup1 = Google::Adwords::AdGroup->new;
        $adgroup1->maxCpc(300000);
        my $adgroup2 = Google::Adwords::AdGroup->new;
        $adgroup2->maxCpc(400000);

        push @adgroups_to_add, $adgroup1, $adgroup2;

        my @new_adgroups = $self->{obj}->addAdGroupList(
            $campaign_id, \@adgroups_to_add
        );

        ok ($new_adgroups[0]->campaignId == 4937, 'addAdGroupList');
        ok ($new_adgroups[1]->campaignId == 4937, 'addAdGroupList');
        

    }



}

sub getAdGroup : Test(no_plan)
{
    my $self = shift;

    #return;

    if ($self->{sandbox}) {
        $self->{obj}->debug(1);
        
        my $adgroup = $self->{obj}->getAdGroup(200531);

        ok ($adgroup->campaignId == 4937, 'getAdGroup');
        ok ($adgroup->id == 200531, 'getAdGroup');
    }
    else {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">113</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">54d9ad57aa6d1fa29a253bf66b4717ce</requestId>
 </soapenv:Header>
 <soapenv:Body>
  <getAdGroupResponse xmlns="">
   <ns1:getAdGroupReturn
xmlns:ns1="https://adwords.google.com/api/adwords/v5">
    <ns1:campaignId>4937</ns1:campaignId>
    <ns1:id>200507</ns1:id>
    <ns1:maxCpc>100000</ns1:maxCpc>
    <ns1:name>Ad Group #1</ns1:name>
    <ns1:status>Enabled</ns1:status>
   </ns1:getAdGroupReturn>
  </getAdGroupResponse>
 </soapenv:Body>
</soapenv:Envelope>
EOF

            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $adgroup= $self->{obj}->getAdGroup(200507);

        ok ($adgroup->campaignId == 4937, 'getAdGroup');
        ok ($adgroup->id == 200507, 'getAdGroup');
        

    }

}

sub getAdGroupList : Test(no_plan)
{
    my $self = shift;

    #return;

    if ($self->{sandbox}) {
        $self->{obj}->debug(1);
        
        my @adgroups = $self->{obj}->getAdGroupList(qw/200531 200532/);
        
        ok ($adgroups[0]->id == 200531, 'getAdGroupList');
        ok ($adgroups[1]->id == 200532, 'getAdGroupList');
    }
    else {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">113</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">54d9ad57aa6d1fa29a253bf66b4717ce</requestId>
 </soapenv:Header>
 <soapenv:Body>
  <getAdGroupListResponse xmlns="">
   <ns1:getAdGroupListReturn
xmlns:ns1="https://adwords.google.com/api/adwords/v5">
    <ns1:campaignId>4937</ns1:campaignId>
    <ns1:id>200507</ns1:id>
    <ns1:maxCpc>100000</ns1:maxCpc>
    <ns1:name>Ad Group #1</ns1:name>
    <ns1:status>Enabled</ns1:status>
   </ns1:getAdGroupListReturn>
   <ns1:getAdGroupListReturn
xmlns:ns1="https://adwords.google.com/api/adwords/v5">
    <ns1:campaignId>4937</ns1:campaignId>
    <ns1:id>200508</ns1:id>
    <ns1:maxCpc>100000</ns1:maxCpc>
    <ns1:name>Ad Group #1</ns1:name>
    <ns1:status>Enabled</ns1:status>
   </ns1:getAdGroupListReturn>
  </getAdGroupListResponse>
 </soapenv:Body>
</soapenv:Envelope>
EOF

            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my @adgroups = $self->{obj}->getAdGroupList(qw/200507 200508/);

        ok ($adgroups[0]->id == 200507, 'getAdGroupList');
        ok ($adgroups[1]->id == 200508, 'getAdGroupList');
        

    }

}

sub getAllAdGroups : Test(no_plan)
{
    my $self = shift;

    #return;

    if ($self->{sandbox}) {
        $self->{obj}->debug(1);
        
        my @adgroups = $self->{obj}->getAllAdGroups(4937);
        
        ok ($adgroups[0]->campaignId == 4937, 'getAllAdGroups');

    }
    else {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">113</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">54d9ad57aa6d1fa29a253bf66b4717ce</requestId>
 </soapenv:Header>
 <soapenv:Body>
  <getAllAdGroupsResponse xmlns="">
   <ns1:getAllAdGroupsReturn
xmlns:ns1="https://adwords.google.com/api/adwords/v5">
    <ns1:campaignId>4937</ns1:campaignId>
    <ns1:id>200507</ns1:id>
    <ns1:maxCpc>100000</ns1:maxCpc>
    <ns1:name>Ad Group #1</ns1:name>
    <ns1:status>Enabled</ns1:status>
   </ns1:getAllAdGroupsReturn>
   <ns1:getAllAdGroupsReturn
xmlns:ns1="https://adwords.google.com/api/adwords/v5">
    <ns1:campaignId>4937</ns1:campaignId>
    <ns1:id>200507</ns1:id>
    <ns1:maxCpc>100000</ns1:maxCpc>
    <ns1:name>Ad Group #1</ns1:name>
    <ns1:status>Enabled</ns1:status>
   </ns1:getAllAdGroupsReturn>
  </getAllAdGroupsResponse>
 </soapenv:Body>
</soapenv:Envelope>
EOF

            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my @adgroups = $self->{obj}->getAllAdGroups(4937);

        ok ($adgroups[0]->id == 200507, 'getAllAdGroups');
        

    }

}

sub getAdGroupStats : Test(no_plan)
{
    my $self = shift;

    #return;

    if ($self->{sandbox}) {

        $self->{obj}->debug(1);

        my $campaign_id = 1004;

        my @stats = $self->{obj}->getAdGroupStats({
            campaignId => $campaign_id,
            adGroupIds => [ 1001, 1002 ],
            startDay => '2006-09-01',
            endDay => '2006-09-15',
            inPST => 1,
        });

        ok ($stats[0]->id == 1001, 'getAdGroupStats');
        ok ($stats[1]->id == 1002, 'getAdGroupStats');

    }
    else {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">113</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">54d9ad57aa6d1fa29a253bf66b4717ce</requestId>
 </soapenv:Header>
 <soapenv:Body>
<getAdGroupStatsResponse xmlns="">
   <ns1:getAdGroupStatsReturn
xmlns:ns1="https://adwords.google.com/api/adwords/v5">
    <ns1:averagePosition>0.0</ns1:averagePosition>
    <ns1:clicks>10</ns1:clicks>
    <ns1:conversionRate>0.0</ns1:conversionRate>
    <ns1:conversions>0</ns1:conversions>
    <ns1:cost>0</ns1:cost>
    <ns1:id>1001</ns1:id>
    <ns1:impressions>0</ns1:impressions>
   </ns1:getAdGroupStatsReturn>
   <ns2:getAdGroupStatsReturn
xmlns:ns2="https://adwords.google.com/api/adwords/v5">
    <ns2:averagePosition>0.0</ns2:averagePosition>
    <ns2:clicks>0</ns2:clicks>
    <ns2:conversionRate>0.0</ns2:conversionRate>
    <ns2:conversions>0</ns2:conversions>
    <ns2:cost>0</ns2:cost>
    <ns2:id>1002</ns2:id>
    <ns2:impressions>0</ns2:impressions>
   </ns2:getAdGroupStatsReturn>
  </getAdGroupStatsResponse>
 </soapenv:Body>
</soapenv:Envelope>
EOF

            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $campaign_id = 1004;

        my @stats = $self->{obj}->getAdGroupStats({
            campaignId => $campaign_id,
            adGroupIds => [ 1001, 1002 ],
            startDay => '2006-09-01',
            endDay => '2006-09-15',
            inPST => 1,
        });

        ok ($stats[0]->id == 1001, 'getAdGroupStats');
        ok ($stats[0]->clicks == 10, 'getAdGroupStats');
        ok ($stats[1]->id == 1002, 'getAdGroupStats');
        

    }


}


sub updateAdGroup : Test(no_plan)
{
    my $self = shift;

    #return;

    if ($self->{sandbox}) {

        $self->{obj}->debug(1);

        my $adgroup = Google::Adwords::AdGroup->new;
        $adgroup->id(1001);
        $adgroup->maxCpc(5000000);

        my $ret = $self->{obj}->updateAdGroup($adgroup);

        ok ($ret == 1, 'updateAdGroup');


    }
    else {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">113</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">54d9ad57aa6d1fa29a253bf66b4717ce</requestId>
 </soapenv:Header>
 <soapenv:Body>
    <updateAdGroupResponse xmlns=""/>
 </soapenv:Body>
</soapenv:Envelope>
EOF

            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $adgroup = Google::Adwords::AdGroup->new;
        $adgroup->id(1001);
        $adgroup->maxCpc(5000000);

        my $ret = $self->{obj}->updateAdGroup($adgroup);

        ok ($ret == 1, 'updateAdGroup');

    }

}

sub updateAdGroupList : Test(no_plan)
{
    my $self = shift;

    #return;

    if ($self->{sandbox}) {

        $self->{obj}->debug(1);

        my $adgroup1 = Google::Adwords::AdGroup->new;
        $adgroup1->id(1001);
        $adgroup1->maxCpc(5000000);
        my $adgroup2 = Google::Adwords::AdGroup->new;
        $adgroup2->id(1002);
        $adgroup2->maxCpc(5000000);

        my @adgroups;
        push @adgroups, $adgroup1, $adgroup2;

        my $ret = $self->{obj}->updateAdGroupList(@adgroups);

        ok ($ret == 1, 'updateAdGroupList');


    }
    else {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">113</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next"
soapenv:mustUnderstand="0"
xmlns="https://adwords.google.com/api/adwords/v5">54d9ad57aa6d1fa29a253bf66b4717ce</requestId>
 </soapenv:Header>
 <soapenv:Body>
    <updateAdGroupListResponse xmlns=""/>
 </soapenv:Body>
</soapenv:Envelope>
EOF

            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $adgroup1 = Google::Adwords::AdGroup->new;
        $adgroup1->id(1001);
        $adgroup1->maxCpc(5000000);
        my $adgroup2 = Google::Adwords::AdGroup->new;
        $adgroup2->id(1002);
        $adgroup2->maxCpc(5000000);

        my @adgroups;
        push @adgroups, $adgroup1, $adgroup2;

        my $ret = $self->{obj}->updateAdGroupList(@adgroups);

        ok ($ret == 1, 'updateAdGroupList');


    }

}

1;

