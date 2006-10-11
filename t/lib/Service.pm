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

    if (exists $args_ref->{'sandbox'}) {
        my @params = %{$args_ref};
        return $class->SUPER::new(@params);
    }
    else {
        return $class->SUPER::new(sandbox => 0);
    }
}

sub startup : Test(startup => 2)
{
    my $self = shift;
    my $class = $self->test_class;
    use_ok($class) or $self->FAIL_ALL('cannot use module');
    $self->{'obj'} = $class->new();
    isa_ok($self->{'obj'}, $self->test_class) 
        or $self->FAIL_ALL('cannot create object');
}

sub accessors : Test(7)
{
    my $self = shift;

    # put your account details here
    my $email = 'email@gmail.com';
    my $password = 'password';
    my $developerToken = $email . '++INR';
    my $applicationToken = 'ZYXwvu-TSR123_456ABCDE';
    

    if ($self->{'sandbox'}) {
        $email = $self->{'email'};
        $password = $self->{'password'};
        $developerToken = $self->{'developerToken'};
        $applicationToken = 'ZYXwvu-TSR123_456ABCDE';
    }   

    $self->{'obj'}->email($email)
        ->password($password)
        ->developerToken($developerToken)
        ->applicationToken($applicationToken)
        ->use_sandbox(1)
        ->clientEmail('client_1' . '+' . $email)
    ;

    ok ($self->{'obj'}->email eq $email, 'email');
    ok ($self->{'obj'}->password eq $password, 'password');
    ok ($self->{'obj'}->developerToken eq $developerToken, 'developerToken');
    ok ($self->{'obj'}->applicationToken eq $applicationToken, 'applicationToken');
    ok ($self->{'obj'}->use_sandbox == 1, 'use_sandbox');
    ok ($self->{'obj'}->clientEmail eq 'client_1' . '+' . $email, 'clientEmail');
    ok ($self->{'obj'}->debug == 0, 'debug');
}

1;

