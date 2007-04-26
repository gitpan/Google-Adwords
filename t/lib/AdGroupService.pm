package AdGroupService;
use base qw/ Service /;

use Test::More;
use Test::MockModule;
use Google::Adwords::AdGroup;

sub test_class { return "Google::Adwords::AdGroupService"; }

# tests to be run
my %tests = (
    addAdGroup        => 1,
    addAdGroupList    => 1,
    getAdGroup        => 1,
    getAdGroupList    => 1,
    getAdGroupStats   => 1,
    getAllAdGroups    => 1,
    updateAdGroup     => 1,
    updateAdGroupList => 1,
);

sub addAdGroup : Test(no_plan)
{
    my $self = shift;

    $sub_name = ( caller 0 )[3];
    $sub_name =~ s/^.+:://;
    if ( not $tests{$sub_name} ) {
        return;
    }

    if ( $self->{sandbox} ) {

        my $adgroup = Google::Adwords::AdGroup->new();
        $adgroup->maxCpc(100000);
        my $campaign_id = $self->_get_campaign_id();
        if ( not defined $campaign_id ) {
            diag("addCampaign was not called");
            return;
        }
        my $adgroup_response
            = $self->{obj}->addAdGroup( $campaign_id, $adgroup );
        ok(
            $adgroup_response->campaignId == $campaign_id,
            'addAdGroup id: ' . $adgroup_response->id
        );

        # save for further use
        $self->{_adgroup_id} = $adgroup_response->id;

        # save for further module tests
        $self->_set_adgroup_id( $adgroup_response->id );

    } # end if ( $self->{sandbox} )
    else {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock(
            call => sub {
                my $xml .= <<'EOF';
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
EOF

                $xml = $self->gen_full_response($xml);
                my $env = SOAP::Deserializer->deserialize($xml);
                return $env;
            }
        );

        my $adgroup = Google::Adwords::AdGroup->new();
        $adgroup->maxCpc(100000);
        my $campaign_id = 4937;

        my $adgroup_response
            = $self->{obj}->addAdGroup( $campaign_id, $adgroup );
        ok( $adgroup_response->campaignId == 4937, 'addAdGroup' );

        # check that we got the response headers
        ok( $self->{obj}->requestId eq 'f7912565442e4adeb1bf30cbbf2f8fd2',
            'Response header (requestId)' );
        ok(
            $self->{obj}->responseTime == 39,
            'Response header (responseTime)'
        );
        ok( $self->{obj}->operations == 1, 'Response header (operations)' );
        ok( $self->{obj}->units == 1,      'Response header (units)' );

    }

} # end sub addAdGroup :

sub addAdGroupList : Test(no_plan)
{
    my $self = shift;

    $sub_name = ( caller 0 )[3];
    $sub_name =~ s/^.+:://;
    if ( not $tests{$sub_name} ) {
        return;
    }

    if ( $self->{sandbox} ) {

        my $campaign_id = $self->_get_campaign_id();
        if ( not defined $campaign_id ) {
            diag("addCampaign was not called");
            return;
        }

        my @adgroups_to_add;

        my $adgroup1 = Google::Adwords::AdGroup->new;
        $adgroup1->maxCpc(300000);
        my $adgroup2 = Google::Adwords::AdGroup->new;
        $adgroup2->maxCpc(400000);

        push @adgroups_to_add, $adgroup1, $adgroup2;

        my @new_adgroups
            = $self->{obj}->addAdGroupList( $campaign_id, \@adgroups_to_add );

        ok( $new_adgroups[0]->campaignId == $campaign_id, 'addAdGroupList' );
        ok( $new_adgroups[1]->campaignId == $campaign_id, 'addAdGroupList' );
        ok( $new_adgroups[0]->id =~ /\d+/,
            'addAdGroupList id: ' . $new_adgroups[0]->id );
        ok( $new_adgroups[1]->id =~ /\d+/,
            'addAdGroupList id: ' . $new_adgroups[1]->id );

        # save for further use
        $self->{_adgroup_id_0} = $new_adgroups[0]->id;
        $self->{_adgroup_id_1} = $new_adgroups[1]->id;
    } # end if ( $self->{sandbox} )
    else {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock(
            call => sub {
                my $xml .= <<'EOF';
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
EOF

                $xml = $self->gen_full_response($xml);
                my $env = SOAP::Deserializer->deserialize($xml);
                return $env;
            }
        );

        my $campaign_id = 4937;
        my @adgroups_to_add;

        my $adgroup1 = Google::Adwords::AdGroup->new;
        $adgroup1->maxCpc(300000);
        my $adgroup2 = Google::Adwords::AdGroup->new;
        $adgroup2->maxCpc(400000);

        push @adgroups_to_add, $adgroup1, $adgroup2;

        my @new_adgroups
            = $self->{obj}->addAdGroupList( $campaign_id, \@adgroups_to_add );

        ok( $new_adgroups[0]->campaignId == 4937, 'addAdGroupList' );
        ok( $new_adgroups[1]->campaignId == 4937, 'addAdGroupList' );

    }

} # end sub addAdGroupList :

sub getAdGroup : Test(no_plan)
{
    my $self = shift;

    $sub_name = ( caller 0 )[3];
    $sub_name =~ s/^.+:://;
    if ( not $tests{$sub_name} ) {
        return;
    }

    if ( $self->{sandbox} ) {

        my $adgroup = $self->{obj}->getAdGroup( $self->{_adgroup_id} );

        ok( $adgroup->campaignId == $self->_get_campaign_id(), 'getAdGroup' );
        ok( $adgroup->id == $self->{_adgroup_id}, 'getAdGroup' );
    }
    else {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock(
            call => sub {
                my $xml .= <<'EOF';
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
EOF

                $xml = $self->gen_full_response($xml);
                my $env = SOAP::Deserializer->deserialize($xml);
                return $env;
            }
        );

        my $adgroup = $self->{obj}->getAdGroup(200507);

        ok( $adgroup->campaignId == 4937, 'getAdGroup' );
        ok( $adgroup->id == 200507,       'getAdGroup' );

    }

} # end sub getAdGroup :

sub getAdGroupList : Test(no_plan)
{
    my $self = shift;

    $sub_name = ( caller 0 )[3];
    $sub_name =~ s/^.+:://;
    if ( not $tests{$sub_name} ) {
        return;
    }

    if ( $self->{sandbox} ) {

        my @adgroup_ids = ( $self->{_adgroup_id_0}, $self->{_adgroup_id_1}, );
        my @adgroups = $self->{obj}->getAdGroupList(@adgroup_ids);

        ok( $adgroups[0]->id == $self->{_adgroup_id_0}, 'getAdGroupList' );
        ok( $adgroups[1]->id == $self->{_adgroup_id_1}, 'getAdGroupList' );
    }
    else {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock(
            call => sub {
                my $xml .= <<'EOF';
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
EOF

                $xml = $self->gen_full_response($xml);
                my $env = SOAP::Deserializer->deserialize($xml);
                return $env;
            }
        );

        my @adgroups = $self->{obj}->getAdGroupList(qw/200507 200508/);

        ok( $adgroups[0]->id == 200507, 'getAdGroupList' );
        ok( $adgroups[1]->id == 200508, 'getAdGroupList' );

    }

} # end sub getAdGroupList :

sub getAllAdGroups : Test(no_plan)
{
    my $self = shift;

    $sub_name = ( caller 0 )[3];
    $sub_name =~ s/^.+:://;
    if ( not $tests{$sub_name} ) {
        return;
    }

    if ( $self->{sandbox} ) {

        my @adgroups
            = $self->{obj}->getAllAdGroups( $self->_get_campaign_id );

        # must get three or more
        ok( scalar @adgroups >= 3, 'getAllAdGroups' );
        for (@adgroups) {
            ok( $_->id =~ /\d+/, 'getAllAdGroups id: ' . $_->id );
        }
    }
    else {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock(
            call => sub {
                my $xml .= <<'EOF';
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
EOF

                $xml = $self->gen_full_response($xml);
                my $env = SOAP::Deserializer->deserialize($xml);
                return $env;
            }
        );

        my @adgroups = $self->{obj}->getAllAdGroups(4937);

        ok( $adgroups[0]->id == 200507, 'getAllAdGroups' );

    }

} # end sub getAllAdGroups :

sub getAdGroupStats : Test(no_plan)
{
    my $self = shift;

    $sub_name = ( caller 0 )[3];
    $sub_name =~ s/^.+:://;
    if ( not $tests{$sub_name} ) {
        return;
    }

    if ( $self->{sandbox} ) {

        my $campaign_id = $self->_get_campaign_id;
        if ( not defined $campaign_id ) {
            diag("addCampaign was not called");
            return;
        }

        my @stats = $self->{obj}->getAdGroupStats(
            {
                campaignId => $campaign_id,
                adGroupIds =>
                    [ $self->{_adgroup_id_0}, $self->{_adgroup_id_1}, ],
                startDay => '2006-12-01',
                endDay   => '2006-12-15',
                inPST    => 1,
            }
        );

        ok( $stats[0]->id == $self->{_adgroup_id_0}, 'getAdGroupStats' );
        ok( $stats[1]->id == $self->{_adgroup_id_1}, 'getAdGroupStats' );

    } # end if ( $self->{sandbox} )
    else {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock(
            call => sub {
                my $xml .= <<'EOF';
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
EOF

                $xml = $self->gen_full_response($xml);
                my $env = SOAP::Deserializer->deserialize($xml);
                return $env;
            }
        );

        my $campaign_id = 1004;

        my @stats = $self->{obj}->getAdGroupStats(
            {
                campaignId => $campaign_id,
                adGroupIds => [ 1001, 1002 ],
                startDay   => '2006-09-01',
                endDay     => '2006-09-15',
                inPST      => 1,
            }
        );

        ok( $stats[0]->id == 1001,   'getAdGroupStats' );
        ok( $stats[0]->clicks == 10, 'getAdGroupStats' );
        ok( $stats[1]->id == 1002,   'getAdGroupStats' );

    }

} # end sub getAdGroupStats :

sub updateAdGroup : Test(no_plan)
{
    my $self = shift;

    $sub_name = ( caller 0 )[3];
    $sub_name =~ s/^.+:://;
    if ( not $tests{$sub_name} ) {
        return;
    }

    if ( $self->{sandbox} ) {

        my $adgroup = Google::Adwords::AdGroup->new;
        $adgroup->id( $self->{_adgroup_id} );
        $adgroup->maxCpc(5000000);

        my $ret = $self->{obj}->updateAdGroup($adgroup);

        ok( $ret == 1, 'updateAdGroup' );

    }
    else {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock(
            call => sub {
                my $xml .= <<'EOF';
    <updateAdGroupResponse xmlns=""/>
EOF

                $xml = $self->gen_full_response($xml);
                my $env = SOAP::Deserializer->deserialize($xml);
                return $env;
            }
        );

        my $adgroup = Google::Adwords::AdGroup->new;
        $adgroup->id(1001);
        $adgroup->maxCpc(5000000);

        my $ret = $self->{obj}->updateAdGroup($adgroup);

        ok( $ret == 1, 'updateAdGroup' );

    }

} # end sub updateAdGroup :

sub updateAdGroupList : Test(no_plan)
{
    my $self = shift;

    $sub_name = ( caller 0 )[3];
    $sub_name =~ s/^.+:://;
    if ( not $tests{$sub_name} ) {
        return;
    }

    if ( $self->{sandbox} ) {

        my $adgroup1 = Google::Adwords::AdGroup->new;
        $adgroup1->id( $self->{_adgroup_id_0} );
        $adgroup1->maxCpc(5000000);
        my $adgroup2 = Google::Adwords::AdGroup->new;
        $adgroup2->id( $self->{_adgroup_id_1} );
        $adgroup2->maxCpc(5000000);

        my @adgroups;
        push @adgroups, $adgroup1, $adgroup2;

        my $ret = $self->{obj}->updateAdGroupList(@adgroups);

        ok( $ret == 1, 'updateAdGroupList' );

    } # end if ( $self->{sandbox} )
    else {

        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock(
            call => sub {
                my $xml .= <<'EOF';
    <updateAdGroupListResponse xmlns=""/>
EOF

                $xml = $self->gen_full_response($xml);
                my $env = SOAP::Deserializer->deserialize($xml);
                return $env;
            }
        );

        my $adgroup1 = Google::Adwords::AdGroup->new;
        $adgroup1->id(1001);
        $adgroup1->maxCpc(5000000);
        my $adgroup2 = Google::Adwords::AdGroup->new;
        $adgroup2->id(1002);
        $adgroup2->maxCpc(5000000);

        my @adgroups;
        push @adgroups, $adgroup1, $adgroup2;

        my $ret = $self->{obj}->updateAdGroupList(@adgroups);

        ok( $ret == 1, 'updateAdGroupList' );

    }

} # end sub updateAdGroupList :

1;

