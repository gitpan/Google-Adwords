package CampaignService;
use base qw/ Service /;

use Test::More;
use Test::MockModule;
use Google::Adwords::Campaign;
use Google::Adwords::AdSchedule;
use Google::Adwords::SchedulingInterval;

use Data::Dumper;

sub test_class { return "Google::Adwords::CampaignService"; }

# tests to be run
my %tests = (
    addCampaign             => 1,
    addCampaign_schedule    => 1,
    addCampaignList         => 1,
    getAllAdWordsCampaigns  => 1,
    getCampaign             => 1,
    getCampaignList         => 1,
    getCampaignStats        => 1,
    getOptimizeAdServing    => 1,
    setOptimizeAdServing    => 1,
    updateCampaign          => 1,
    updateCampaignList      => 1,
);

sub start_of_each_test : Test(setup)
{
    my $self = shift;

    # set debug to whatever was passed in as param
    $self->{obj}->debug($self->{debug});
}

sub addCampaign : Test(no_plan)
{
    my $self = shift;

    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }

    my $campaign = Google::Adwords::Campaign->new();

    #$campaign->name('Rohan Campaign');
    $campaign->dailyBudget(100000);
    $campaign->languageTargeting({
        languages => 'en',
    });
    #$campaign->geo_targeting({
    #    countries => [ 'US', 'IN' ],
    #    #metros => [ 600, 606 ],
    #});
    #$campaign->network_targeting({
    #    network_types => [ 'GoogleSearch' ],
    #});

    if ($self->{'sandbox'}) {
        my $camp = $self->{'obj'}->addCampaign($campaign);
        ok ($camp->dailyBudget == 100000, 'addCampaign');
        ok ($camp->id =~ /\d+/, 'addCampaign - id: ' . $camp->id);
        
        # save campaign id
        $self->{_campaign_id} = $camp->id;

        # save it for other test modules
        $self->_set_campaign_id($camp->id);
    }

    else {

    my $soap = Test::MockModule->new('SOAP::Lite');
    $soap->mock( call => sub {
        my $xml .= <<'EOF';
<addCampaignResponse xmlns="">
   <ns1:addCampaignReturn xmlns:ns1="https://adwords.google.com/api/adwords/v4">
    <ns1:dailyBudget>100000</ns1:dailyBudget>
    <ns1:enableSeparateContentBids>false</ns1:enableSeparateContentBids>
    <ns1:endDay>2011-01-01-05:00</ns1:endDay>
    <ns1:geoTargeting xsi:nil="true"/>
    <ns1:id>3987</ns1:id>
    <ns1:languageTargeting>
      <ns1:languages>en</ns1:languages>
    </ns1:languageTargeting>
    <ns1:name>Campaign #1</ns1:name>
    <ns1:networkTargeting>
     <ns1:networkTypes>SearchNetwork</ns1:networkTypes>
     <ns1:networkTypes>ContentNetwork</ns1:networkTypes>
    </ns1:networkTargeting>
    <ns1:schedule>
      <ns1:status>Disabled</ns1:status>
    </ns1:schedule>
    <ns1:startDay>2006-08-20-04:00</ns1:startDay>
    <ns1:status>Active</ns1:status>
   </ns1:addCampaignReturn>
  </addCampaignResponse>
EOF

        $xml = $self->gen_full_response($xml);
        my $env = SOAP::Deserializer->deserialize($xml);
        return $env;
    });

    my $campaign_obj = $self->{'obj'}->addCampaign($campaign);
    ok ($campaign_obj->id == 3987, 'campaign id');
    ok ($campaign_obj->name eq 'Campaign #1' , 'campaign name');
    ok ($campaign_obj->enableSeparateContentBids eq 'false', 'enableSeparateContentBids');
    ok ($campaign_obj->dailyBudget == 100000, 'dailyBudget');

    my $lang_ref = $campaign_obj->languageTargeting;
    ok ($lang_ref->{languages}[0] eq 'en', 'languageTargeting');

    ok ($campaign_obj->schedule->status eq 'Disabled', 'ad schedule disabled');


    }

}

sub addCampaign_schedule: Test(no_plan)
{
    my $self = shift;

    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }

    my $campaign = Google::Adwords::Campaign->new();

    #$campaign->name('Rohan Campaign');
    $campaign->dailyBudget(100000);
    $campaign->languageTargeting({
        languages => 'en',
    });

    # ad schedule
    my $schedule1 = Google::Adwords::SchedulingInterval->new();
    $schedule1->day('Monday')
              ->startHour(1)
              ->endHour(10)
              ->multiplier(1)
    ;
    my @intervals = ( $schedule1 );
    my $ad_schedule = Google::Adwords::AdSchedule->new();
    $ad_schedule->status('Enabled');
    $ad_schedule->intervals(\@intervals);

    $campaign->schedule($ad_schedule);

    if ($self->{'sandbox'}) {
        my $camp = $self->{'obj'}->addCampaign($campaign);
        ok ($camp->dailyBudget == 100000, 'addCampaign');
        ok ($camp->id =~ /\d+/, 'addCampaign - id: ' . $camp->id);
        
        # save campaign id
        $self->{_campaign_id} = $camp->id;

        # save it for other test modules
        $self->_set_campaign_id($camp->id);
    }

    else {

    my $soap = Test::MockModule->new('SOAP::Lite');
    $soap->mock( call => sub {
        my $xml .= <<'EOF';
<addCampaignResponse xmlns="">
   <ns1:addCampaignReturn xmlns:ns1="https://adwords.google.com/api/adwords/v4">
    <ns1:dailyBudget>100000</ns1:dailyBudget>
    <ns1:enableSeparateContentBids>false</ns1:enableSeparateContentBids>
    <ns1:endDay>2011-01-01-05:00</ns1:endDay>
    <ns1:geoTargeting xsi:nil="true"/>
    <ns1:id>3987</ns1:id>
    <ns1:languageTargeting>
      <ns1:languages>en</ns1:languages>
    </ns1:languageTargeting>
    <ns1:name>Campaign #1</ns1:name>
    <ns1:schedule>
     <ns1:intervals>
      <ns1:day>Monday</ns1:day>
      <ns1:startHour>1</ns1:startHour>
      <ns1:startMinute>0</ns1:startMinute>
      <ns1:endHour>10</ns1:endHour>
      <ns1:endMinute>0</ns1:endMinute>
      <ns1:multiplier>1.0</ns1:multiplier>
     </ns1:intervals>
     <ns1:status>Enabled</ns1:status>
    </ns1:schedule>
    <ns1:networkTargeting>
     <ns1:networkTypes>SearchNetwork</ns1:networkTypes>
     <ns1:networkTypes>ContentNetwork</ns1:networkTypes>
    </ns1:networkTargeting>
    <ns1:startDay>2006-08-20-04:00</ns1:startDay>
    <ns1:status>Active</ns1:status>
   </ns1:addCampaignReturn>
  </addCampaignResponse>
EOF

        $xml = $self->gen_full_response($xml);
        my $env = SOAP::Deserializer->deserialize($xml);
        return $env;
    });

    my $campaign_obj = $self->{'obj'}->addCampaign($campaign);
    ok ($campaign_obj->id == 3987, 'campaign id');
    ok ($campaign_obj->name eq 'Campaign #1' , 'campaign name');
    ok ($campaign_obj->enableSeparateContentBids eq 'false', 'enableSeparateContentBids');
    ok ($campaign_obj->dailyBudget == 100000, 'dailyBudget');

    # Ad Schedule
    ok ($campaign_obj->schedule->status eq 'Enabled', 'schedule status Enabled');
    my $intervals_ref = $campaign_obj->schedule->intervals;
    #die Dumper $intervals_ref;
    ok ($intervals_ref->[0]->day eq 'Monday', 'interval');
    

    my $lang_ref = $campaign_obj->languageTargeting;
    ok ($lang_ref->{languages}[0] eq 'en', 'languageTargeting');


    }

}



sub getAllAdWordsCampaigns : Test(no_plan)
{
    my $self = shift;


    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }

    if ($self->{sandbox}) {
        my @campaigns = $self->{'obj'}->getAllAdWordsCampaigns();

        #print Dumper(\@campaigns);

        # we added 3 campaigns. check it.
        ok (scalar @campaigns >= 3, 'getAllAdWordsCampaigns (got more than three)');
        for (@campaigns) {
            ok ($_->id =~ /\d+/, 'getAllAdWordsCampaigns - id: ' . $_->id);
        }
    }
    else {

    my $soap = Test::MockModule->new('SOAP::Lite');
    $soap->mock( call => sub {
        my $xml .= <<'EOF';
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
EOF

        $xml = $self->gen_full_response($xml);
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

    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }


    if ($self->{sandbox}) {
        my $campaign = $self->{obj}->getCampaign($self->{_campaign_id});
        ok ($campaign->id == $self->{_campaign_id}, 
            'getCampaign - id: ' . $campaign->id);
    }

    else {

    my $soap = Test::MockModule->new('SOAP::Lite');
    $soap->mock( call => sub {
        my $xml .= <<'EOF';
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
EOF

        $xml = $self->gen_full_response($xml);
        my $env = SOAP::Deserializer->deserialize($xml);
        return $env;
    });

    my $campaign = $self->{obj}->getCampaign(3987);
    ok ($campaign->id == 3987, 'getCampaign');

    }

}

sub setOptimizeAdServing : Test(no_plan)
{
    my $self = shift;

    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }

    if ($self->{sandbox}) {

        my $ret = $self->{obj}->setOptimizeAdServing($self->{_campaign_id}, 1);
        #my $ret = $self->{obj}->setOptimizeAdServing(3987, 1);
        ok ($ret == 1, 'setOptimizeAdServing');

    }
    else {

    my $soap = Test::MockModule->new('SOAP::Lite');
    $soap->mock( call => sub {
        my $xml .= <<'EOF';
<setOptimizeAdServingResponse xmlns="">
   <ns1:setOptimizeAdServingReturn xmlns:ns1="https://adwords.google.com/api/adwords/v4">true</ns1:setOptimizeAdServingReturn>
  </setOptimizeAdServingResponse>
EOF

        $xml = $self->gen_full_response($xml);
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


    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }

    if ($self->{sandbox}) {

        my $ret = $self->{obj}->getOptimizeAdServing($self->{_campaign_id});
        #my $ret = $self->{obj}->getOptimizeAdServing(3987);
        ok ($ret == 1, 'getOptimizeAdServing');

    }
    else {

    my $soap = Test::MockModule->new('SOAP::Lite');
    $soap->mock( call => sub {
        my $xml .= <<'EOF';
<getOptimizeAdServingResponse xmlns="">
   <ns1:getOptimizeAdServingReturn xmlns:ns1="https://adwords.google.com/api/adwords/v4">true</ns1:getOptimizeAdServingReturn>
  </getOptimizeAdServingResponse>
EOF

        $xml = $self->gen_full_response($xml);
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

    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }

    if ($self->{sandbox}) {
        
        my @campaigns;
        my $campaign1 = Google::Adwords::Campaign->new();
        $campaign1->dailyBudget(100000);
        my $campaign2 = Google::Adwords::Campaign->new();
        $campaign2->dailyBudget(200000);

        push @campaigns, $campaign1, $campaign2;

        my @responses = $self->{obj}->addCampaignList(@campaigns);
        
        # check campaigns
        ok ($responses[0]->dailyBudget == 100000, 'addCampaignList');
        ok ($responses[0]->id =~ /\d+/, 
                'addCampaignList id: ' . $responses[0]->id);
        ok ($responses[1]->dailyBudget == 200000, 'addCampaignList');
        ok ($responses[1]->id =~ /\d+/, 
                'addCampaignList id: ' . $responses[1]->id);

        # save campaign ids for use in getCampaignList
        $self->{_campaign_id_0} = $responses[0]->id;
        $self->{_campaign_id_1} = $responses[1]->id;

    }
    else {

    my $soap = Test::MockModule->new('SOAP::Lite');
    $soap->mock( call => sub {
        my $xml .= <<'EOF';
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
EOF

        $xml = $self->gen_full_response($xml);
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


    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }

    if ($self->{sandbox}) {

        # use the stored campaign ids
        my @campaigns = $self->{obj}->getCampaignList(
            $self->{_campaign_id},
            $self->{_campaign_id_0},
            $self->{_campaign_id_1},
        );

        ok ($campaigns[0]->id == $self->{_campaign_id}, 'getCampaignList');
        ok ($campaigns[1]->id == $self->{_campaign_id_0}, 'getCampaignList');
        ok ($campaigns[2]->id == $self->{_campaign_id_1}, 'getCampaignList');

    }
    else {

    my $soap = Test::MockModule->new('SOAP::Lite');
    $soap->mock( call => sub {
        my $xml .= <<'EOF';
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
EOF

        $xml = $self->gen_full_response($xml);
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


    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }

    if ($self->{sandbox}) {

        
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
<updateCampaignResponse xmlns="" />
EOF

        $xml = $self->gen_full_response($xml);
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

    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }


    if ($self->{sandbox}) {


        my @campaigns;

        my $campaign0 = Google::Adwords::Campaign->new();
        $campaign0->id($self->{_campaign_id_0});
        $campaign0->dailyBudget(2000000);
    
        my $campaign1 = Google::Adwords::Campaign->new();
        $campaign1->id($self->{_campaign_id_1});
        $campaign1->dailyBudget(8000000);

        push @campaigns, $campaign0, $campaign1;

        my $ret = $self->{obj}->updateCampaignList(@campaigns);
        ok ($ret == 1, 'updateCampaignList');


    }
    else {

    my $soap = Test::MockModule->new('SOAP::Lite');
    $soap->mock( call => sub {
        my $xml .= <<'EOF';
<updateCampaignListResponse xmlns="" />
EOF

        $xml = $self->gen_full_response($xml);
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

    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }


    if ($self->{sandbox}) {
        

        my @stats = $self->{obj}->getCampaignStats({
            campaignids => [ $self->{_campaign_id_0}, $self->{_campaign_id_1} ],
            startDay => '2006-12-01',
            endDay => '2006-12-31',
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
EOF

        $xml = $self->gen_full_response($xml);
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


