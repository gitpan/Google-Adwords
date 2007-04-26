package TrafficEstimatorService;
use base qw/ Service /;

use Test::More;
use Test::MockModule;

use Google::Adwords::AdGroupRequest;
use Google::Adwords::KeywordRequest;
use Google::Adwords::CampaignRequest;

sub test_class { return "Google::Adwords::TrafficEstimatorService"; }

# tests to run
my %tests = (
    estimateAdGroupList  => 1,
    estimateCampaignList => 1,
    estimateKeywordList  => 1,
);

sub start_of_each_test : Test(setup)
{
    my $self = shift;

    # set debug to whatever was passed in as param
    $self->{obj}->debug( $self->{debug} );
}

sub estimateAdGroupList : Test(no_plan)
{
    my $self = shift;

    $sub_name = ( caller 0 )[3];
    $sub_name =~ s/^.+:://;
    if ( not $tests{$sub_name} ) {
        return;
    }

    if ( $self->{sandbox} ) {

        my $kwreq1
            = Google::Adwords::KeywordRequest->new->text('web marketing')
            ->type('Broad')->maxCpc(1000000);

        my $kwreq2 = Google::Adwords::KeywordRequest->new->text(
            'marketing analytics')->maxCpc(1000000)->type('Broad');

        my $adgroup_request1
            = Google::Adwords::AdGroupRequest->new->maxCpc(50000000)
            ->keywordRequests( $kwreq1, $kwreq2 );

        my @estimates = $self->{obj}->estimateAdGroupList($adgroup_request1);

        ok( ref $estimates[0] eq 'Google::Adwords::AdGroupEstimate',
            'estimateAdGroupList' );
        ok( scalar @{ $estimates[0]->keywordEstimates } == 2,
            'estimateAdGroupList' );
    } # end if ( $self->{sandbox} )
    else {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock(
            call => sub {
                my $xml .= <<'EOF';
  <estimateAdGroupListResponse xmlns="">
   <ns1:estimateAdGroupListReturn
xmlns:ns1="https://adwords.google.com/api/adwords/v6">
    <ns1:id>-1</ns1:id>
    <ns1:keywordEstimates>
     <ns1:id>-1</ns1:id>
     <ns1:lowerAvgPosition>16.0</ns1:lowerAvgPosition>
     <ns1:lowerClicksPerDay>7.418177</ns1:lowerClicksPerDay>
     <ns1:lowerCpc>593068</ns1:lowerCpc>
     <ns1:upperAvgPosition>20.0</ns1:upperAvgPosition>
     <ns1:upperClicksPerDay>442.94235</ns1:upperClicksPerDay>
     <ns1:upperCpc>812720</ns1:upperCpc>
    </ns1:keywordEstimates>
    <ns1:keywordEstimates>
     <ns1:id>-1</ns1:id>
     <ns1:lowerAvgPosition>11.0</ns1:lowerAvgPosition>
     <ns1:lowerClicksPerDay>16.932203</ns1:lowerClicksPerDay>
     <ns1:lowerCpc>123506</ns1:lowerCpc>
     <ns1:upperAvgPosition>15.0</ns1:upperAvgPosition>
     <ns1:upperClicksPerDay>93.05362</ns1:upperClicksPerDay>
     <ns1:upperCpc>1000000</ns1:upperCpc>
    </ns1:keywordEstimates>
   </ns1:estimateAdGroupListReturn>
  </estimateAdGroupListResponse>
EOF

                $xml = $self->gen_full_response($xml);
                my $env = SOAP::Deserializer->deserialize($xml);
                return $env;
            }
        );

        my $kwreq1
            = Google::Adwords::KeywordRequest->new->text('web marketing')
            ->type('Broad')->maxCpc(1000000);

        my $kwreq2 = Google::Adwords::KeywordRequest->new->text(
            'marketing analytics')->maxCpc(1000000)->type('Broad');

        my $adgroup_request1
            = Google::Adwords::AdGroupRequest->new->maxCpc(50000000)
            ->keywordRequests( $kwreq1, $kwreq2 );

        my @estimates = $self->{obj}->estimateAdGroupList($adgroup_request1);

        ok( ref $estimates[0] eq 'Google::Adwords::AdGroupEstimate',
            'estimateAdGroupList' );
        ok( scalar @{ $estimates[0]->keywordEstimates } == 2,
            'estimateAdGroupList' );
        ok( $estimates[0]->keywordEstimates->[1]->lowerCpc == 123506,
            'estimateAdGroupList' );
    }

} # end sub estimateAdGroupList :

sub estimateCampaignList : Test(no_plan)
{
    my $self = shift;

    $sub_name = ( caller 0 )[3];
    $sub_name =~ s/^.+:://;
    if ( not $tests{$sub_name} ) {
        return;
    }

    if ( $self->{sandbox} ) {

        my $kwreq1
            = Google::Adwords::KeywordRequest->new->text('web marketing')
            ->type('Broad')->maxCpc(1000000);

        my $kwreq2 = Google::Adwords::KeywordRequest->new->text(
            'marketing analytics')->maxCpc(1000000)->type('Broad');

        my $adgroup_request1
            = Google::Adwords::AdGroupRequest->new->maxCpc(50000000)
            ->keywordRequests( $kwreq1, $kwreq2 );

        my $cmpgreq1 = Google::Adwords::CampaignRequest->new->geoTargeting(
            { cities => ['Pelican, AK US'] } )
            ->languageTargeting( { languages => [ 'fr', 'en' ] } )
            ->adGroupRequests($adgroup_request1);

        my @estimates = $self->{obj}->estimateCampaignList($cmpgreq1);

        ok( ref $estimates[0] eq 'Google::Adwords::CampaignEstimate',
            'estimateCampaignList' );

        my $adgroup_estimate = $estimates[0]->adGroupEstimates->[0];
        ok( ref $adgroup_estimate eq 'Google::Adwords::AdGroupEstimate',
            'estimateCampaignList' );

        ok( scalar @{ $adgroup_estimate->keywordEstimates } == 2,
            'estimateCampaignList' );

    } # end if ( $self->{sandbox} )
    else {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock(
            call => sub {
                my $xml .= <<'EOF';
  <estimateCampaignListResponse xmlns="">
   <ns1:estimateCampaignListReturn
xmlns:ns1="https://adwords.google.com/api/adwords/v6">
    <ns1:adGroupEstimates>
     <ns1:id>-1</ns1:id>
     <ns1:keywordEstimates>
      <ns1:id>-1</ns1:id>
      <ns1:lowerAvgPosition>7.0</ns1:lowerAvgPosition>
      <ns1:lowerClicksPerDay>170.28946</ns1:lowerClicksPerDay>
      <ns1:lowerCpc>596882</ns1:lowerCpc>
      <ns1:upperAvgPosition>10.0</ns1:upperAvgPosition>
      <ns1:upperClicksPerDay>487.06738</ns1:upperClicksPerDay>
      <ns1:upperCpc>1000000</ns1:upperCpc>
     </ns1:keywordEstimates>
     <ns1:keywordEstimates>
      <ns1:id>-1</ns1:id>
      <ns1:lowerAvgPosition>7.0</ns1:lowerAvgPosition>
      <ns1:lowerClicksPerDay>133.294</ns1:lowerClicksPerDay>
      <ns1:lowerCpc>1702</ns1:lowerCpc>
      <ns1:upperAvgPosition>10.0</ns1:upperAvgPosition>
      <ns1:upperClicksPerDay>215.20482</ns1:upperClicksPerDay>
      <ns1:upperCpc>646489</ns1:upperCpc>
     </ns1:keywordEstimates>
    </ns1:adGroupEstimates>
    <ns1:id>-1</ns1:id>
   </ns1:estimateCampaignListReturn>
  </estimateCampaignListResponse>
EOF

                $xml = $self->gen_full_response($xml);
                my $env = SOAP::Deserializer->deserialize($xml);
                return $env;
            }
        );

        my $kwreq1
            = Google::Adwords::KeywordRequest->new->text('web marketing')
            ->type('Broad')->maxCpc(1000000);

        my $kwreq2 = Google::Adwords::KeywordRequest->new->text(
            'marketing analytics')->maxCpc(1000000)->type('Broad');

        my $adgroup_request1
            = Google::Adwords::AdGroupRequest->new->maxCpc(50000000)
            ->keywordRequests( $kwreq1, $kwreq2 );

        my $cmpgreq1 = Google::Adwords::CampaignRequest->new->geoTargeting(
            { cities => ['Pelican, AK US'] } )
            ->languageTargeting( { languages => [ 'fr', 'en' ] } )
            ->adGroupRequests($adgroup_request1);

        my @estimates = $self->{obj}->estimateCampaignList($cmpgreq1);

        ok( ref $estimates[0] eq 'Google::Adwords::CampaignEstimate',
            'estimateCampaignList' );

        my $adgroup_estimate = $estimates[0]->adGroupEstimates->[0];
        ok( ref $adgroup_estimate eq 'Google::Adwords::AdGroupEstimate',
            'estimateCampaignList' );

        ok( scalar @{ $adgroup_estimate->keywordEstimates } == 2,
            'estimateCampaignList' );

        ok( $adgroup_estimate->keywordEstimates->[1]->upperCpc == 646489,
            'estimateCampaignList' );
    }

} # end sub estimateCampaignList :

sub estimateKeywordList : Test(no_plan)
{
    my $self = shift;

    $sub_name = ( caller 0 )[3];
    $sub_name =~ s/^.+:://;
    if ( not $tests{$sub_name} ) {
        return;
    }

    if ( $self->{sandbox} ) {

        my $kwreq1
            = Google::Adwords::KeywordRequest->new->text('web marketing')
            ->type('Broad')->maxCpc(1000000);

        my $kwreq2 = Google::Adwords::KeywordRequest->new->text(
            'marketing analytics')->maxCpc(1000000)->type('Broad');

        my @estimates = $self->{obj}->estimateKeywordList( $kwreq1, $kwreq2 );

        ok( scalar @estimates == 2, 'estimateKeywordList' );
        ok( ref $estimates[0] eq 'Google::Adwords::KeywordEstimate',
            'estimateKeywordList' );

    } # end if ( $self->{sandbox} )
    else {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock(
            call => sub {
                my $xml .= <<'EOF';
  <estimateKeywordListResponse xmlns="">
   <ns1:estimateKeywordListReturn
xmlns:ns1="https://adwords.google.com/api/adwords/v6">
    <ns1:id>-1</ns1:id>
    <ns1:lowerAvgPosition>7.0</ns1:lowerAvgPosition>
    <ns1:lowerClicksPerDay>21.138144</ns1:lowerClicksPerDay>
    <ns1:lowerCpc>88252</ns1:lowerCpc>
    <ns1:upperAvgPosition>10.0</ns1:upperAvgPosition>
    <ns1:upperClicksPerDay>164.97499</ns1:upperClicksPerDay>
    <ns1:upperCpc>833808</ns1:upperCpc>
   </ns1:estimateKeywordListReturn>
   <ns2:estimateKeywordListReturn
xmlns:ns2="https://adwords.google.com/api/adwords/v6">
    <ns2:id>-1</ns2:id>
    <ns2:lowerAvgPosition>4.0</ns2:lowerAvgPosition>
    <ns2:lowerClicksPerDay>5.484253</ns2:lowerClicksPerDay>
    <ns2:lowerCpc>173790</ns2:lowerCpc>
    <ns2:upperAvgPosition>6.0</ns2:upperAvgPosition>
    <ns2:upperClicksPerDay>552.3098</ns2:upperClicksPerDay>
    <ns2:upperCpc>866139</ns2:upperCpc>
   </ns2:estimateKeywordListReturn>
  </estimateKeywordListResponse>
EOF

                $xml = $self->gen_full_response($xml);
                my $env = SOAP::Deserializer->deserialize($xml);
                return $env;
            }
        );

        my $kwreq1
            = Google::Adwords::KeywordRequest->new->text('web marketing')
            ->type('Broad')->maxCpc(1000000);

        my $kwreq2 = Google::Adwords::KeywordRequest->new->text(
            'marketing analytics')->maxCpc(1000000)->type('Broad');

        my @estimates = $self->{obj}->estimateKeywordList( $kwreq1, $kwreq2 );

        ok( scalar @estimates == 2, 'estimateKeywordList' );
        ok( ref $estimates[0] eq 'Google::Adwords::KeywordEstimate',
            'estimateKeywordList' );
        ok( $estimates[0]->lowerClicksPerDay eq '21.138144',
            'estimateKeywordList' );
    }

} # end sub estimateKeywordList :

1;

