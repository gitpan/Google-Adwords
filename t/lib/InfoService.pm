package InfoService;
use base qw/ Service /;

use Test::More;
use Test::MockModule;

sub test_class { return "Google::Adwords::InfoService"; }

sub get_usage_quota_this_month : Test(1)
{
    my $self = shift;
    
    #return;

    if ($self->{'sandbox'}) {
        my $expected = '9223372036854775';
        my $got = $self->{'obj'}->getUsageQuotaThisMonth();
        is ($got, $expected, 'getUsageQuotaThisMonth');
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
  <getUsageQuotaThisMonthResponse xmlns="">
   <ns1:getUsageQuotaThisMonthReturn xmlns:ns1="https://adwords.google.com/api/adwords/v4">9223372036854775</ns1:getUsageQuotaThisMonthReturn>
  </getUsageQuotaThisMonthResponse>
 </soapenv:Body>
</soapenv:Envelope>
EOF

        my $env = SOAP::Deserializer->deserialize($xml);
        return $env;
    });

    my $expected = '9223372036854775';
    my $got = $self->{'obj'}->getUsageQuotaThisMonth();
    is ($got, $expected, 'getUsageQuotaThisMonth');

    }
}

sub get_free_usage_quota_this_month : Test(1)
{
    my $self = shift;

    #return;

    if ($self->{'sandbox'}) {
        my $expected = '9223372036854775';
        my $got = $self->{'obj'}->getFreeUsageQuotaThisMonth();
        is ($got, $expected, 'getFreeUsageQuotaThisMonth');
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
  <getFreeUsageQuotaThisMonthResponse xmlns="">
   <ns1:getFreeUsageQuotaThisMonthReturn xmlns:ns1="https://adwords.google.com/api/adwords/v4">9223372036854775</ns1:getFreeUsageQuotaThisMonthReturn>
  </getFreeUsageQuotaThisMonthResponse>
 </soapenv:Body>
</soapenv:Envelope>
EOF

        my $env = SOAP::Deserializer->deserialize($xml);
        return $env;
    });

    my $expected = '9223372036854775';
    my $got = $self->{'obj'}->getFreeUsageQuotaThisMonth();
    is ($got, $expected, 'getFreeUsageQuotaThisMonth');

    }
}

sub get_method_cost : Test(1)
{
    my $self = shift;

    #return;

    if ($self->{'sandbox'}) {
        my $expected = '1';
        my $got = $self->{'obj'}->getMethodCost({
            service => 'InfoService',
            method => 'getFreeUsageQuotaThisMonth',
            date => '2006-08-02T00:00:00',
        });
        is ($got, $expected, 'getMethodCost');
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
  <getMethodCostResponse xmlns="">
   <ns1:getMethodCostReturn xmlns:ns1="https://adwords.google.com/api/adwords/v4">1</ns1:getMethodCostReturn>
  </getMethodCostResponse>
 </soapenv:Body>
</soapenv:Envelope>
EOF

        my $env = SOAP::Deserializer->deserialize($xml);
        return $env;
    });

    my $expected = 1;
    my $got = $self->{'obj'}->getMethodCost({
        service => 'InfoService',
        method => 'getFreeUsageQuotaThisMonth',
        date => '2006-08-02T00:00:00',
    });
    ok ($got == $expected, 'getMethodCost');
    }
}

sub get_operation_count : Test(1)
{
    my $self = shift;

    #return;

    if ($self->{'sandbox'}) {
        my $expected = '0';
        my $got = $self->{'obj'}->getOperationCount({
            startDate => '2006-08-02T00:00:00',
            endDate => '2006-08-12T00:00:00',
        });
        is ($got, $expected, 'getOperationCount');
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
  <getOperationCountResponse xmlns="">
   <ns1:getOperationCountReturn xmlns:ns1="https://adwords.google.com/api/adwords/v4">0</ns1:getOperationCountReturn>
  </getOperationCountResponse>
 </soapenv:Body>
</soapenv:Envelope>
EOF

        my $env = SOAP::Deserializer->deserialize($xml);
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

sub get_unit_count : Test(1)
{
    my $self = shift;

    #return;

    if ($self->{'sandbox'}) {
        my $expected = '0';
        my $got = $self->{'obj'}->getUnitCount({
            startDate => '2006-08-02T00:00:00',
            endDate => '2006-08-12T00:00:00',
        });
        is ($got, $expected, 'getUnitCount');
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
  <getUnitCountResponse xmlns="">
   <ns1:getUnitCountReturn xmlns:ns1="https://adwords.google.com/api/adwords/v4">0</ns1:getUnitCountReturn>
  </getUnitCountResponse>
 </soapenv:Body>
</soapenv:Envelope>
EOF

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

sub get_unit_count_for_method : Test(1)
{
    my $self = shift;

    #return;

    if ($self->{'sandbox'}) {
        my $expected = '0';
        my $got = $self->{'obj'}->getUnitCountForMethod({
            service => 'InfoService',
            method => 'getFreeUsageQuotaThisMonth',
            startDate => '2006-08-02 00:00',
            endDate => '2006-08-12 00:00',
        });
        is ($got, $expected, 'getUnitCountForMethod');
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
  <getUnitCountForMethodResponse xmlns="">
   <ns1:getUnitCountForMethodReturn xmlns:ns1="https://adwords.google.com/api/adwords/v4">0</ns1:getUnitCountForMethodReturn>
  </getUnitCountForMethodResponse>
 </soapenv:Body>
</soapenv:Envelope>
EOF

        my $env = SOAP::Deserializer->deserialize($xml);
        return $env;
    });
        my $expected = '0';
        my $got = $self->{'obj'}->getUnitCountForMethod({
            service => 'InfoService',
            method => 'getFreeUsageQuotaThisMonth',
            startDate => '2006-08-02T00:00:00',
            endDate => '2006-08-12T00:00:00',
        });
        is ($got, $expected, 'getUnitCountForMethod');

    }
}


1;


