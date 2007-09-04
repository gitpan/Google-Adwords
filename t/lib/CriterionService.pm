package CriterionService;
use base qw/ Service /;

use Test::More;
use Test::MockModule;

use Google::Adwords::Criterion;

sub test_class { return "Google::Adwords::CriterionService"; }

# tests to run
my %tests = (
    addCriteria                 => 1,
    getAllCriteria              => 1,
    getCampaignNegativeCriteria => 0,
    getCriteria                 => 1,
    getCriterionStats           => 1,
    setCampaignNegativeCriteria => 0,
    updateCriteria              => 1,
);

sub start_of_each_test : Test(setup)
{
    my $self = shift;

    # set debug to whatever was passed in as param
    $self->{obj}->debug( $self->{debug} );
}

sub addCriteria : Test(no_plan)
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

        my $adgroup_id = $self->_get_adgroup_id();

        #$adgroup_id = 3457;

        my $criterion1 = Google::Adwords::Criterion->new;
        $criterion1->adGroupId($adgroup_id);
        $criterion1->criterionType('Keyword');
        $criterion1->type('Broad');
        $criterion1->text('Aarohan & Technologies');

        my $criterion2 = Google::Adwords::Criterion->new;
        $criterion2->adGroupId($adgroup_id);
        $criterion2->criterionType('Keyword');
        $criterion2->type('Broad');
        $criterion2->text('Google Adwords Perl');

        my @criterions_response
            = $self->{obj}->addCriteria( $criterion1, $criterion2 );

        ok( scalar @criterions_response == 2, 'addCriteria' );
        ok( $criterions_response[0]->id =~ /\d+/,
            'addCriteria id: ' . $criterions_response[0]->id );
        ok( $criterions_response[1]->id =~ /\d+/,
            'addCriteria id: ' . $criterions_response[1]->id );

        # save criterion id for further use
        $self->{_criterion_id_0} = $criterions_response[0]->id;
        $self->{_criterion_id_1} = $criterions_response[1]->id;
    } # end if ( $self->{sandbox} ...
    else
    {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock(
            call => sub {
                my $xml .= <<'EOF';
<addCriteriaResponse xmlns="">
   <ns1:addCriteriaReturn xsi:type="ns1:Keyword"
xmlns:ns1="https://adwords.google.com/api/adwords/v7">
    <ns1:adGroupId>4863</ns1:adGroupId>
    <ns1:criterionType>Keyword</ns1:criterionType>
    <ns1:destinationUrl xsi:nil="true"/>
    <ns1:id>10028530</ns1:id>
    <ns1:language></ns1:language>
    <ns1:negative>false</ns1:negative>
    <ns1:paused>false</ns1:paused>
    <ns1:status>Normal</ns1:status>
    <ns1:maxCpc>0</ns1:maxCpc>
    <ns1:minCpc>440000</ns1:minCpc>
    <ns1:text>Aarohan &amp; Technologies</ns1:text>
    <ns1:type>Broad</ns1:type>
   </ns1:addCriteriaReturn>
   <ns2:addCriteriaReturn xsi:type="ns2:Keyword"
xmlns:ns2="https://adwords.google.com/api/adwords/v7">
    <ns2:adGroupId>4863</ns2:adGroupId>
    <ns2:criterionType>Keyword</ns2:criterionType>
    <ns2:destinationUrl xsi:nil="true"/>
    <ns2:id>10028531</ns2:id>
    <ns2:language></ns2:language>
    <ns2:negative>false</ns2:negative>
    <ns2:paused>false</ns2:paused>
    <ns2:status>Normal</ns2:status>
    <ns2:maxCpc>0</ns2:maxCpc>
    <ns2:minCpc>440000</ns2:minCpc>
    <ns2:text>Google Adwords Perl</ns2:text>
    <ns2:type>Broad</ns2:type>
   </ns2:addCriteriaReturn>
  </addCriteriaResponse>
EOF

                $xml = $self->gen_full_response($xml);
                my $env = SOAP::Deserializer->deserialize($xml);
                return $env;
            }
        );

        my $adgroup_id = 4863;

        my $criterion1 = Google::Adwords::Criterion->new;
        $criterion1->adGroupId($adgroup_id);
        $criterion1->criterionType('Keyword');
        $criterion1->type('Broad');
        $criterion1->text('Aarohan & Technologies');

        my $criterion2 = Google::Adwords::Criterion->new;
        $criterion2->adGroupId($adgroup_id);
        $criterion2->criterionType('Keyword');
        $criterion2->type('Broad');
        $criterion2->text('Google Adwords Perl');

        my @criterions_response
            = $self->{obj}->addCriteria( $criterion1, $criterion2 );

        ok( scalar @criterions_response == 2, 'addCriteria' );
        ok( $criterions_response[0]->id =~ /\d+/,
            'addCriteria id: ' . $criterions_response[0]->id );
        ok( $criterions_response[1]->id =~ /\d+/,
            'addCriteria id: ' . $criterions_response[1]->id );

    }

} # end sub addCriteria :

sub getAllCriteria : Test(no_plan)
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

        my $adgroup_id = $self->_get_adgroup_id();

        my @criterions = $self->{obj}->getAllCriteria($adgroup_id);

        for (@criterions)
        {
            ok( $_->id =~ /\d+/, 'getAllCriteria id: ' . $_->id );
        }

    }
    else
    {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock(
            call => sub {
                my $xml .= <<'EOF';
<getAllCriteriaResponse xmlns="">
   <ns1:getAllCriteriaReturn xsi:type="ns1:Keyword"
xmlns:ns1="https://adwords.google.com/api/adwords/v7">
    <ns1:adGroupId>4863</ns1:adGroupId>
    <ns1:criterionType>Keyword</ns1:criterionType>
    <ns1:destinationUrl xsi:nil="true"/>
    <ns1:id>10028530</ns1:id>
    <ns1:language></ns1:language>
    <ns1:negative>false</ns1:negative>
    <ns1:paused>false</ns1:paused>
    <ns1:status>Normal</ns1:status>
    <ns1:maxCpc>0</ns1:maxCpc>
    <ns1:minCpc>440000</ns1:minCpc>
    <ns1:text>Aarohan Technologies</ns1:text>
    <ns1:type>Broad</ns1:type>
   </ns1:getAllCriteriaReturn>
   <ns2:getAllCriteriaReturn xsi:type="ns2:Keyword"
xmlns:ns2="https://adwords.google.com/api/adwords/v7">
    <ns2:adGroupId>4863</ns2:adGroupId>
    <ns2:criterionType>Keyword</ns2:criterionType>
    <ns2:destinationUrl xsi:nil="true"/>
    <ns2:id>10028531</ns2:id>
    <ns2:language></ns2:language>
    <ns2:negative>false</ns2:negative>
    <ns2:paused>false</ns2:paused>
    <ns2:status>Normal</ns2:status>
    <ns2:maxCpc>0</ns2:maxCpc>
    <ns2:minCpc>440000</ns2:minCpc>
    <ns2:text>Google Adwords Perl</ns2:text>
    <ns2:type>Broad</ns2:type>
   </ns2:getAllCriteriaReturn>
  </getAllCriteriaResponse>
EOF

                $xml = $self->gen_full_response($xml);
                my $env = SOAP::Deserializer->deserialize($xml);
                return $env;
            }
        );

        my $adgroup_id = 4863;

        my @criterions = $self->{obj}->getAllCriteria($adgroup_id);

        for (@criterions)
        {
            ok( $_->id =~ /\d+/, 'getAllCriteria id: ' . $_->id );
        }

    }

} # end sub getAllCriteria :

sub getCampaignNegativeCriteria : Test(no_plan)
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

        my $campaign_id = $self->_get_campaign_id();

        my @criterions
            = $self->{obj}->getCampaignNegativeCriteria($campaign_id);

        for (@criterions)
        {
            ok( $_->id =~ /\d+/,
                'getCampaignNegativeCriteria id: ' . $_->id );
        }

    } # end if ( $self->{sandbox} ...
    else
    {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock(
            call => sub {
                my $xml .= <<'EOF';
    <getCampaignNegativeCriteriaResponse xmlns=""/>
EOF

                $xml = $self->gen_full_response($xml);
                my $env = SOAP::Deserializer->deserialize($xml);
                return $env;
            }
        );

        my $campaign_id = 1874;

        my @criterions
            = $self->{obj}->getCampaignNegativeCriteria($campaign_id);

        for (@criterions)
        {
            ok( $_->id =~ /\d+/,
                'getCampaignNegativeCriteria id: ' . $_->id );
        }

    }

} # end sub getCampaignNegativeCriteria :

sub getCriteria : Test(no_plan)
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

        my $adgroup_id = $self->_get_adgroup_id();
        my $criterion_ids
            = [ $self->{_criterion_id_0}, $self->{_criterion_id_1}, ];

        my @criterions
            = $self->{obj}->getCriteria( $adgroup_id, $criterion_ids );

        for (@criterions)
        {
            ok( $_->id =~ /\d+/, 'getCriteria id: ' . $_->id );
        }

    } # end if ( $self->{sandbox} ...
    else
    {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock(
            call => sub {
                my $xml .= <<'EOF';
<getCriteriaResponse xmlns="">
   <ns1:getCriteriaReturn xsi:type="ns1:Keyword"
xmlns:ns1="https://adwords.google.com/api/adwords/v7">
    <ns1:adGroupId>4863</ns1:adGroupId>
    <ns1:criterionType>Keyword</ns1:criterionType>
    <ns1:destinationUrl xsi:nil="true"/>
    <ns1:id>10028530</ns1:id>
    <ns1:language></ns1:language>
    <ns1:negative>false</ns1:negative>
    <ns1:paused>false</ns1:paused>
    <ns1:status>Normal</ns1:status>
    <ns1:maxCpc>0</ns1:maxCpc>
    <ns1:minCpc>440000</ns1:minCpc>
    <ns1:text>Aarohan Technologies</ns1:text>
    <ns1:type>Broad</ns1:type>
   </ns1:getCriteriaReturn>
   <ns2:getCriteriaReturn xsi:type="ns2:Keyword"
xmlns:ns2="https://adwords.google.com/api/adwords/v7">
    <ns2:adGroupId>4863</ns2:adGroupId>
    <ns2:criterionType>Keyword</ns2:criterionType>
    <ns2:destinationUrl xsi:nil="true"/>
    <ns2:id>10028531</ns2:id>
    <ns2:language></ns2:language>
    <ns2:negative>false</ns2:negative>
    <ns2:paused>false</ns2:paused>
    <ns2:status>Normal</ns2:status>
    <ns2:maxCpc>0</ns2:maxCpc>
    <ns2:minCpc>440000</ns2:minCpc>
    <ns2:text>Google Adwords Perl</ns2:text>
    <ns2:type>Broad</ns2:type>
   </ns2:getCriteriaReturn>
  </getCriteriaResponse>
EOF

                $xml = $self->gen_full_response($xml);
                my $env = SOAP::Deserializer->deserialize($xml);
                return $env;
            }
        );

        my $adgroup_id = 4863;
        my $criterion_ids = [ 10028531, 10028530, ];

        my @criterions
            = $self->{obj}->getCriteria( $adgroup_id, $criterion_ids );

        for (@criterions)
        {
            ok( $_->id =~ /\d+/, 'getCriteria id: ' . $_->id );
        }

    }

} # end sub getCriteria :

sub getCriterionStats : Test(no_plan)
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

        my $adgroup_id = $self->_get_adgroup_id();
        my $criterion_ids
            = [ $self->{_criterion_id_0}, $self->{_criterion_id_1}, ];

        my @stats = $self->{obj}->getCriterionStats(
            {
                adGroupId    => $adgroup_id,
                criterionIds => $criterion_ids,
                startDay     => '2007-02-25',
                endDay       => '2007-02-27',
                inPST        => 1,
            }
        );

        for (@stats)
        {
            ok( $_->id =~ /\d+/, 'getCriterionStats id: ' . $_->id );
        }
    } # end if ( $self->{sandbox} ...
    else
    {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock(
            call => sub {
                my $xml .= <<'EOF';
<getCriterionStatsResponse xmlns:ns1="https://adwords.google.com/api/adwords/v7">
    <getCriterionStatsReturn>
    <ns1:averagePosition>0.0</ns1:averagePosition>
    <ns1:clicks>0</ns1:clicks>
    <ns1:conversionRate>0.0</ns1:conversionRate>
    <ns1:conversions>0</ns1:conversions>
    <ns1:cost>0</ns1:cost>
    <ns1:id>4865</ns1:id>
    <ns1:impressions>0</ns1:impressions>
   </getCriterionStatsReturn>
</getCriterionStatsResponse>
EOF

                $xml = $self->gen_full_response($xml);
                my $env = SOAP::Deserializer->deserialize($xml);
                return $env;
            }
        );

        my $adgroup_id = 4863;
        my $criterion_ids = [ 10028531, 10028530, ];

        my @stats = $self->{obj}->getCriterionStats(
            {
                adGroupId    => $adgroup_id,
                criterionIds => $criterion_ids,
                startDay     => '2007-02-25',
                endDay       => '2007-02-27',
                inPST        => 1,
            }
        );

        for (@stats)
        {
            ok( $_->id =~ /\d+/, 'getCriterionStats id: ' . $_->id );
        }
    }

} # end sub getCriterionStats :

sub setCampaignNegativeCriteria : Test(no_plan)
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

        my $adgroup_id  = $self->_get_adgroup_id();
        my $campaign_id = $self->_get_campaign_id();

        my $criterion1 = Google::Adwords::Criterion->new;
        $criterion1->adGroupId($adgroup_id);
        $criterion1->criterionType('Keyword');
        $criterion1->type('Broad');
        $criterion1->text('Aarohan Technologies');

        my $criterion2 = Google::Adwords::Criterion->new;
        $criterion2->adGroupId($adgroup_id);
        $criterion2->criterionType('Keyword');
        $criterion2->type('Broad');
        $criterion2->text('Google Adwords Perl');

        my $ret = $self->{obj}->setCampaignNegativeCriteria( $campaign_id,
            [ $criterion1, $criterion2, ],
        );

        ok( $ret == 1, 'setCampaignNegativeCriteria' );
    } # end if ( $self->{sandbox} ...
    else
    {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock(
            call => sub {
                my $xml .= <<'EOF';
    <setCampaignNegativeCriteriaResponse xmlns=""/>
EOF

                $xml = $self->gen_full_response($xml);
                my $env = SOAP::Deserializer->deserialize($xml);
                return $env;
            }
        );

        my $adgroup_id  = 4728;
        my $campaign_id = 1874;

        my $criterion1 = Google::Adwords::Criterion->new;
        $criterion1->adGroupId($adgroup_id);
        $criterion1->criterionType('Keyword');
        $criterion1->type('Broad');
        $criterion1->text('Aarohan Technologies');

        my $criterion2 = Google::Adwords::Criterion->new;
        $criterion2->adGroupId($adgroup_id);
        $criterion2->criterionType('Keyword');
        $criterion2->type('Broad');
        $criterion2->text('Google Adwords Perl');

        my $ret = $self->{obj}->setCampaignNegativeCriteria( $campaign_id,
            [ $criterion1, $criterion2, ],
        );

        ok( $ret == 1, 'setCampaignNegativeCriteria' );

    }

} # end sub setCampaignNegativeCriteria :

sub updateCriteria : Test(no_plan)
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

        my $adgroup_id = $self->_get_adgroup_id();

        my $criterion1 = Google::Adwords::Criterion->new;
        $criterion1->id( $self->{_criterion_id_0} );
        $criterion1->adGroupId($adgroup_id);
        $criterion1->criterionType('Keyword');
        $criterion1->type('Broad');
        $criterion1->text('Aarohan Technologies');

        my $criterion2 = Google::Adwords::Criterion->new;
        $criterion2->id( $self->{_criterion_id_1} );
        $criterion2->adGroupId($adgroup_id);
        $criterion2->criterionType('Keyword');
        $criterion2->type('Broad');
        $criterion2->text('Google Adwords Perl');

        my $ret = $self->{obj}->updateCriteria( $criterion1, $criterion2 );

        ok( $ret == 1, 'updateCriteria' );
    } # end if ( $self->{sandbox} ...
    else
    {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock(
            call => sub {
                my $xml .= <<'EOF';
    <updateCriteriaResponse xmlns=""/>
EOF

                $xml = $self->gen_full_response($xml);
                my $env = SOAP::Deserializer->deserialize($xml);
                return $env;
            }
        );

        my $adgroup_id = 4863;

        my $criterion1 = Google::Adwords::Criterion->new;
        $criterion1->id(11111);
        $criterion1->adGroupId($adgroup_id);
        $criterion1->criterionType('Keyword');
        $criterion1->type('Broad');
        $criterion1->text('Aarohan Technologies');

        my $criterion2 = Google::Adwords::Criterion->new;
        $criterion2->id(22222);
        $criterion2->adGroupId($adgroup_id);
        $criterion2->criterionType('Keyword');
        $criterion2->type('Broad');
        $criterion2->text('Google Adwords Perl');

        my $ret = $self->{obj}->updateCriteria( $criterion1, $criterion2 );

        ok( $ret == 1, 'updateCriteria' );

    }

} # end sub updateCriteria :

1;

