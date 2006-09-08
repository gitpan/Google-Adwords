package CampaignService;
use base qw/ Service /;

use Test::More;
use Test::MockModule;
use Google::Adwords::Campaign;

sub test_class { return "Google::Adwords::CampaignService"; }

sub add_campaign_default : Test(no_plan)
{
    my $self = shift;

    #return;

    my $campaign = Google::Adwords::Campaign->new();

    #$campaign->name('Rohan Campaign');
    $campaign->dailyBudget(100000);
    #$campaign->language_targeting({
    #    languages => [ 'en', 'es' ],
    #});
    #$campaign->geo_targeting({
    #    countries => [ 'US', 'IN' ],
    #    #metros => [ 600, 606 ],
    #});
    #$campaign->network_targeting({
    #    network_types => [ 'GoogleSearch' ],
    #});

    if ($self->{'sandbox'}) {
        $self->{obj}->debug(0);
        my $camp = $self->{'obj'}->addCampaign($campaign);
        ok ($camp->dailyBudget == 100000, 'campaign dailyBudget');
        ok ($camp->id =~ /\d+/, 'campaign id');
        ok ($camp->status eq 'Active', 'campaign status');
        
        # save campaign id
        $self->{_campaign_id} = $camp->id;
    }

    else {

    my $soap = Test::MockModule->new('SOAP::Lite');
    $soap->mock( call => sub {
        my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">39</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">f7912565442e4adeb1bf30cbbf2f8fd2</requestId>
 </soapenv:Header>
 <soapenv:Body>
<addCampaignResponse xmlns="">
   <ns1:addCampaignReturn xmlns:ns1="https://adwords.google.com/api/adwords/v4">
    <ns1:dailyBudget>100000</ns1:dailyBudget>
    <ns1:enableSeparateContentBids>false</ns1:enableSeparateContentBids>
    <ns1:endDay>2011-01-01-05:00</ns1:endDay>
    <ns1:geoTargeting xsi:nil="true"/>
    <ns1:id>3987</ns1:id>
    <ns1:languageTargeting xsi:nil="true"/>
    <ns1:name>Campaign #1</ns1:name>
    <ns1:networkTargeting>
     <ns1:networkTypes>SearchNetwork</ns1:networkTypes>
     <ns1:networkTypes>ContentNetwork</ns1:networkTypes>
    </ns1:networkTargeting>
    <ns1:startDay>2006-08-20-04:00</ns1:startDay>
    <ns1:status>Active</ns1:status>
   </ns1:addCampaignReturn>
  </addCampaignResponse>
 </soapenv:Body>
</soapenv:Envelope>
EOF

        my $env = SOAP::Deserializer->deserialize($xml);
        return $env;
    });

    my $campaign_obj = $self->{'obj'}->addCampaign($campaign);
    ok ($campaign_obj->id == 3987, 'campaign id');
    ok ($campaign_obj->name eq 'Campaign #1' , 'campaign name');
    ok ($campaign_obj->enableSeparateContentBids eq 'false', 'enableSeparateContentBids');
    ok ($campaign_obj->dailyBudget == 100000, 'dailyBudget');


    }

}


sub getAllAdWordsCampaigns : Test(no_plan)
{
    my $self = shift;

    #return;

    if ($self->{sandbox}) {
        $self->{'obj'}->debug(0);
        my @campaigns = $self->{'obj'}->getAllAdWordsCampaigns();

        # just check that we got back at least one campaign
        my $campaign = shift @campaigns;
        ok ($campaign->id =~ /\d+/, 'getAllAdWordsCampaigns');
    }
    else {

    my $soap = Test::MockModule->new('SOAP::Lite');
    $soap->mock( call => sub {
        my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">39</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">f7912565442e4adeb1bf30cbbf2f8fd2</requestId>
 </soapenv:Header>
 <soapenv:Body>
<getAllAdWordsCampaignsResponse xmlns="">
   <ns1:getAllAdWordsCampaignsReturn xmlns:ns1="https://adwords.google.com/api/adwords/v4">
    <ns1:dailyBudget>100000</ns1:dailyBudget>
    <ns1:enableSeparateContentBids>false</ns1:enableSeparateContentBids>
    <ns1:endDay>2011-01-01-05:00</ns1:endDay>
    <ns1:geoTargeting xsi:nil="true"/>
    <ns1:id>3987</ns1:id>
    <ns1:languageTargeting xsi:nil="true"/>
    <ns1:name>Campaign #1</ns1:name>
    <ns1:networkTargeting>
     <ns1:networkTypes>SearchNetwork</ns1:networkTypes>
     <ns1:networkTypes>ContentNetwork</ns1:networkTypes>
    </ns1:networkTargeting>
    <ns1:startDay>2006-08-20-04:00</ns1:startDay>
    <ns1:status>Active</ns1:status>
   </ns1:getAllAdWordsCampaignsReturn>
   <ns1:getAllAdWordsCampaignsReturn xmlns:ns1="https://adwords.google.com/api/adwords/v4">
    <ns1:dailyBudget>100000</ns1:dailyBudget>
    <ns1:enableSeparateContentBids>false</ns1:enableSeparateContentBids>
    <ns1:endDay>2011-01-01-05:00</ns1:endDay>
    <ns1:geoTargeting xsi:nil="true"/>
    <ns1:id>3988</ns1:id>
    <ns1:languageTargeting xsi:nil="true"/>
    <ns1:name>Campaign #1</ns1:name>
    <ns1:networkTargeting>
     <ns1:networkTypes>SearchNetwork</ns1:networkTypes>
     <ns1:networkTypes>ContentNetwork</ns1:networkTypes>
    </ns1:networkTargeting>
    <ns1:startDay>2006-08-20-04:00</ns1:startDay>
    <ns1:status>Active</ns1:status>
   </ns1:getAllAdWordsCampaignsReturn>
  </getAllAdWordsCampaignsResponse>
 </soapenv:Body>
</soapenv:Envelope>
EOF

        my $env = SOAP::Deserializer->deserialize($xml);
        return $env;
    });

    my @campaigns = $self->{obj}->getAllAdWordsCampaigns();
    ok (scalar @campaigns == 2, 'getAllAdWordsCampaigns');
    
    my $campaign = shift @campaigns;
    ok ($campaign->id == 3987, 'first campaign is ok');

    }

}

sub getCampaign : Test(no_plan)
{
    my $self = shift;

    #return;

    if ($self->{sandbox}) {
        $self->{obj}->debug(0);
        my $campaign = $self->{obj}->getCampaign($self->{_campaign_id});
        ok ($campaign->id == $self->{_campaign_id}, 'getCampaign');
    }

    else {

    my $soap = Test::MockModule->new('SOAP::Lite');
    $soap->mock( call => sub {
        my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">39</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">f7912565442e4adeb1bf30cbbf2f8fd2</requestId>
 </soapenv:Header>
 <soapenv:Body>
<getCampaignResponse xmlns="">
   <ns1:getCampaignReturn xmlns:ns1="https://adwords.google.com/api/adwords/v4">
    <ns1:dailyBudget>100000</ns1:dailyBudget>
    <ns1:enableSeparateContentBids>false</ns1:enableSeparateContentBids>
    <ns1:endDay>2011-01-01-05:00</ns1:endDay>
    <ns1:geoTargeting xsi:nil="true"/>
    <ns1:id>3987</ns1:id>
    <ns1:languageTargeting xsi:nil="true"/>
    <ns1:name>Campaign #1</ns1:name>
    <ns1:networkTargeting>
     <ns1:networkTypes>SearchNetwork</ns1:networkTypes>
     <ns1:networkTypes>ContentNetwork</ns1:networkTypes>
    </ns1:networkTargeting>
    <ns1:startDay>2006-08-20-04:00</ns1:startDay>
    <ns1:status>Active</ns1:status>
   </ns1:getCampaignReturn>
  </getCampaignResponse>
 </soapenv:Body>
</soapenv:Envelope>
EOF

        my $env = SOAP::Deserializer->deserialize($xml);
        return $env;
    });

    my $campaign = $self->{obj}->getCampaign(3987);
    ok ($campaign->id == 3987, 'getCampaign');

    }

}

sub f_setOptimizeAdServing : Test(no_plan)
{
    my $self = shift;

    #return;

    if ($self->{sandbox}) {

        $self->{obj}->debug(0);
        my $ret = $self->{obj}->setOptimizeAdServing($self->{_campaign_id}, 1);
        #my $ret = $self->{obj}->setOptimizeAdServing(3987, 1);
        ok ($ret == 1, 'setOptimizeAdServing');

    }
    else {

    my $soap = Test::MockModule->new('SOAP::Lite');
    $soap->mock( call => sub {
        my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">39</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">f7912565442e4adeb1bf30cbbf2f8fd2</requestId>
 </soapenv:Header>
 <soapenv:Body>
<setOptimizeAdServingResponse xmlns="">
   <ns1:setOptimizeAdServingReturn xmlns:ns1="https://adwords.google.com/api/adwords/v4">true</ns1:setOptimizeAdServingReturn>
  </setOptimizeAdServingResponse>
 </soapenv:Body>
</soapenv:Envelope>
EOF

        my $env = SOAP::Deserializer->deserialize($xml);
        return $env;
    });

    my $ret = $self->{obj}->setOptimizeAdServing(3987, 1);
    ok ($ret == 1, 'setOptimizeAdServing');

    }

}

sub getOptimizeAdServing : Test(no_plan)
{
    my $self = shift;

    #return;

    if ($self->{sandbox}) {

        $self->{obj}->debug(0);
        my $ret = $self->{obj}->getOptimizeAdServing($self->{_campaign_id});
        #my $ret = $self->{obj}->getOptimizeAdServing(3987);
        ok ($ret == 1, 'getOptimizeAdServing');

    }
    else {

    my $soap = Test::MockModule->new('SOAP::Lite');
    $soap->mock( call => sub {
        my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">39</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">f7912565442e4adeb1bf30cbbf2f8fd2</requestId>
 </soapenv:Header>
 <soapenv:Body>
<getOptimizeAdServingResponse xmlns="">
   <ns1:getOptimizeAdServingReturn xmlns:ns1="https://adwords.google.com/api/adwords/v4">true</ns1:getOptimizeAdServingReturn>
  </getOptimizeAdServingResponse>
 </soapenv:Body>
</soapenv:Envelope>
EOF

        my $env = SOAP::Deserializer->deserialize($xml);
        return $env;
    });

    my $ret = $self->{obj}->getOptimizeAdServing(3987);
    ok ($ret == 1, 'getOptimizeAdServing');

    }

}

sub addCampaignList : Test(no_plan)
{
    my $self = shift;

    #return;

    if ($self->{sandbox}) {
        $self->{obj}->debug(0);
        
        my @campaigns;
        my $campaign1 = Google::Adwords::Campaign->new();
        $campaign1->dailyBudget(100000);
        my $campaign2 = Google::Adwords::Campaign->new();
        $campaign2->dailyBudget(200000);

        push @campaigns, $campaign1, $campaign2;

        my @responses = $self->{obj}->addCampaignList(@campaigns);
        
        # check first campaign
        ok ($responses[0]->dailyBudget == 100000, 'addCampaignList');
        ok ($responses[1]->dailyBudget == 200000, 'addCampaignList');

        # save campaign ids for use in getCampaignList
        $self->{_campaign_id_0} = $responses[0]->id;
        $self->{_campaign_id_1} = $responses[1]->id;

    }
    else {

    my $soap = Test::MockModule->new('SOAP::Lite');
    $soap->mock( call => sub {
        my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">39</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">f7912565442e4adeb1bf30cbbf2f8fd2</requestId>
 </soapenv:Header>
 <soapenv:Body>
<addCampaignListResponse xmlns="">
   <ns1:addCampaignListReturn xmlns:ns1="https://adwords.google.com/api/adwords/v4">
    <ns1:dailyBudget>100000</ns1:dailyBudget>
    <ns1:enableSeparateContentBids>false</ns1:enableSeparateContentBids>
    <ns1:endDay>2011-01-01-05:00</ns1:endDay>
    <ns1:geoTargeting xsi:nil="true"/>
    <ns1:id>3987</ns1:id>
    <ns1:languageTargeting xsi:nil="true"/>
    <ns1:name>Campaign #1</ns1:name>
    <ns1:networkTargeting>
     <ns1:networkTypes>SearchNetwork</ns1:networkTypes>
     <ns1:networkTypes>ContentNetwork</ns1:networkTypes>
    </ns1:networkTargeting>
    <ns1:startDay>2006-08-20-04:00</ns1:startDay>
    <ns1:status>Active</ns1:status>
   </ns1:addCampaignListReturn>
   <ns1:addCampaignListReturn xmlns:ns1="https://adwords.google.com/api/adwords/v4">
    <ns1:dailyBudget>200000</ns1:dailyBudget>
    <ns1:enableSeparateContentBids>false</ns1:enableSeparateContentBids>
    <ns1:endDay>2011-01-01-05:00</ns1:endDay>
    <ns1:geoTargeting xsi:nil="true"/>
    <ns1:id>3988</ns1:id>
    <ns1:languageTargeting xsi:nil="true"/>
    <ns1:name>Campaign #1</ns1:name>
    <ns1:networkTargeting>
     <ns1:networkTypes>SearchNetwork</ns1:networkTypes>
     <ns1:networkTypes>ContentNetwork</ns1:networkTypes>
    </ns1:networkTargeting>
    <ns1:startDay>2006-08-20-04:00</ns1:startDay>
    <ns1:status>Active</ns1:status>
   </ns1:addCampaignListReturn>
  </addCampaignListResponse>
 </soapenv:Body>
</soapenv:Envelope>
EOF

        my $env = SOAP::Deserializer->deserialize($xml);
        return $env;
    });

        my @campaigns;
        my $campaign1 = Google::Adwords::Campaign->new();
        $campaign1->dailyBudget(100000);
        my $campaign2 = Google::Adwords::Campaign->new();
        $campaign2->dailyBudget(200000);

        push @campaigns, $campaign1, $campaign2;

        my @responses = $self->{obj}->addCampaignList(@campaigns);
        
        # check first campaign
        ok ($responses[0]->dailyBudget == 100000, 'addCampaignList');
        ok ($responses[1]->dailyBudget == 200000, 'addCampaignList');



    }


}

sub getCampaignList : Test(no_plan)
{
    my $self = shift;

    #return;

    if ($self->{sandbox}) {

        #$self->{obj}->debug(0);
        my @campaigns = $self->{obj}->getCampaignList([
            $self->{_campaign_id_0},
            $self->{_campaign_id_1},
        ]);

        ok ($campaigns[0]->id == $self->{_campaign_id_0}, 'getCampaignList');
        ok ($campaigns[1]->id == $self->{_campaign_id_1}, 'getCampaignList');

    }
    else {

    my $soap = Test::MockModule->new('SOAP::Lite');
    $soap->mock( call => sub {
        my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">39</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">f7912565442e4adeb1bf30cbbf2f8fd2</requestId>
 </soapenv:Header>
 <soapenv:Body>
<getCampaignListResponse xmlns="">
   <ns1:getCampaignListReturn xmlns:ns1="https://adwords.google.com/api/adwords/v4">
    <ns1:dailyBudget>100000</ns1:dailyBudget>
    <ns1:enableSeparateContentBids>false</ns1:enableSeparateContentBids>
    <ns1:endDay>2011-01-01-05:00</ns1:endDay>
    <ns1:geoTargeting xsi:nil="true"/>
    <ns1:id>3987</ns1:id>
    <ns1:languageTargeting xsi:nil="true"/>
    <ns1:name>Campaign #1</ns1:name>
    <ns1:networkTargeting>
     <ns1:networkTypes>SearchNetwork</ns1:networkTypes>
     <ns1:networkTypes>ContentNetwork</ns1:networkTypes>
    </ns1:networkTargeting>
    <ns1:startDay>2006-08-20-04:00</ns1:startDay>
    <ns1:status>Active</ns1:status>
   </ns1:getCampaignListReturn>
   <ns1:getCampaignListReturn xmlns:ns1="https://adwords.google.com/api/adwords/v4">
    <ns1:dailyBudget>200000</ns1:dailyBudget>
    <ns1:enableSeparateContentBids>false</ns1:enableSeparateContentBids>
    <ns1:endDay>2011-01-01-05:00</ns1:endDay>
    <ns1:geoTargeting xsi:nil="true"/>
    <ns1:id>3988</ns1:id>
    <ns1:languageTargeting xsi:nil="true"/>
    <ns1:name>Campaign #1</ns1:name>
    <ns1:networkTargeting>
     <ns1:networkTypes>SearchNetwork</ns1:networkTypes>
     <ns1:networkTypes>ContentNetwork</ns1:networkTypes>
    </ns1:networkTargeting>
    <ns1:startDay>2006-08-20-04:00</ns1:startDay>
    <ns1:status>Active</ns1:status>
   </ns1:getCampaignListReturn>
  </getCampaignListResponse>
 </soapenv:Body>
</soapenv:Envelope>
EOF

        my $env = SOAP::Deserializer->deserialize($xml);
        return $env;
    });

        my @campaigns = $self->{obj}->getCampaignList([
            3987,
            3988,
        ]);

        ok ($campaigns[0]->id == 3987, 'getCampaignList');
        ok ($campaigns[1]->id == 3988, 'getCampaignList');

    }


}

sub updateCampaign : Test(no_plan)
{
    my $self = shift;

    #return;

    if ($self->{sandbox}) {

        $self->{obj}->debug(0);
        
        my $campaign = Google::Adwords::Campaign->new();
        $campaign->id($self->{_campaign_id});
        $campaign->dailyBudget(500000);

        my $ret = $self->{obj}->updateCampaign($campaign);
        ok ($ret == 1, 'updateCampaign');


    }
    else {

    my $soap = Test::MockModule->new('SOAP::Lite');
    $soap->mock( call => sub {
        my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">39</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">f7912565442e4adeb1bf30cbbf2f8fd2</requestId>
 </soapenv:Header>
 <soapenv:Body>
<updateCampaignResponse xmlns="" />
 </soapenv:Body>
</soapenv:Envelope>
EOF

        my $env = SOAP::Deserializer->deserialize($xml);
        return $env;
    });

        my $campaign = Google::Adwords::Campaign->new();
        $campaign->id(5555);
        $campaign->dailyBudget(500000);

        my $ret = $self->{obj}->updateCampaign($campaign);
        ok ($ret == 1, 'updateCampaign');


    }



}

sub updateCampaignList : Test(no_plan)
{
    my $self = shift;

    #return;

    if ($self->{sandbox}) {

        $self->{obj}->debug(0);

        my @campaigns;

        my $campaign0 = Google::Adwords::Campaign->new();
        $campaign0->id($self->{_campaign_id_0});
        $campaign0->dailyBudget(2000000);
    
        my $campaign1 = Google::Adwords::Campaign->new();
        $campaign1->id($self->{_campaign_id_1});
        $campaign1->dailyBudget(2000);

        push @campaigns, $campaign0, $campaign1;

        my $ret = $self->{obj}->updateCampaignList(@campaigns);
        ok ($ret == 1, 'updateCampaignList');


    }
    else {

    my $soap = Test::MockModule->new('SOAP::Lite');
    $soap->mock( call => sub {
        my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">39</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">f7912565442e4adeb1bf30cbbf2f8fd2</requestId>
 </soapenv:Header>
 <soapenv:Body>
<updateCampaignListResponse xmlns="" />
 </soapenv:Body>
</soapenv:Envelope>
EOF

        my $env = SOAP::Deserializer->deserialize($xml);
        return $env;
    });

        my @campaigns;

        my $campaign0 = Google::Adwords::Campaign->new();
        $campaign0->id(7819);
        $campaign0->dailyBudget(2000000);
    
        my $campaign1 = Google::Adwords::Campaign->new();
        $campaign1->id(18982);
        $campaign1->dailyBudget(200);

        push @campaigns, $campaign0, $campaign1;

        my $ret = $self->{obj}->updateCampaignList(@campaigns);
        ok ($ret == 1, 'updateCampaignList');

    }


}

sub getCampaignStats : Test(no_plan)
{
    my $self = shift;

    #return;

    if ($self->{sandbox}) {
        
        $self->{obj}->debug(0);

        my @stats = $self->{obj}->getCampaignStats({
            campaignids => [ $self->{_campaign_id_0}, $self->{_campaign_id_1} ],
            startDay => '2006-08-01',
            endDay => '2006-08-31',
            inPST => 1,
        });

        ok ($stats[0]->id == $self->{_campaign_id_0}, 'getCampaignStats');
        ok ($stats[0]->clicks == 0, 'getCampaignStats');
        ok ($stats[1]->id == $self->{_campaign_id_1}, 'getCampaignStats');

    }
    else {

    my $soap = Test::MockModule->new('SOAP::Lite');
    $soap->mock( call => sub {
        my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">39</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v4">f7912565442e4adeb1bf30cbbf2f8fd2</requestId>
 </soapenv:Header>
 <soapenv:Body>
<getCampaignStatsResponse xmlns="">
   <ns1:getCampaignStatsReturn
xmlns:ns1="https://adwords.google.com/api/adwords/v5">
    <ns1:averagePosition>0.0</ns1:averagePosition>
    <ns1:clicks>0</ns1:clicks>
    <ns1:conversionRate>0.0</ns1:conversionRate>
    <ns1:conversions>0</ns1:conversions>
    <ns1:cost>0</ns1:cost>
    <ns1:id>4865</ns1:id>
    <ns1:impressions>0</ns1:impressions>
   </ns1:getCampaignStatsReturn>
   <ns2:getCampaignStatsReturn
xmlns:ns2="https://adwords.google.com/api/adwords/v5">
    <ns2:averagePosition>0.0</ns2:averagePosition>
    <ns2:clicks>0</ns2:clicks>
    <ns2:conversionRate>0.0</ns2:conversionRate>
    <ns2:conversions>0</ns2:conversions>
    <ns2:cost>0</ns2:cost>
    <ns2:id>4866</ns2:id>
    <ns2:impressions>0</ns2:impressions>
   </ns2:getCampaignStatsReturn>
  </getCampaignStatsResponse>
 </soapenv:Body>
</soapenv:Envelope>
EOF

        my $env = SOAP::Deserializer->deserialize($xml);
        return $env;
    });

        my @stats = $self->{obj}->getCampaignStats({
            campaignids => [ 4865, 4866 ],
            startDay => '2006-08-01',
            endDay => '2006-08-31',
            inPST => 1,
        });

        ok ($stats[0]->id == 4865, 'getCampaignStats');
        ok ($stats[0]->clicks == 0, 'getCampaignStats');
        ok ($stats[1]->id == 4866, 'getCampaignStats');


    }




}


1;


