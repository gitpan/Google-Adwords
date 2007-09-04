package GeoTarget;
use base qw/ Data /;

use Test::More;
use Google::Adwords::CityTargets;

sub test_class { return "Google::Adwords::GeoTarget"; }

sub accessors : Test(no_plan)
{
    my $self = shift;

    my $geo_target = $self->{'obj'};
    ok( ref $geo_target eq 'Google::Adwords::GeoTarget' );

    my $city_targets = Google::Adwords::CityTargets->new();
    $city_targets->cities( [ 'Mumbai', 'Delhi' ] );

    $geo_target->cityTargets($city_targets);
    isa_ok( $geo_target->cityTargets, 'Google::Adwords::CityTargets' );
    ok( ref $geo_target->cityTargets->cities eq 'ARRAY' );

}

1;

