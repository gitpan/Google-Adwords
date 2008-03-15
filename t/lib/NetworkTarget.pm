package NetworkTarget;
use base qw/ Data /;

use Test::More;

sub test_class { return "Google::Adwords::NetworkTarget"; }

sub accessors : Test(no_plan)
{
    my $self = shift;

    my $network_target = $self->{'obj'};

    # networkTypes should always be an array ref
    $network_target->networkTypes('GoogleSearch');
    ok( ref $network_target->networkTypes eq 'ARRAY',
        'networkTypes is an array ref' );
    ok( $network_target->networkTypes->[0] eq 'GoogleSearch',
        'networkTypes' );

    $network_target->networkTypes( ['GoogleSearch'] );
    ok( ref $network_target->networkTypes eq 'ARRAY',
        'networkTypes is an array ref' );
    ok( $network_target->networkTypes->[0] eq 'GoogleSearch',
        'networkTypes' );

    $network_target->networkTypes( 'GoogleSearch', 'LocalSearch' );
    ok( ref $network_target->networkTypes eq 'ARRAY',
        'networkTypes is an array ref' );
    ok( $network_target->networkTypes->[0] eq 'GoogleSearch',
        'networkTypes' );
    ok( $network_target->networkTypes->[1] eq 'LocalSearch', 'networkTypes' );

    $network_target->networkTypes( [qw/GoogleSearch LocalSearch/] );
    ok( ref $network_target->networkTypes eq 'ARRAY',
        'networkTypes is an array ref' );
    ok( $network_target->networkTypes->[0] eq 'GoogleSearch',
        'networkTypes' );
    ok( $network_target->networkTypes->[1] eq 'LocalSearch', 'networkTypes' );

    $network_target->networkTypes( 'GoogleSearch', ['LocalSearch'] );
    ok( ref $network_target->networkTypes eq 'ARRAY',
        'networkTypes is an array ref' );
    ok( $network_target->networkTypes->[0] eq 'GoogleSearch',
        'networkTypes' );
    ok( $network_target->networkTypes->[1] eq 'LocalSearch', 'networkTypes' );

} # end sub accessors :

1;

