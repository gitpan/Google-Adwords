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
        return $class->SUPER::new(sandbox => 1);
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

sub accessors : Test(4)
{
    my $self = shift;

    # put your account details here
    my $email = 'email@gmail.com';
    my $password = 'password';
    my $token = $email . '++INR';

    $self->{'obj'}->email($email)
        ->password($password)
        ->token($token)
        ->use_sandbox(1)
    ;

    ok ($self->{'obj'}->email eq $email, 'email');
    ok ($self->{'obj'}->password eq $password, 'password');
    ok ($self->{'obj'}->token eq $token, 'token');
    ok ($self->{'obj'}->use_sandbox == 1, 'use_sandbox');
}

1;

