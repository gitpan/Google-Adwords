package ReportService;
use base qw/ Service /;

use Test::More;
use Test::MockModule;

use Google::Adwords::ReportJob;

sub test_class { return "Google::Adwords::ReportService"; }

sub deleteReport : Test(no_plan)
{
    my $self = shift;

    #return;

    if ($self->{sandbox}) {
        $self->{obj}->debug(1);

        #$self->{obj}->deleteReport(11);

    }
    else {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v6">39</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v6">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v6">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v6">f7912565442e4adeb1bf30cbbf2f8fd2</requestId>
 </soapenv:Header>
 <soapenv:Body>
  <deleteReportResponse xmlns="" />
 </soapenv:Body>
</soapenv:Envelope>
EOF

            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $ret = $self->{obj}->deleteReport(1);
        ok ($ret == 1, 'deleteReport'); 

    }

}

sub getAllJobs : Test(no_plan)
{
    my $self = shift;

    #return;

    if ($self->{sandbox}) {
        $self->{obj}->debug(1);

        my @jobs = $self->{obj}->getAllJobs;
        for (@jobs) {
            ok ($_->id =~ /\d+/, 'getAllJobs');
        }

    }
    else {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v6">39</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v6">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v6">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v6">f7912565442e4adeb1bf30cbbf2f8fd2</requestId>
 </soapenv:Header>
 <soapenv:Body>
  <getAllJobsResponse xmlns="">
   <ns1:getAllJobsReturn xsi:type="ns1:KeywordReportJob"
xmlns:ns1="https://adwords.google.com/api/adwords/v6">
    <ns1:aggregationType>Daily</ns1:aggregationType>
    <ns1:clientEmails>client_1+rohan.almeida@gmail.com</ns1:clientEmails>
    <ns1:crossClient>false</ns1:crossClient>
    <ns1:endDay>2006-10-17-07:00</ns1:endDay>
    <ns1:id>11</ns1:id>
    <ns1:name>report [11]</ns1:name>
    <ns1:startDay>2006-10-17-07:00</ns1:startDay>
    <ns1:status>Pending</ns1:status>
    <ns1:includeZeroImpression>false</ns1:includeZeroImpression>
   </ns1:getAllJobsReturn>
   <ns2:getAllJobsReturn xsi:type="ns2:AdTextReportJob"
xmlns:ns2="https://adwords.google.com/api/adwords/v6">
    <ns2:aggregationType>Daily</ns2:aggregationType>
    <ns2:clientEmails>client_1+rohan.almeida@gmail.com</ns2:clientEmails>
    <ns2:crossClient>false</ns2:crossClient>
    <ns2:endDay>2006-10-17-07:00</ns2:endDay>
    <ns2:id>22</ns2:id>
    <ns2:name>report [22]</ns2:name>
    <ns2:startDay>2006-10-17-07:00</ns2:startDay>
    <ns2:status>InProgress</ns2:status>
   </ns2:getAllJobsReturn>
  </getAllJobsResponse>
 </soapenv:Body>
</soapenv:Envelope>
EOF

            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my @jobs = $self->{obj}->getAllJobs;
        for (@jobs) {
            ok ($_->id =~ /\d+/, 'getAllJobs');
        }


    }

}

sub getGzipReportDownloadUrl : Test(no_plan)
{
    my $self = shift;

    #return;

    if ($self->{sandbox}) {
        $self->{obj}->debug(1);

        my $url = $self->{obj}->getGzipReportDownloadUrl(1935159656);

    }
    else {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v6">39</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v6">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v6">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v6">f7912565442e4adeb1bf30cbbf2f8fd2</requestId>
 </soapenv:Header>
 <soapenv:Body>
  <getAllJobsResponse xmlns="">
   <ns1:getAllJobsReturn xsi:type="ns1:KeywordReportJob"
xmlns:ns1="https://adwords.google.com/api/adwords/v6">
    <ns1:aggregationType>Daily</ns1:aggregationType>
    <ns1:clientEmails>client_1+rohan.almeida@gmail.com</ns1:clientEmails>
    <ns1:crossClient>false</ns1:crossClient>
    <ns1:endDay>2006-10-17-07:00</ns1:endDay>
    <ns1:id>11</ns1:id>
    <ns1:name>report [11]</ns1:name>
    <ns1:startDay>2006-10-17-07:00</ns1:startDay>
    <ns1:status>Pending</ns1:status>
    <ns1:includeZeroImpression>false</ns1:includeZeroImpression>
   </ns1:getAllJobsReturn>
   <ns2:getAllJobsReturn xsi:type="ns2:AdTextReportJob"
xmlns:ns2="https://adwords.google.com/api/adwords/v6">
    <ns2:aggregationType>Daily</ns2:aggregationType>
    <ns2:clientEmails>client_1+rohan.almeida@gmail.com</ns2:clientEmails>
    <ns2:crossClient>false</ns2:crossClient>
    <ns2:endDay>2006-10-17-07:00</ns2:endDay>
    <ns2:id>22</ns2:id>
    <ns2:name>report [22]</ns2:name>
    <ns2:startDay>2006-10-17-07:00</ns2:startDay>
    <ns2:status>InProgress</ns2:status>
   </ns2:getAllJobsReturn>
  </getAllJobsResponse>
 </soapenv:Body>
</soapenv:Envelope>
EOF

            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my @jobs = $self->{obj}->getAllJobs;
        for (@jobs) {
            ok ($_->id =~ /\d+/, 'getAllJobs');
        }


    }

}

sub getReportJobStatus : Test(no_plan)
{
    my $self = shift;

    #return;

    if ($self->{sandbox}) {
        $self->{obj}->debug(1);

        my $status = $self->{obj}->getReportJobStatus(11);
        ok ($status eq 'Pending', 'getReportJobStatus');

    }
    else {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v6">39</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v6">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v6">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v6">f7912565442e4adeb1bf30cbbf2f8fd2</requestId>
 </soapenv:Header>
 <soapenv:Body>
  <getReportJobStatusResponse xmlns="">
   <ns1:getReportJobStatusReturn
xmlns:ns1="https://adwords.google.com/api/adwords/v6">Pending</ns1:getReportJobStatusReturn>
  </getReportJobStatusResponse>
 </soapenv:Body>
</soapenv:Envelope>
EOF

            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $status = $self->{obj}->getReportJobStatus(11);
        ok ($status eq 'Pending', 'getReportJobStatus');

    }

}

sub scheduleReportJob : Test(no_plan)
{
    my $self = shift;

    #return;

    if ($self->{sandbox}) {
        $self->{obj}->debug(1);

        my $job = Google::Adwords::ReportJob->new
            ->startDay('2006-08-01')
            ->endDay('2006-08-01')
            ->name('test')
            ->aggregationType('Summary')
        ;

        my $job_id 
            = $self->{obj}->scheduleReportJob('AccountReportJob', $job);
        ok ($job_id =~ /\d+/, 'scheduleReportJob');


    }
    else {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v6">39</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v6">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v6">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v6">f7912565442e4adeb1bf30cbbf2f8fd2</requestId>
 </soapenv:Header>
 <soapenv:Body>
  <scheduleReportJobResponse
xmlns="https://adwords.google.com/api/adwords/v6">
   <scheduleReportJobReturn>1935158656</scheduleReportJobReturn>
  </scheduleReportJobResponse>
 </soapenv:Body>
</soapenv:Envelope>
EOF

            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $job = Google::Adwords::ReportJob->new
            ->startDay('2006-08-01')
            ->endDay('2006-08-01')
            ->name('test')
            ->aggregationType('Summary')
        ;

        my $job_id 
            = $self->{obj}->scheduleReportJob('AccountReportJob', $job);
        ok ($job_id eq '1935158656', 'scheduleReportJob');


    }

}

1;

