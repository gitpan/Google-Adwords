package Google::Adwords::ReportService;
use strict;
use warnings;

use version; our $VERSION = qv('0.2');

use base 'Google::Adwords::Service';

# Data types
use Google::Adwords::ReportJob;

### CLASS METHOD/INSTANCE METHOD/INTERFACE SUB/INTERNAL UTILITY ###
# Usage      : ????
# Purpose    : ????
# Returns    : ????
# Parameters : ????
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub _parse_report
{
    my ( $self, $r ) = @_;

    my @fields = Google::Adwords::ReportJob->get_fields();

    my $report_ref;

    for (@fields)
    {
        if ( exists $r->{$_} )
        {
            $report_ref->{$_} = $r->{$_};
        }
    }

    return $self->_create_object_from_hash( $report_ref,
        'Google::Adwords::ReportJob' );
} # end sub _parse_report

### INSTANCE METHOD ################################################
# Usage      :
#   my $ret = $obj->deleteReport($id);
# Purpose    : Delete a report
# Returns    : Always return 1
# Parameters : The id of the report to delete
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub deleteReport
{
    my ( $self, $id ) = @_;

    # id should be present
    if ( not defined $id )
    {
        die "id must be set.";
    }

    my @params;
    push @params, SOAP::Data->name( 'reportJobId' => $id )->type('');

    # create the SOAP service
    my $result = $self->_create_service_and_call(
        {
            service => 'ReportService',
            method  => 'deleteReport',
            params  => \@params,
        }
    );

    return 1;
} # end sub deleteReport

### INSTANCE METHOD ################################################
# Usage      :
#   my@jobs = $boj->getAllJobs();
# Purpose    : Get all the report jobs for an account
# Returns    : A list of ReportJob objects
# Parameters : none
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getAllJobs
{
    my $self = shift;

    my $result = $self->_create_service_and_call(
        {
            service => 'ReportService',
            method  => 'getAllJobs',
        }
    );

    my @data;
    foreach
        my $c ( $result->valueof("//getAllJobsResponse/getAllJobsReturn") )
    {
        push @data, $self->_parse_report($c);
    }

    return @data;
} # end sub getAllJobs

### INSTANCE METHOD ################################################
# Usage      :
#   my $url = $obj->getGzipReportDownloadUrl($id);
# Purpose    : Get the url of the gzipped report
# Returns    : The url for download
# Parameters : The id of the report
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getGzipReportDownloadUrl
{
    my ( $self, $id ) = @_;

    my @params;
    push @params, SOAP::Data->name( 'reportJobId' => $id )->type('');

    my $result = $self->_create_service_and_call(
        {
            service => 'ReportService',
            method  => 'getGzipReportDownloadUrl',
            params  => \@params,
        }
    );

    my $data = $result->valueof(
        "//getGzipReportDownloadUrlResponse/getGzipReportDownloadUrlReturn");

    return $data;
} # end sub getGzipReportDownloadUrl

### INSTANCE METHOD ################################################
# Usage      :
#   my $url = $obj->getReportDownloadUrl($id);
# Purpose    : Get the url of the report
# Returns    : The url for download
# Parameters : The id of the report
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getReportDownloadUrl
{
    my ( $self, $id ) = @_;

    my @params;
    push @params, SOAP::Data->name( 'reportJobId' => $id )->type('');

    my $result = $self->_create_service_and_call(
        {
            service => 'ReportService',
            method  => 'getReportDownloadUrl',
            params  => \@params,
        }
    );

    my $data = $result->valueof(
        "//getReportDownloadUrlResponse/getReportDownloadUrlReturn");

    return $data;
} # end sub getReportDownloadUrl

### INSTANCE METHOD ################################################
# Usage      :
#   my $status = $obj->getReportJobStatus($id);
# Purpose    : Get the current status of a report job
# Returns    : A job status
# Parameters : The id of the report job
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub getReportJobStatus
{
    my ( $self, $id ) = @_;

    my @params;
    push @params, SOAP::Data->name( 'reportJobId' => $id )->type('');

    my $result = $self->_create_service_and_call(
        {
            service => 'ReportService',
            method  => 'getReportJobStatus',
            params  => \@params,
        }
    );

    my $data = $result->valueof(
        "//getReportJobStatusResponse/getReportJobStatusReturn");

    return $data;
} # end sub getReportJobStatus

### INSTANCE METHOD ################################################
# Usage      :
#   $obj->validateReportJob($type, $job);
# Purpose    : Schedule a report
# Returns    : A job request id
# Parameters : The type of the report (see doc) and a ReportJob object
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub validateReportJob
{
    my ( $self, $job ) = @_;

    if ( not defined $job->selectedReportType )
    {
        die "selectedReportType must be set for the job object";
    }

    my @job_params;

    # accessors
    for (
        qw/ selectedReportType aggregationTypes selectedColumns
        adWordsType keywordType
        crossClient endDay id includeZeroImpression name
        startDay status adGroups adGroupStatuses
        campaigns campaignStatuses keywords keywordStatuses
        clientEmails /
        )
    {
        if ( defined $job->$_ )
        {
            if ( ref $job->$_ eq 'ARRAY' )
            {
                push @job_params,
                    SOAP::Data->name( $_ => @{ $job->$_ } )->type('');
            }
            else
            {
                push @job_params,
                    SOAP::Data->name( $_ => $job->$_ )->type('');
            }
        }
    } # end for ( qw/ selectedReportType aggregationTypes selectedColumns...

    my @params;
    push @params,
        SOAP::Data->name( 'job' => \SOAP::Data->value(@job_params) )
        ->attr( { 'xsi:type' => 'DefinedReportJob' } )->type('');

    my $result = $self->_create_service_and_call(
        {
            service  => 'ReportService',
            method   => 'validateReportJob',
            with_uri => 1,
            params   => \@params,
        }
    );

    return 1;
} # end sub validateReportJob

### INSTANCE METHOD ################################################
# Usage      :
#   my $jobid = $obj->scheduleReportJob($type, $job);
# Purpose    : Schedule a report
# Returns    : A job request id
# Parameters : The type of the report (see doc) and a ReportJob object
# Throws     : no exceptions
# Comments   : none
# See Also   : n/a
#######################################################################
sub scheduleReportJob
{
    my ( $self, $job ) = @_;

    if ( not defined $job->selectedReportType )
    {
        die "selectedReportType must be set for the job object";
    }

    my @job_params;

    # accessors
    for (
        qw/ selectedReportType aggregationTypes selectedColumns
        adWordsType keywordType
        crossClient endDay id includeZeroImpression name
        startDay status adGroups adGroupStatuses
        campaigns campaignStatuses keywords keywordStatuses
        clientEmails /
        )
    {
        if ( defined $job->$_ )
        {
            if ( ref $job->$_ eq 'ARRAY' )
            {
                push @job_params,
                    SOAP::Data->name( $_ => @{ $job->$_ } )->type('');
            }
            else
            {
                push @job_params,
                    SOAP::Data->name( $_ => $job->$_ )->type('');
            }
        }
    } # end for ( qw/ selectedReportType aggregationTypes selectedColumns...

    my @params;
    push @params,
        SOAP::Data->name( 'job' => \SOAP::Data->value(@job_params) )
        ->attr( { 'xsi:type' => 'DefinedReportJob' } )->type('');

    my $result = $self->_create_service_and_call(
        {
            service  => 'ReportService',
            method   => 'scheduleReportJob',
            with_uri => 1,
            params   => \@params,
        }
    );

    my $data = $result->valueof(
        "//scheduleReportJobResponse/scheduleReportJobReturn");

    return $data;
} # end sub scheduleReportJob

1;

__END__

=pod

=head1 NAME
 
Google::Adwords::ReportService - Interact with the Google Adwords
ReportService API calls
 
 
=head1 VERSION
 
This documentation refers to Google::Adwords::ReportService version 0.0.1
 
 
=head1 SYNOPSIS
 
    use Google::Adwords::ReportService;

    # create the report service object
    my $report_service = Google::Adwords::ReportService->new();

    # need to login to the Adwords service
    $report_service->email($email_address)
                   ->password($password)
                   ->developerToken($developer_token)
                   ->applicationToken($app_token)
    ;

    # delete a report
    my $report_job_id = 123456;
    $report_service->deleteReport($report_job_id);

    # get all the jobs
    my @jobs = $report_service->getAllJobs();

    # get status for report job
    my $status = $report_service->getReportJobStatus($report_job_id);

    # get gzip url for download
    my $gzip_url = $report_service->getGzipReportDownloadUrl($report_job_id);
    
    # get url for download
    my $url = $report_service->getReportDownloadUrl($report_job_id);

    # schedule a report
    my $job = Google::Adwords::ReportJob->new
     ->startDay('2006-08-01')
     ->endDay('2006-08-01')
     ->name('Test report via API')
     ->aggregationType('Daily')
     ->adWordsType('SearchOnly');

    my $jobid = $report_service->scheduleReportJob('AccountReportJob', $job);

  
=head1 METHODS 

=head2 B<deleteReport()>

=head3 Description

=over 4

Deletes a report job along with the report it produced, if any. Cannot delete
a report job in progress.

=back

=head3 Usage

=over 4
   
   my $ret = $obj->deleteReport($job_id);

=back

=head3 Parameters

=over 4

=item * $job_id => The ID of the report job

=back

=head3 Returns

=over 4

1 on success

=back
 
=head2 B<getAllJobs()>

=head3 Description

=over 4

Returns an array consisting of all jobs the user has scheduled.

=back

=head3 Usage

=over 4

    my @jobs = $obj->getAllJobs();

=back

=head3 Parameters

None.

=head3 Returns
 
=over 4

A list of Google::Adwords::ReportJob objects

=back

=head2 B<getGzipReportDownloadUrl()>

=head3 Description

=over 4

Returns a URL from which a compressed report with the given job ID can be
downloaded (in Gzip format). After invoking this method, the caller can do a
regular HTTP GET on the returned URL to retrieve the report.

=back

=head3 Usage

=over 4

    my $url = $obj->getGzipReportDownloadUrl($job_id);

=back

=head3 Parameters

=over 4

=item * $job_id => The ID of the report job

=back

=head3 Returns
 
=over 4

=item * $url => A URL from which the compressed report can be downloaded

=back

=head2 B<getReportDownloadUrl()>

=head3 Description

=over 4

Returns a URL from which the report with the given job ID can be downloaded.
After invoking this method, the caller can do a regular HTTP GET on the
returned URL to retrieve the report.


=back

=head3 Usage

=over 4

    my $url = $obj->getReportDownloadUrl($job_id);

=back

=head3 Parameters

=over 4

=item * $job_id => The ID of the report job

=back

=head3 Returns
 
=over 4

=item * $url => A URL from which the report can be downloaded

=back

=head2 B<getReportJobStatus()>

=head3 Description

=over 4

Returns the status of the report job with the given reportJobId. One of: {
Pending | InProgress | Completed | Failed }

=back

=head3 Usage

=over 4

    my $status = $obj->getReportJobStatus($job_id);

=back

=head3 Parameters

=over 4

=item * $job_id => The ID of the report job

=back

=head3 Returns
 
=over 4

=item * $status => The report job status

=back

=head2 B<scheduleReportJob()>

=head3 Description

=over 4

Schedules a report job for execution.

=back

=head3 Usage

=over 4

    my $job_id = $obj->scheduleReportJob($type, $job);

=back

=head3 Parameters

=over 4

=item 1) $type => The type of the Report Job. Should be one of:


=over 4

* CustomReportJob - 
    http://www.google.com/apis/adwords/developer/CustomReportJob.html

* UrlReportJob - 
    http://www.google.com/apis/adwords/developer/UrlReportJob.html

* KeywordReportJob - 
    http://www.google.com/apis/adwords/developer/KeywordReportJob.html

* AdTextReportJob - 
    http://www.google.com/apis/adwords/developer/AdTextReportJob.html

* AdImageReportJob - 
    http://www.google.com/apis/adwords/developer/AdImageReportJob.html

* AdGroupReportJob - 
    http://www.google.com/apis/adwords/developer/AdGroupReportJob.html

* CampaignReportJob - 
    http://www.google.com/apis/adwords/developer/CampaignReportJob.html

* AccountReportJob - 
    http://www.google.com/apis/adwords/developer/AccountReportJob.html

=back

=item 2) $job => A Google::Adwords::ReportJob object

=back

=head3 Returns
 
=over 4

=item * $job_id => The Report Job ID

=back

=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::ReportJob>

=back


=head1 AUTHORS
 
Rohan Almeida <rohan@almeida.in>
 
Mathieu Jondet <mathieu@eulerian.com>
 
=head1 LICENSE AND COPYRIGHT
 
Copyright (c) 2006 Rohan Almeida <rohan@almeida.in>. All rights
reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

