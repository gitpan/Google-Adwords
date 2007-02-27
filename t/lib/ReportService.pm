package ReportService;
use base qw/ Service /;

use Test::More;
use Test::MockModule;

use Google::Adwords::ReportJob;

sub test_class { return "Google::Adwords::ReportService"; }

# tests to run
my %tests = (
    deleteReport                => 1,
    z1_getAllJobs               => 1,
    getGzipReportDownloadUrl    => 0,
    z2_getReportJobStatus       => 0,
    z0_scheduleReportJob        => 0,
);

sub start_of_each_test : Test(setup)
{
    my $self = shift;

    # set debug to whatever was passed in as param
    $self->{obj}->debug($self->{debug});
}

sub deleteReport : Test(no_plan)
{
    my $self = shift;

    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }


    if ($self->{sandbox}) {

        #$self->{obj}->deleteReport(11);
        return;

    }
    else {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
  <deleteReportResponse xmlns="" />
EOF

            $xml = $self->gen_full_response($xml);
            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $ret = $self->{obj}->deleteReport(1);
        ok ($ret == 1, 'deleteReport'); 

    }

}

sub z1_getAllJobs : Test(no_plan)
{
    my $self = shift;


    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }

    if ($self->{sandbox}) {

        my @jobs = $self->{obj}->getAllJobs;
        for (@jobs) {
            ok ($_->id =~ /\d+/, 'getAllJobs id: ' . $_->id);
        }

    }
    else {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
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
EOF

            $xml = $self->gen_full_response($xml);
            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my @jobs = $self->{obj}->getAllJobs;
        for (@jobs) {
            ok ($_->id =~ /\d+/, 'getAllJobs id: ' . $_->id);
        }


    }

}

sub getGzipReportDownloadUrl : Test(no_plan)
{
    my $self = shift;


    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }

    if ($self->{sandbox}) {

        my $url = $self->{obj}->getGzipReportDownloadUrl(1935159656);

    }
    else {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
  <getGzipReportDownloadUrlResponse xmlns="" />
EOF

            $xml = $self->gen_full_response($xml);
            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my @jobs = $self->{obj}->getAllJobs;
        for (@jobs) {
            ok ($_->id =~ /\d+/, 'getAllJobs');
        }


    }

}

sub z2_getReportJobStatus : Test(no_plan)
{
    my $self = shift;

    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }


    if ($self->{sandbox}) {

        my $status = $self->{obj}->getReportJobStatus($self->{_job_id});
        ok ($status eq 'Pending', 'getReportJobStatus');

    }
    else {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
  <getReportJobStatusResponse xmlns="">
   <ns1:getReportJobStatusReturn
xmlns:ns1="https://adwords.google.com/api/adwords/v6">Pending</ns1:getReportJobStatusReturn>
  </getReportJobStatusResponse>
EOF

            $xml = $self->gen_full_response($xml);
            my $env = SOAP::Deserializer->deserialize($xml);
            return $env;
        });

        my $status = $self->{obj}->getReportJobStatus(11);
        ok ($status eq 'Pending', 'getReportJobStatus');

    }

}

sub z0_scheduleReportJob : Test(no_plan)
{
    my $self = shift;

    $sub_name = (caller 0)[3];
    $sub_name =~ s/^.+:://;
    if (not $tests{$sub_name}) {
        return;
    }


    if ($self->{sandbox}) {

        my $job = Google::Adwords::ReportJob->new
            ->startDay('2007-02-25')
            ->endDay('2007-02-27')
            ->name('test')
            ->aggregationType('Summary')
        ;

        my $job_id 
            = $self->{obj}->scheduleReportJob('AccountReportJob', $job);
        ok ($job_id =~ /\d+/, 'scheduleReportJob id: ' . $job_id);

        # save for further use
        $self->{_job_id} = $job_id;
    }
    else {
        my $soap = Test::MockModule->new('SOAP::Lite');
        $soap->mock( call => sub {
            my $xml .= <<'EOF';
  <scheduleReportJobResponse
xmlns="https://adwords.google.com/api/adwords/v6">
   <scheduleReportJobReturn>1935158656</scheduleReportJobReturn>
  </scheduleReportJobResponse>
EOF

            $xml = $self->gen_full_response($xml);
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

