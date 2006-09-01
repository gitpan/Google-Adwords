package CampaignService;
use base qw/ Service /;

use Test::More;
use Test::MockModule;
use Google::Adwords::Campaign;

sub test_class { return "Google::Adwords::CampaignService"; }

sub add_campaign_default : Test(no_plan)
{
    my $self = shift;

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
        my $camp = $self->{'obj'}->addCampaign({ campaign => $campaign });
        ok ($camp->dailyBudget == 100000, 'campaign dailyBudget');
        ok ($camp->id =~ /\d+/, 'campaign id');
        ok ($camp->status eq 'Active', 'campaign status');
        
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

    my $campaign_obj = $self->{'obj'}->addCampaign({ campaign => $campaign });
    ok ($campaign_obj->id == 3987, 'campaign id');
    ok ($campaign_obj->name eq 'Campaign #1' , 'campaign name');
    ok ($campaign_obj->enableSeparateContentBids eq 'false', 'enableSeparateContentBids');
    ok ($campaign_obj->dailyBudget == 100000, 'dailyBudget');


    }

}


1;


