package CreativeService;
use base qw/ Service /;

use Test::More;
use Test::MockModule;

use Google::Adwords::Creative;
use Google::Adwords::Image;

sub test_class { return "Google::Adwords::CreativeService"; }

# tests to run
my %tests = (
    addCreative             => 0,
    addCreative_Image       => 0,
    addCreativeList         => 0,
    getActiveCreatives      => 0,
    getAllCreatives         => 0,
    getCreative             => 0,
    getCreativeStats        => 0,
    updateCreatives         => 0,
);

sub start_of_each_test : Test(setup)
{
    my $self = shift;

    # set debug to whatever was passed in as param
    $self->{obj}->debug($self->{debug});
}


sub addCreative : Test(no_plan)
{
    my $self = shift;

    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }


    if ($self->{sandbox}) {


        #my $adgroup_id = $self->_get_adgroup_id();
        my $adgroup_id = 20048;

        my $creative = Google::Adwords::Creative->new;

        $creative->headline('The world is indeed flat!');
        $creative->description1('<b>really</b>');
        $creative->description2('really');
        $creative->adGroupId($adgroup_id);
        $creative->destinationUrl('http://aarohan.biz');
        $creative->displayUrl('http://aarohan.biz');

        my $creative_response = $self->{obj}->addCreative($creative);
        ok ($creative_response->adGroupId eq $adgroup_id, 'addCreative');
        ok ($creative_response->id =~ /\d+/, 
            'addCreative id: ' . $creative_response->id);

        # save for further use
        $self->{_creative_id} = $creative_response->id;

    }
    else {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
<addCreativeResponse xmlns="">
   <ns1:addCreativeReturn
xmlns:ns1="https://adwords.google.com/api/adwords/v7">
    <ns1:adGroupId>1001</ns1:adGroupId>
    <ns1:deleted>false</ns1:deleted>
    <ns1:description1>&lt;b&gt;kakakakaka&lt;/b&gt;</ns1:description1>
    <ns1:description2>kakakakaka</ns1:description2>
    <ns1:destinationUrl>http://aarohan.biz</ns1:destinationUrl>
    <ns1:disapproved>false</ns1:disapproved>
    <ns1:displayUrl>aarohan.biz</ns1:displayUrl>
    <ns1:headline>lalala</ns1:headline>
    <ns1:id>20984</ns1:id>
   </ns1:addCreativeReturn>
  </addCreativeResponse>
EOF

            $xml = $self->gen_full_response($xml);
            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $creative = Google::Adwords::Creative->new;

        $creative->headline('lalala');
        $creative->description1('<b>kakakakaka</b>');
        $creative->description2('kakakakaka');
        $creative->adGroupId(20048);
        $creative->destinationUrl('http://aarohan.biz');
        $creative->displayUrl('aarohan.biz');

        my $creative_response = $self->{obj}->addCreative($creative);
        ok ($creative_response->adGroupId == 1001, 'addCreative');
        ok ($creative_response->description1 eq '<b>kakakakaka</b>', 'addCreative');



    }

}

sub addCreative_Image : Test(no_plan)
{
    my $self = shift;

    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }


    if ($self->{sandbox}) {

        my $adgroup_id = $self->_get_adgroup_id();

        my $creative = Google::Adwords::Creative->new;

        $creative->adGroupId($adgroup_id);
        $creative->destinationUrl('http://aarohan.biz');
        $creative->displayUrl('aarohan.biz');

        my $image = Google::Adwords::Image->new;
        $image->name('rohan.jpg');
        $image->data('asjajkjasdkjasd');
        $creative->image($image);

        my $creative_response = $self->{obj}->addCreative($creative);
        ok ($creative_response->adGroupId eq $adgroup_id, 'addCreative');
        ok ($creative_response->id =~ /\d+/, 
            'addCreative id: ' . $creative_response->id);



    }
    else {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
  <addCreativeResponse xmlns="">
    <ns1:addCreativeReturn xmlns:ns1="https://adwords.google.com/api/adwords/v7">
    <ns1:adGroupId>1001</ns1:adGroupId>
    <ns1:deleted>false</ns1:deleted>
    <ns1:description1 xsi:nil="true"/>
    <ns1:description2 xsi:nil="true"/>
    <ns1:destinationUrl>http://aarohan.biz</ns1:destinationUrl>
    <ns1:disapproved>false</ns1:disapproved>
    <ns1:displayUrl>aarohan.biz</ns1:displayUrl>
    <ns1:headline xsi:nil="true"/>
    <ns1:id>21112</ns1:id>
    <ns1:image>
     <ns1:height>60</ns1:height>
     <ns1:imageUrl>https://sandbox.google.com/sandboximages/image.jpg</ns1:imageUrl>
     <ns1:mimeType>image/jpeg</ns1:mimeType>
     <ns1:name>rohan.jpg</ns1:name>
     <ns1:thumbnailUrl>https://sandbox.google.com/sandboximages/thumbnail.jpg</ns1:thumbnailUrl>
     <ns1:type>image</ns1:type>
     <ns1:width>468</ns1:width>
    </ns1:image>
   </ns1:addCreativeReturn>
  </addCreativeResponse>
EOF

            $xml = $self->gen_full_response($xml);
            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $creative = Google::Adwords::Creative->new;

        $creative->adGroupId(1001);
        $creative->destinationUrl('http://aarohan.biz');
        $creative->displayUrl('aarohan.biz');

        my $image = Google::Adwords::Image->new;
        $image->name('rohan.jpg');
        $image->data('asjajkjasdkjasd');

        $creative->image($image);

        my $creative_response = $self->{obj}->addCreative($creative);
        ok ($creative_response->image->height == 60, 'addCreative (Image)');


    }

}

sub addCreativeList: Test(no_plan)
{
    my $self = shift;

    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }


    if ($self->{sandbox}) {

        my $adgroup_id = $self->_get_adgroup_id();

        my $creative1 = Google::Adwords::Creative->new;
        $creative1->adGroupId($adgroup_id);
        $creative1->destinationUrl('http://aarohan.biz');
        $creative1->displayUrl('aarohan.biz');
        $creative1->headline('lalala');
        $creative1->description1('kakakakaka');
        $creative1->description2('kakakakaka');

        my $creative2 = Google::Adwords::Creative->new;
        $creative2->adGroupId($adgroup_id);
        $creative2->destinationUrl('http://aarohan.biz');
        $creative2->displayUrl('aarohan.biz');
        my $image = Google::Adwords::Image->new;
        $image->name('rohan.jpg');
        $image->data('asjajkjasdkjasd');
        $creative2->image($image);

        my @creatives 
            = $self->{obj}->addCreativeList($creative1, $creative2);

        ok ($creatives[0]->id =~ /\d+/, 
            'addCreativeList id: ' . $creatives[0]->id);
        ok ($creatives[1]->id =~ /\d+/, 
            'addCreativeList id: ' . $creatives[1]->id);



    }
    else {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
  <addCreativeListResponse xmlns="">
   <ns1:addCreativeListReturn
xmlns:ns1="https://adwords.google.com/api/adwords/v6">
    <ns1:adGroupId>1001</ns1:adGroupId>
    <ns1:deleted>false</ns1:deleted>
    <ns1:description1>kakakakaka</ns1:description1>
    <ns1:description2>kakakakaka</ns1:description2>
    <ns1:destinationUrl>http://aarohan.biz</ns1:destinationUrl>
    <ns1:disapproved>false</ns1:disapproved>
    <ns1:displayUrl>aarohan.biz</ns1:displayUrl>
    <ns1:headline>lalala</ns1:headline>
    <ns1:id>21115</ns1:id>
   </ns1:addCreativeListReturn>
   <ns2:addCreativeListReturn
xmlns:ns2="https://adwords.google.com/api/adwords/v6">
    <ns2:adGroupId>1001</ns2:adGroupId>
    <ns2:deleted>false</ns2:deleted>
    <ns2:description1 xsi:nil="true"/>
    <ns2:description2 xsi:nil="true"/>
    <ns2:destinationUrl>http://aarohan.biz</ns2:destinationUrl>
    <ns2:disapproved>false</ns2:disapproved>
    <ns2:displayUrl>aarohan.biz</ns2:displayUrl>
    <ns2:headline xsi:nil="true"/>
    <ns2:id>21116</ns2:id>
    <ns2:image>
     <ns2:height>60</ns2:height>
     <ns2:imageUrl>https://sandbox.google.com/sandboximages/image.jpg</ns2:imageUrl>
     <ns2:mimeType>image/jpeg</ns2:mimeType>
     <ns2:name>rohan.jpg</ns2:name>
     <ns2:thumbnailUrl>https://sandbox.google.com/sandboximages/thumbnail.jpg</ns2:thumbnailUrl>
     <ns2:type>image</ns2:type>
     <ns2:width>468</ns2:width>
    </ns2:image>
   </ns2:addCreativeListReturn>
  </addCreativeListResponse>
EOF

            $xml = $self->gen_full_response($xml);
            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $creative1 = Google::Adwords::Creative->new;
        $creative1->adGroupId(1001);
        $creative1->destinationUrl('http://aarohan.biz');
        $creative1->displayUrl('aarohan.biz');
        $creative1->headline('lalala');
        $creative1->description1('kakakakaka');
        $creative1->description2('kakakakaka');

        my $creative2 = Google::Adwords::Creative->new;
        $creative2->adGroupId(1001);
        $creative2->destinationUrl('http://aarohan.biz');
        $creative2->displayUrl('aarohan.biz');
        my $image = Google::Adwords::Image->new;
        $image->name('rohan.jpg');
        $image->data('asjajkjasdkjasd');
        $creative2->image($image);

        my @creatives 
            = $self->{obj}->addCreativeList($creative1, $creative2);

        ok ($creatives[0]->adGroupId == 1001, 'addCreativeList');
        ok ($creatives[1]->image->height == 60, 'addCreativeList');


    }

}

sub getActiveCreatives : Test(no_plan)
{
    my $self = shift;


    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }

    if ($self->{sandbox}) {

        my $adgroup_id = $self->_get_adgroup_id();

        my @creatives = $self->{obj}->getActiveCreatives($adgroup_id);

        # should get three or more
        ok (scalar @creatives >= 3, 'getActiveCreatives');

        for (@creatives) {
            ok ($_->id =~ /\d+/, 'getActiveCreatives id: ' . $_->id);
        }

    }
    else {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
  <getActiveCreativesResponse>
    <ns10:getActiveCreativesReturn
xmlns:ns10="https://adwords.google.com/api/adwords/v6">
    <ns10:adGroupId>1001</ns10:adGroupId>
    <ns10:deleted>false</ns10:deleted>
    <ns10:description1>kakakakaka</ns10:description1>
    <ns10:description2>kakakakaka</ns10:description2>
    <ns10:destinationUrl>http://aarohan.biz</ns10:destinationUrl>
    <ns10:disapproved>false</ns10:disapproved>
    <ns10:displayUrl>aarohan.biz</ns10:displayUrl>
    <ns10:headline>lalala</ns10:headline>
    <ns10:id>21117</ns10:id>
   </ns10:getActiveCreativesReturn>
    <ns11:getActiveCreativesReturn
xmlns:ns11="https://adwords.google.com/api/adwords/v6">
    <ns11:adGroupId>1001</ns11:adGroupId>
    <ns11:deleted>false</ns11:deleted>
    <ns11:description1 xsi:nil="true"/>
    <ns11:description2 xsi:nil="true"/>
    <ns11:destinationUrl>http://aarohan.biz</ns11:destinationUrl>
    <ns11:disapproved>false</ns11:disapproved>
    <ns11:displayUrl>aarohan.biz</ns11:displayUrl>
    <ns11:headline xsi:nil="true"/>
    <ns11:id>21118</ns11:id>
    <ns11:image>
     <ns11:height>60</ns11:height>
     <ns11:imageUrl>https://sandbox.google.com/sandboximages/image.jpg</ns11:imageUrl>
     <ns11:mimeType>image/jpeg</ns11:mimeType>
     <ns11:name>rohan.jpg</ns11:name>
     <ns11:thumbnailUrl>https://sandbox.google.com/sandboximages/thumbnail.jpg</ns11:thumbnailUrl>
     <ns11:type>image</ns11:type>
     <ns11:width>468</ns11:width>
    </ns11:image>
   </ns11:getActiveCreativesReturn>
  </getActiveCreativesResponse>
EOF

            $xml = $self->gen_full_response($xml);
            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my @creatives = $self->{obj}->getActiveCreatives(1001);

        ok ($creatives[0]->adGroupId == 1001, 'getActiveCreatives');
        ok ($creatives[1]->adGroupId == 1001, 'getActiveCreatives');
        ok ($creatives[1]->image->height == 60, 'getActiveCreatives');



    }


}

sub getAllCreatives : Test(no_plan)
{
    my $self = shift;


    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }

    if ($self->{sandbox}) {

        my $adgroup_id = $self->_get_adgroup_id();

        my @creatives = $self->{obj}->getAllCreatives($adgroup_id);

        # should get three or more
        ok (scalar @creatives >= 3, 'getAllCreatives');

        for (@creatives) {
            ok ($_->id =~ /\d+/, 'getAllCreatives id: ' . $_->id);
        }



    }
    else {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
  <getAllCreativesResponse>
    <ns10:getAllCreativesReturn
xmlns:ns10="https://adwords.google.com/api/adwords/v6">
    <ns10:adGroupId>1001</ns10:adGroupId>
    <ns10:deleted>false</ns10:deleted>
    <ns10:description1>kakakakaka</ns10:description1>
    <ns10:description2>kakakakaka</ns10:description2>
    <ns10:destinationUrl>http://aarohan.biz</ns10:destinationUrl>
    <ns10:disapproved>false</ns10:disapproved>
    <ns10:displayUrl>aarohan.biz</ns10:displayUrl>
    <ns10:headline>lalala</ns10:headline>
    <ns10:id>21117</ns10:id>
   </ns10:getAllCreativesReturn>
    <ns11:getAllCreativesReturn
xmlns:ns11="https://adwords.google.com/api/adwords/v6">
    <ns11:adGroupId>1001</ns11:adGroupId>
    <ns11:deleted>false</ns11:deleted>
    <ns11:description1 xsi:nil="true"/>
    <ns11:description2 xsi:nil="true"/>
    <ns11:destinationUrl>http://aarohan.biz</ns11:destinationUrl>
    <ns11:disapproved>false</ns11:disapproved>
    <ns11:displayUrl>aarohan.biz</ns11:displayUrl>
    <ns11:headline xsi:nil="true"/>
    <ns11:id>21118</ns11:id>
    <ns11:image>
     <ns11:height>60</ns11:height>
     <ns11:imageUrl>https://sandbox.google.com/sandboximages/image.jpg</ns11:imageUrl>
     <ns11:mimeType>image/jpeg</ns11:mimeType>
     <ns11:name>rohan.jpg</ns11:name>
     <ns11:thumbnailUrl>https://sandbox.google.com/sandboximages/thumbnail.jpg</ns11:thumbnailUrl>
     <ns11:type>image</ns11:type>
     <ns11:width>468</ns11:width>
    </ns11:image>
   </ns11:getAllCreativesReturn>
  </getAllCreativesResponse>
EOF

            $xml = $self->gen_full_response($xml);
            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my @creatives = $self->{obj}->getAllCreatives(1001);

        ok ($creatives[0]->adGroupId == 1001, 'getAllCreatives');
        ok ($creatives[1]->adGroupId == 1001, 'getAllCreatives');
        ok ($creatives[1]->image->height == 60, 'getAllCreatives');



    }
}

sub getCreative : Test(no_plan)
{
    my $self = shift;

    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }


    if ($self->{sandbox}) {

        my $adgroup_id = $self->_get_adgroup_id();
        my $creative_id = $self->{_creative_id};
        
        my $creative = $self->{obj}->getCreative($adgroup_id, $creative_id);

        ok ($creative->adGroupId eq $adgroup_id, 'getCreative');
        ok ($creative->id eq $self->{_creative_id}, 'getCreative');

    }
    else {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
  <getCreativeResponse xmlns="">
   <ns1:getCreativeReturn
xmlns:ns1="https://adwords.google.com/api/adwords/v6">
    <ns1:adGroupId>1001</ns1:adGroupId>
    <ns1:deleted>false</ns1:deleted>
    <ns1:description1 xsi:nil="true"/>
    <ns1:description2 xsi:nil="true"/>
    <ns1:destinationUrl>http://aarohan.biz</ns1:destinationUrl>
    <ns1:disapproved>false</ns1:disapproved>
    <ns1:displayUrl>aarohan.biz</ns1:displayUrl>
    <ns1:headline xsi:nil="true"/>
    <ns1:id>21111</ns1:id>
    <ns1:image>
     <ns1:height>60</ns1:height>
     <ns1:imageUrl>https://sandbox.google.com/sandboximages/image.jpg</ns1:imageUrl>
     <ns1:mimeType>image/jpeg</ns1:mimeType>
     <ns1:name>rohan.jpg</ns1:name>
     <ns1:thumbnailUrl>https://sandbox.google.com/sandboximages/thumbnail.jpg</ns1:thumbnailUrl>
     <ns1:type>image</ns1:type>
     <ns1:width>468</ns1:width>
    </ns1:image>
   </ns1:getCreativeReturn>
  </getCreativeResponse>
EOF

            $xml = $self->gen_full_response($xml);
            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $creative = $self->{obj}->getCreative(1001, 21111);

        ok ($creative->adGroupId == 1001, 'getCreative');
        ok ($creative->image->height == 60, 'getCreative');


    }
}

sub getCreativeStats : Test(no_plan)
{
    my $self = shift;

    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }


    if ($self->{sandbox}) {

        my $adgroup_id = $self->_get_adgroup_id();

        my @stats = $self->{obj}->getCreativeStats({
            adGroupId => $adgroup_id,
            creativeIds => [ $self->{_creative_id} ],
            startDay => '2006-12-01',
            endDay => '2006-12-15',
            inPST => 1,
        });

        ok ($stats[0]->id == $self->{_creative_id}, 'getCreativeStats');

       

    }
    else {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
<getCreativeStatsResponse xmlns="">
   <ns1:getCreativeStatsReturn
xmlns:ns1="https://adwords.google.com/api/adwords/v5">
    <ns1:averagePosition>0.0</ns1:averagePosition>
    <ns1:clicks>10</ns1:clicks>
    <ns1:conversionRate>0.0</ns1:conversionRate>
    <ns1:conversions>0</ns1:conversions>
    <ns1:cost>0</ns1:cost>
    <ns1:id>1001</ns1:id>
    <ns1:impressions>0</ns1:impressions>
   </ns1:getCreativeStatsReturn>
   <ns2:getCreativeStatsReturn
xmlns:ns2="https://adwords.google.com/api/adwords/v5">
    <ns2:averagePosition>0.0</ns2:averagePosition>
    <ns2:clicks>0</ns2:clicks>
    <ns2:conversionRate>0.0</ns2:conversionRate>
    <ns2:conversions>0</ns2:conversions>
    <ns2:cost>0</ns2:cost>
    <ns2:id>1002</ns2:id>
    <ns2:impressions>0</ns2:impressions>
   </ns2:getCreativeStatsReturn>
  </getCreativeStatsResponse>
EOF

            $xml = $self->gen_full_response($xml);
            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $adgroup_id = 1004;

        my @stats = $self->{obj}->getCreativeStats({
            adGroupId => $adgroup_id,
            creativeIds => [ 1001, 1002 ],
            startDay => '2006-09-01',
            endDay => '2006-09-15',
            inPST => 1,
        });

        ok ($stats[0]->id == 1001, 'getCreativeStats');
        ok ($stats[0]->clicks == 10, 'getCreativeStats');
        ok ($stats[1]->id == 1002, 'getCreativeStats');
        

    }


}

sub updateCreatives: Test(no_plan)
{
    my $self = shift;

    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }


    if ($self->{sandbox}) {

        my $adgroup_id = $self->_get_adgroup_id();

        my $creative1 = Google::Adwords::Creative->new;
        $creative1->adGroupId($adgroup_id);
        $creative1->id($self->{_creative_id});
        $creative1->status('Paused');

        my $ret = $self->{obj}->updateCreatives($creative1);
        ok ($ret == 1, 'updateCreatives');

        # reset
        $creative1->adGroupId($adgroup_id);
        $creative1->id($self->{_creative_id});
        $creative1->status('Enabled');
        $ret = $self->{obj}->updateCreatives($creative1);
        ok ($ret == 1, 'updateCreatives');

    }
    else {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
  <updateCreativesResponse xmlns=""/>
EOF

            $xml = $self->gen_full_response($xml);
            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $adgroup_id = '4728';

        my $creative1 = Google::Adwords::Creative->new;
        $creative1->adGroupId($adgroup_id);
        $creative1->id(16516);
        $creative1->status('Paused');

        my $ret = $self->{obj}->updateCreatives($creative1);
        ok ($ret == 1, 'updateCreatives');

        # reset
        $creative1->adGroupId($adgroup_id);
        $creative1->id(16516);
        $creative1->status('Enabled');
        $ret = $self->{obj}->updateCreatives($creative1);
        ok ($ret == 1, 'updateCreatives');


    }

}

1;


