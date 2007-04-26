package Data;
use base qw/ Test::Class /;

use lib 'lib';
use Test::More;
use Test::MockModule;

sub test_class { return "Google::Adwords::Data"; }

sub startup : Test(startup => 2)
{
    my $self  = shift;
    my $class = $self->test_class;
    use_ok($class) or $self->FAIL_ALL('cannot use module');
    $self->{'obj'} = $class->new();
    isa_ok( $self->{'obj'}, $self->test_class )
        or $self->FAIL_ALL('cannot create object');
}

1;

