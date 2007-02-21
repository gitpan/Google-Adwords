package InfoService;
use base qw/ Service /;

use Test::More;
use Test::MockModule;

sub test_class { return "Google::Adwords::InfoService"; }

# which tests should be run
my %tests = (
    getFreeUsageQuotaThisMonth  => 1,
    getMethodCost               => 1,
    getOperationCount           => 1,
    getUnitCount                => 1,
    getUnitCountForClients      => 1,
    getUnitCountForMethod       => 1,
    getUsageQuotaThisMonth      => 1,
);

sub start_of_each_test : Test(setup)
{
    my $self = shift;

    # set debug to whatever was passed in as param
    $self->{obj}->debug($self->{debug});
}

sub getUsageQuotaThisMonth : Test(1)
{
    my $self = shift;
    
    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }

    if ($self->{'sandbox'}) {

        my $expected = '9223372036854775807';
        my $got = $self->{'obj'}->getUsageQuotaThisMonth();
        is ($got, $expected, 'getUsageQuotaThisMonth');
    }
    else {

    my $soap = Test::MockModule->new('SOAP::Lite');
    $soap->mock( call => sub {
        my $xml .= <<'EOF';
  <getUsageQuotaThisMonthResponse xmlns="">
   <ns1:getUsageQuotaThisMonthReturn xmlns:ns1="https://adwords.google.com/api/adwords/v6">9223372036854775</ns1:getUsageQuotaThisMonthReturn>
  </getUsageQuotaThisMonthResponse>
EOF

        my $full_xml = $self->gen_full_response($xml);
        my $env = SOAP::Deserializer->deserialize($full_xml);
        return $env;
    });

    my $expected = '9223372036854775';
    my $got = $self->{'obj'}->getUsageQuotaThisMonth();
    is ($got, $expected, 'getUsageQuotaThisMonth');

    }
}

sub getFreeUsageQuotaThisMonth : Test(1)
{
    my $self = shift;

    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }

    if ($self->{'sandbox'}) {
        my $expected = '9223372036854775807';
        my $got = $self->{'obj'}->getFreeUsageQuotaThisMonth();
        is ($got, $expected, 'getFreeUsageQuotaThisMonth');
    }
    else {

    my $soap = Test::MockModule->new('SOAP::Lite');
    $soap->mock( call => sub {
        my $method_xml .= <<'EOF';
  <getFreeUsageQuotaThisMonthResponse xmlns="">
   <ns1:getFreeUsageQuotaThisMonthReturn xmlns:ns1="https://adwords.google.com/api/adwords/v6">9223372036854775</ns1:getFreeUsageQuotaThisMonthReturn>
  </getFreeUsageQuotaThisMonthResponse>
EOF
        my $full_xml = $self->gen_full_response($method_xml);
        my $env = SOAP::Deserializer->deserialize($full_xml);
        return $env;
    });

    my $expected = '9223372036854775';
    my $got = $self->{'obj'}->getFreeUsageQuotaThisMonth();
    is ($got, $expected, 'getFreeUsageQuotaThisMonth');

    }
}

sub getMethodCost : Test(1)
{
    my $self = shift;


    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }

    if ($self->{'sandbox'}) {
        my $expected = '1';
        my $got = $self->{'obj'}->getMethodCost({
            service => 'InfoService',
            method => 'getMethodCost',
            date => '2006-08-02',
        });
        is ($got, $expected, 'getMethodCost');
    }
    else {

    my $soap = Test::MockModule->new('SOAP::Lite');
    $soap->mock( call => sub {
        my $xml .= <<'EOF';
  <getMethodCostResponse xmlns="">
   <ns1:getMethodCostReturn xmlns:ns1="https://adwords.google.com/api/adwords/v6">1</ns1:getMethodCostReturn>
  </getMethodCostResponse>
EOF

        my $full_xml = $self->gen_full_response($xml);
        my $env = SOAP::Deserializer->deserialize($full_xml);
        return $env;
    });

    my $expected = 1;
    my $got = $self->{'obj'}->getMethodCost({
        service => 'InfoService',
        method => 'getMethodCost',
        date => '2006-08-02T00:00:00',
    });
    ok ($got == $expected, 'getMethodCost');
    }
}

sub getOperationCount : Test(1)
{
    my $self = shift;


    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }

    if ($self->{'sandbox'}) {
        my $expected = '0';
        my $got = $self->{'obj'}->getOperationCount({
            startDate => '2006-08-02',
            endDate => '2006-08-12',
        });
        is ($got, $expected, 'getOperationCount');
    }
    else {

    my $soap = Test::MockModule->new('SOAP::Lite');
    $soap->mock( call => sub {
        my $xml .= <<'EOF';
  <getOperationCountResponse xmlns="">
   <ns1:getOperationCountReturn xmlns:ns1="https://adwords.google.com/api/adwords/v6">0</ns1:getOperationCountReturn>
  </getOperationCountResponse>
EOF

        my $full_xml = $self->gen_full_response($xml);
        my $env = SOAP::Deserializer->deserialize($full_xml);
        return $env;
    });

    my $expected = 0;
        my $got = $self->{'obj'}->getOperationCount({
            startDate => '2006-08-02T00:00:00',
            endDate => '2006-08-12T00:00:00',
        });
    ok ($got == $expected, 'getOperationCount');
    }
}

sub getUnitCount : Test(1)
{
    my $self = shift;


    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }

    if ($self->{'sandbox'}) {
        my $expected = '0';
        my $got = $self->{'obj'}->getUnitCount({
            startDate => '2006-08-02',
            endDate => '2006-08-12',
        });
        is ($got, $expected, 'getUnitCount');
    }
    else {

    my $soap = Test::MockModule->new('SOAP::Lite');
    $soap->mock( call => sub {
        my $xml .= <<'EOF';
  <getUnitCountResponse xmlns="">
   <ns1:getUnitCountReturn xmlns:ns1="https://adwords.google.com/api/adwords/v6">0</ns1:getUnitCountReturn>
  </getUnitCountResponse>
EOF

        $xml = $self->gen_full_response($xml);
        my $env = SOAP::Deserializer->deserialize($xml);
        return $env;
    });

    my $expected = 0;
        my $got = $self->{'obj'}->getUnitCount({
            startDate => '2006-08-02T00:00:00',
            endDate => '2006-08-12T00:00:00',
        });
    ok ($got == $expected, 'getUnitCount');
    }
}

sub getUnitCountForMethod : Test(1)
{
    my $self = shift;


    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }

    if ($self->{'sandbox'}) {
        my $expected = '0';
        my $got = $self->{'obj'}->getUnitCountForMethod({
            service => 'InfoService',
            method => 'getUnitCountForMethod',
            startDate => '2006-08-02',
            endDate => '2006-08-12',
        });
        is ($got, $expected, 'getUnitCountForMethod');
    }
    else {

    my $soap = Test::MockModule->new('SOAP::Lite');
    $soap->mock( call => sub {
        my $xml .= <<'EOF';
  <getUnitCountForMethodResponse xmlns="">
   <ns1:getUnitCountForMethodReturn xmlns:ns1="https://adwords.google.com/api/adwords/v6">0</ns1:getUnitCountForMethodReturn>
  </getUnitCountForMethodResponse>
EOF

        $xml = $self->gen_full_response($xml);
        my $env = SOAP::Deserializer->deserialize($xml);
        return $env;
    });
        my $expected = '0';
        my $got = $self->{'obj'}->getUnitCountForMethod({
            service => 'InfoService',
            method => 'getUnitCountForMethod',
            startDate => '2006-08-02T00:00:00',
            endDate => '2006-08-12T00:00:00',
        });
        is ($got, $expected, 'getUnitCountForMethod');

    }
}

sub getUnitCountForClients : Test(no_plan)
{
    my ($self) = @_;


    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }

    if ($self->{sandbox}) {

        #$self->{obj}->getUnitCountForClients({
        #    clientEmails => [ 'rohan', 'tohan' ],
        #    startDate => '2006-12-09',
        #    endDate => '2006-12-10',
        #});

        return;
    }
    else {

    my $soap = Test::MockModule->new('SOAP::Lite');
    $soap->mock( call => sub {
        my $xml .= <<'EOF';
  <getUnitCountForClientsResponse xmlns="">
   <ns1:getUnitCountForClientsReturn xmlns:ns1="https://adwords.google.com/api/adwords/v6">
    <clientEmail>email1@domain.com</clientEmail>
    <quotaUnits>10</quotaUnits>
   </ns1:getUnitCountForClientsReturn>
   <ns1:getUnitCountForClientsReturn xmlns:ns1="https://adwords.google.com/api/adwords/v6">
    <clientEmail>email2@domain.com</clientEmail>
    <quotaUnits>10</quotaUnits>
   </ns1:getUnitCountForClientsReturn>
  </getUnitCountForClientsResponse>
EOF

        $xml = $self->gen_full_response($xml);
        my $env = SOAP::Deserializer->deserialize($xml);
        return $env;
    });

        my @usage_records = $self->{obj}->getUnitCountForClients({
            clientEmails => [ 'email1@domain.com', 'email2@domain.com' ],
            startDate => '2006-10-09',
            endDate => '2006-10-09',
        });

        ok ($usage_records[0]->clientEmail eq 'email1@domain.com',
                'getUnitCountForClients (1)');
        ok ($usage_records[1]->clientEmail eq 'email2@domain.com',
                'getUnitCountForClients (2)');

    }
}

1;


