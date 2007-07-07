package Service;
use base qw/ Test::Class /;

use lib 'lib';
use Test::More;
use Test::MockModule;

sub test_class { return "Google::Adwords::Service"; }

sub new
{
    my $class = shift;
    my ($args_ref) = @_;

    my $self;

    if ( exists $args_ref->{'sandbox'} ) {
        my @params = %{$args_ref};
        return $class->SUPER::new(@params);
    }
    else {
        return $class->SUPER::new( sandbox => 0 );
    }
}

sub startup : Test(startup => 2)
{
    my $self  = shift;
    my $class = $self->test_class;
    use_ok($class) or $self->FAIL_ALL('cannot use module');
    $self->{'obj'} = $class->new();
    isa_ok( $self->{'obj'}, $self->test_class )
        or $self->FAIL_ALL('cannot create object');
}

sub accessors : Test(7)
{
    my $self = shift;

    # default value if not using sandbox
    my $email            = 'email@gmail.com';
    my $password         = 'password';
    my $developerToken   = $email . '++INR';
    my $applicationToken = 'ZYXwvu-TSR123_456ABCDE';
    my $client_email     = 'client_1+' . $email;

    if ( $self->{'sandbox'} ) {
        $email            = $self->{'email'};
        $password         = $self->{'password'};
        $developerToken   = $self->{'developerToken'};
        $client_email     = $self->{'clientEmail'};
        $applicationToken = 'ZYXwvu-TSR123_456ABCDE';
    }

    $self->{'obj'}->email($email)->password($password)
        ->developerToken($developerToken)->applicationToken($applicationToken)
        ->use_sandbox(1)->clientEmail($client_email);

    ok( $self->{'obj'}->email          eq $email,          'email' );
    ok( $self->{'obj'}->password       eq $password,       'password' );
    ok( $self->{'obj'}->developerToken eq $developerToken, 'developerToken' );
    ok( $self->{'obj'}->applicationToken eq $applicationToken,
        'applicationToken' );
    ok( $self->{'obj'}->use_sandbox == 1, 'use_sandbox' );
    ok( $self->{'obj'}->clientEmail eq $client_email, 'clientEmail' );
    ok( $self->{obj}->api_version eq 'v9', 'api_version' );
} # end sub accessors :

sub gen_full_response
{
    my ( $self, $append ) = @_;

    my $xml = <<EOF;
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <soapenv:Header>
  <responseTime soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v7">39</responseTime>
  <operations soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v7">1</operations>
  <units soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v7">1</units>
  <requestId soapenv:actor="http://schemas.xmlsoap.org/soap/actor/next" soapenv:mustUnderstand="0" xmlns="https://adwords.google.com/api/adwords/v7">f7912565442e4adeb1bf30cbbf2f8fd2</requestId>
 </soapenv:Header>
 <soapenv:Body>
 $append</soapenv:Body>
</soapenv:Envelope>
EOF

    return $xml;
} # end sub gen_full_response

{

    # campaign ID
    my $campaign_id;
    sub _get_campaign_id { return $campaign_id; }
    sub _set_campaign_id { $campaign_id = $_[1]; }
}

{

    # adgroup ID
    my $adgroup_id;
    sub _get_adgroup_id { return $adgroup_id; }
    sub _set_adgroup_id { $adgroup_id = $_[1]; }
}

1;

