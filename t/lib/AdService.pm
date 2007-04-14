package AdService;
use base qw/ Service /;

use Test::More;
use Test::MockModule;
use Data::Dumper;

use Google::Adwords::Ad;
use Google::Adwords::StatsRecord;
use Google::Adwords::Image;

sub test_class { return "Google::Adwords::AdService"; }

# tests to run
my %tests = (
    addAds              => 1,
    addAds_image        => 1,
    getActiveAds        => 1,
    getAd               => 1,
    getAdStats          => 1,
    getAllAds           => 1,
    updateAds           => 1,
);

sub start_of_each_test : Test(setup)
{
    my $self = shift;

    # set debug to whatever was passed in as param
    $self->{obj}->debug($self->{debug});
}


sub addAds : Test(no_plan)
{
    my $self = shift;

    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }


    if ($self->{sandbox}) {


        my $adgroup_id = $self->_get_adgroup_id();
        #my $adgroup_id = 20048;

        my $ad = Google::Adwords::Ad->new;
        $ad->adType('TextAd');
        $ad->headline('lalala');
        $ad->description1('kakakakaka');
        $ad->description2('kakakakaka');
        $ad->adGroupId($adgroup_id);
        $ad->destinationUrl('http://aarohan.biz');
        $ad->displayUrl('aarohan.biz');
        #$ad->status('Paused');


        my @ads = $self->{obj}->addAds($ad);
        ok ($ads[0]->adType eq 'TextAd', 'addAds (adType)',);
        #ok ($ads[0]->status eq 'Paused', 'addAds (status)',);
        ok ($ads[0]->adGroupId == $adgroup_id, 'addAds (adGroupId)',);

        # save for further use
        $self->{_ad_id} = $ads[0]->id;

    }
    else {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
<addAdsResponse xmlns="">
   <ns1:addAdsReturn xsi:type="ns1:TextAd"
xmlns:ns1="https://adwords.google.com/api/adwords/v8">
    <ns1:adGroupId>20048</ns1:adGroupId>
    <ns1:adType>TextAd</ns1:adType>
    <ns1:destinationUrl>http://aarohan.biz</ns1:destinationUrl>
    <ns1:disapproved>false</ns1:disapproved>
    <ns1:displayUrl>aarohan.biz</ns1:displayUrl>
    <ns1:id>24632</ns1:id>
    <ns1:status>Disabled</ns1:status>
    <ns1:description1>really</ns1:description1>
    <ns1:description2>really</ns1:description2>
    <ns1:headline>The world is indeed flat!</ns1:headline>
   </ns1:addAdsReturn>
  </addAdsResponse>
EOF

            $xml = $self->gen_full_response($xml);
            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $ad = Google::Adwords::Ad->new;
        $ad->adType('TextAd');
        $ad->headline('lalala');
        $ad->description1('kakakakaka');
        $ad->description2('kakakakaka');
        $ad->adGroupId(20048);
        $ad->destinationUrl('http://aarohan.biz');
        $ad->displayUrl('aarohan.biz');
        $ad->status('Paused');

        my @ads = $self->{obj}->addAds($ad);
        ok ($ads[0]->adGroupId == 20048, 'addAds (adGroupId)');
        ok ($ads[0]->id == 24632, 'addAds (id)');
        ok ($ads[0]->adType eq 'TextAd', 'addAds (adType)');
        ok ($ads[0]->description1 eq 'really', 'addAds (description1)');



    }

}

sub addAds_image : Test(no_plan)
{
    my $self = shift;

    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }


    if ($self->{sandbox}) {

        my $adgroup_id = $self->_get_adgroup_id();
        #my $adgroup_id = 20048;

        my $image_ad = Google::Adwords::Ad->new;
        $image_ad->adType('ImageAd');
        $image_ad->adGroupId($adgroup_id);
        $image_ad->destinationUrl('http://aarohan.biz');
        $image_ad->displayUrl('aarohan.biz');
        #$image_ad->status('Paused');

        my $image = Google::Adwords::Image->new;
        $image->name('rohan.jpg');
        $image->data('asjajkjasdkjasd');
        $image_ad->image($image);

        my @ads = $self->{obj}->addAds($image_ad);
        ok ($ads[0]->adGroupId == $adgroup_id, 'addAds Image (adGroupId)');
        ok ($ads[0]->adType eq 'ImageAd', 'addAds Image (adType)');

    }
    else {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
<addAdsResponse xmlns="">
   <ns1:addAdsReturn xsi:type="ns1:ImageAd"
xmlns:ns1="https://adwords.google.com/api/adwords/v8">
    <ns1:adGroupId>20048</ns1:adGroupId>
    <ns1:adType>ImageAd</ns1:adType>
    <ns1:destinationUrl>http://aarohan.biz</ns1:destinationUrl>
    <ns1:disapproved>false</ns1:disapproved>
    <ns1:displayUrl>aarohan.biz</ns1:displayUrl>
    <ns1:id>24633</ns1:id>
    <ns1:status>Paused</ns1:status>
    <ns1:image>
     <ns1:height>250</ns1:height>
     <ns1:imageUrl>CGQQrAIY-gEoATIIcoKLHKKriDM</ns1:imageUrl>
     <ns1:mimeType>image/gif</ns1:mimeType>
     <ns1:name>rohan.jpg</ns1:name>
     <ns1:thumbnailUrl>CGQQrAIY7wEoATIIcWIlt5pON-o</ns1:thumbnailUrl>
     <ns1:type>image</ns1:type>
     <ns1:width>300</ns1:width>
    </ns1:image>
   </ns1:addAdsReturn>
</addAdsResponse>
EOF

            $xml = $self->gen_full_response($xml);
            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $image_ad = Google::Adwords::Ad->new;
        $image_ad->adType('ImageAd');
        $image_ad->adGroupId(1001);
        $image_ad->destinationUrl('http://aarohan.biz');
        $image_ad->displayUrl('aarohan.biz');
        $image_ad->status('Paused');

        my $image = Google::Adwords::Image->new;
        $image->name('rohan.jpg');
        $image->data('asjajkjasdkjasd');
        $image_ad->image($image);

        my @ads = $self->{obj}->addAds($image_ad);
        ok ($ads[0]->id == 24633, 'addAds Image (id)');
        ok ($ads[0]->image->width == 300, 'addAds Image (width)');
        ok ($ads[0]->adType eq 'ImageAd', 'addAds Image (adType)');


    }

}

sub getActiveAds : Test(no_plan)
{
    my $self = shift;


    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }

    if ($self->{sandbox}) {

        my $adgroup_id = $self->_get_adgroup_id();
        #my $adgroup_id = 20048;

        my @ads = $self->{obj}->getActiveAds($adgroup_id);

        # should get two or more
        ok (scalar @ads >= 2, 'getActiveAds');

        for (@ads) {
            ok ($_->id =~ /\d+/, 'getActiveAds id: ' . $_->id);
        }

    }
    else {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
<getActiveAdsResponse xmlns="">
   <ns1:getActiveAdsReturn xsi:type="ns1:TextAd"
xmlns:ns1="https://adwords.google.com/api/adwords/v8">
    <ns1:adGroupId>20048</ns1:adGroupId>
    <ns1:adType>TextAd</ns1:adType>
    <ns1:destinationUrl>http://aarohan.biz</ns1:destinationUrl>
    <ns1:disapproved>false</ns1:disapproved>
    <ns1:displayUrl>aarohan.biz</ns1:displayUrl>
    <ns1:id>24626</ns1:id>
    <ns1:status>Enabled</ns1:status>
    <ns1:description1>kakakakaka</ns1:description1>
    <ns1:description2>kakakakaka</ns1:description2>
    <ns1:headline>lalala</ns1:headline>
   </ns1:getActiveAdsReturn>
   <ns2:getActiveAdsReturn xsi:type="ns2:ImageAd"
xmlns:ns2="https://adwords.google.com/api/adwords/v8">
    <ns2:adGroupId>20048</ns2:adGroupId>
    <ns2:adType>ImageAd</ns2:adType>
    <ns2:destinationUrl>http://aarohan.biz</ns2:destinationUrl>
    <ns2:disapproved>false</ns2:disapproved>
    <ns2:displayUrl>aarohan.biz</ns2:displayUrl>
    <ns2:id>24627</ns2:id>
    <ns2:status>Enabled</ns2:status>
    <ns2:image>
     <ns2:height>60</ns2:height>
     <ns2:imageUrl>CAEQ1AMYPCgBMgil3v-mNDMASg</ns2:imageUrl>
     <ns2:mimeType>image/jpeg</ns2:mimeType>
     <ns2:name>rohan.jpg</ns2:name>
     <ns2:thumbnailUrl>CAEQ1AMYMSgBMghe1nYUawrgyw</ns2:thumbnailUrl>
     <ns2:type>image</ns2:type>
     <ns2:width>468</ns2:width>
    </ns2:image>
   </ns2:getActiveAdsReturn>
   <ns3:getActiveAdsReturn xsi:type="ns3:ImageAd"
xmlns:ns3="https://adwords.google.com/api/adwords/v8">
    <ns3:adGroupId>20048</ns3:adGroupId>
    <ns3:adType>ImageAd</ns3:adType>
    <ns3:destinationUrl>http://aarohan.biz</ns3:destinationUrl>
    <ns3:disapproved>false</ns3:disapproved>
    <ns3:displayUrl>aarohan.biz</ns3:displayUrl>
    <ns3:id>24628</ns3:id>
    <ns3:status>Enabled</ns3:status>
    <ns3:image>
     <ns3:height>60</ns3:height>
     <ns3:imageUrl>CAEQ1AMYPCgBMgil3v-mNDMASg</ns3:imageUrl>
     <ns3:mimeType>image/jpeg</ns3:mimeType>
     <ns3:name>rohan.jpg</ns3:name>
     <ns3:thumbnailUrl>CAEQ1AMYMSgBMghe1nYUawrgyw</ns3:thumbnailUrl>
     <ns3:type>image</ns3:type>
     <ns3:width>468</ns3:width>
    </ns3:image>
   </ns3:getActiveAdsReturn>
  </getActiveAdsResponse>
EOF

            $xml = $self->gen_full_response($xml);
            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $adgroup_id = 20048;

        my @ads = $self->{obj}->getActiveAds($adgroup_id);

        # should get two or more
        ok (scalar @ads >= 2, 'getActiveAds');
        ok ($ads[0]->adGroupId == $adgroup_id, 'getActiveAds (adGroupId)');

        for (@ads) {
            ok ($_->id =~ /\d+/, 'getActiveAds id: ' . $_->id);
        }


    }


}

sub getAd : Test(no_plan)
{
    my $self = shift;

    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }


    if ($self->{sandbox}) {

        my $adgroup_id = $self->_get_adgroup_id();
        #my $adgroup_id = 20048;

        my $ad_id = $self->{_ad_id};
        #my $ad_id = 24626;
        
        my $ad = $self->{obj}->getAd($adgroup_id, $ad_id);
        ok ($ad->adGroupId == $adgroup_id, 'getAd');
        ok ($ad->id eq $ad_id, 'getAd');

    }
    else {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
<getAdResponse xmlns="">
   <ns1:getAdReturn xsi:type="ns1:TextAd"
xmlns:ns1="https://adwords.google.com/api/adwords/v8">
    <ns1:adGroupId>20048</ns1:adGroupId>
    <ns1:adType>TextAd</ns1:adType>
    <ns1:destinationUrl>http://aarohan.biz</ns1:destinationUrl>
    <ns1:disapproved>false</ns1:disapproved>
    <ns1:displayUrl>aarohan.biz</ns1:displayUrl>
    <ns1:id>24626</ns1:id>
    <ns1:status>Enabled</ns1:status>
    <ns1:description1>kakakakaka</ns1:description1>
    <ns1:description2>kakakakaka</ns1:description2>
    <ns1:headline>lalala</ns1:headline>
   </ns1:getAdReturn>
  </getAdResponse>
EOF

            $xml = $self->gen_full_response($xml);
            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $adgroup_id = 20048;
        my $ad_id = 24626;
        
        my $ad = $self->{obj}->getAd($adgroup_id, $ad_id);
        ok ($ad->adGroupId == $adgroup_id, 'getAd (adGroupId)');
        ok ($ad->id eq $ad_id, 'getAd (id)');


    }
}

sub getAdStats : Test(no_plan)
{
    my $self = shift;

    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }


    if ($self->{sandbox}) {

        my $adgroup_id = $self->_get_adgroup_id();
        #my $adgroup_id = 20048;

        my $ad_ids = [ $self->{_ad_id} ];
        #my $ad_ids = [ 24626 ],

        #my @stats = $self->{obj}->getAdStats({
        #    adGroupId => $adgroup_id,
        #    adIds => $ad_ids,
        #    startDay => '2007-02-19',
        #    endDay => '2007-02-19',
        #    inPST => 0,
        #});

        #ok (ref $stats[0] eq 'Google::Adwords::StatsRecord', 'getAdStats');

       

    }
    else {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
  <getAdStatsResponse/>
EOF

            $xml = $self->gen_full_response($xml);
            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $adgroup_id = 1004;

        my @stats = $self->{obj}->getAdStats({
            adGroupId => $adgroup_id,
            adIds => [ 1001, 1002 ],
            startDay => '2006-09-01',
            endDay => '2006-09-15',
            inPST => 1,
        });

        #ok ($stats[0]->id == 1001, 'getCreativeStats');
        #ok ($stats[0]->clicks == 10, 'getCreativeStats');
        #ok ($stats[1]->id == 1002, 'getCreativeStats');
        

    }


}

sub getAllAds : Test(no_plan)
{
    my $self = shift;


    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }

    if ($self->{sandbox}) {

        my $adgroup_id = $self->_get_adgroup_id();
        #my $adgroup_id = 20048;

        my @ads = $self->{obj}->getAllAds($adgroup_id);

        # should get two or more
        ok (scalar @ads >= 2, 'getAllAds');

        for (@ads) {
            ok ($_->id =~ /\d+/, 'getAllAds id: ' . $_->id);
        }



    }
    else {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
<getAllAdsResponse xmlns="">
   <ns1:getAllAdsReturn xsi:type="ns1:TextAd"
xmlns:ns1="https://adwords.google.com/api/adwords/v8">
    <ns1:adGroupId>20048</ns1:adGroupId>
    <ns1:adType>TextAd</ns1:adType>
    <ns1:destinationUrl>http://aarohan.biz</ns1:destinationUrl>
    <ns1:disapproved>false</ns1:disapproved>
    <ns1:displayUrl>aarohan.biz</ns1:displayUrl>
    <ns1:id>24626</ns1:id>
    <ns1:status>Enabled</ns1:status>
    <ns1:description1>kakakakaka</ns1:description1>
    <ns1:description2>kakakakaka</ns1:description2>
    <ns1:headline>lalala</ns1:headline>
   </ns1:getAllAdsReturn>
  </getAllAdsResponse>
EOF

            $xml = $self->gen_full_response($xml);
            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $adgroup_id = 20048;

        my @ads = $self->{obj}->getAllAds($adgroup_id);

        for (@ads) {
            ok ($_->id =~ /\d+/, 'getAllAds id: ' . $_->id);
        }

    }
}

sub updateAds: Test(no_plan)
{
    my $self = shift;

    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }


    if ($self->{sandbox}) {

        my $adgroup_id = $self->_get_adgroup_id();
        #my $adgroup_id = 20048;
        
        my $ad_id = $self->{_ad_id};
        #my $ad_id = 24626;

        my $ad1 = Google::Adwords::Ad->new;
        $ad1->adType('TextAd');
        $ad1->id($ad_id);
        $ad1->adGroupId($adgroup_id);
        $ad1->status('Paused');

        my $ret = $self->{obj}->updateAds($ad1);
        ok ($ret == 1, 'updateAds');

    }
    else {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
  <updateAdsResponse xmlns=""/>
EOF

            $xml = $self->gen_full_response($xml);
            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $adgroup_id = 20048;
        
        my $ad_id = 24626;

        my $ad1 = Google::Adwords::Ad->new;
        $ad1->adType('TextAd');
        $ad1->id($ad_id);
        $ad1->adGroupId($adgroup_id);
        $ad1->status('Paused');

        my $ret = $self->{obj}->updateAds($ad1);
        ok ($ret == 1, 'updateAds');


    }

}

1;


