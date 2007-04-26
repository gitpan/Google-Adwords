package Campaign;
use base qw/ Data /;

use Test::More;

sub test_class { return "Google::Adwords::Campaign"; }

sub accessors : Test(no_plan)
{
    my $self = shift;

    my $campaign = $self->{'obj'};

    $self->{'obj'}->dailyBudget(100);
    $self->{'obj'}->name('Campaign #9');

    ok( $self->{'obj'}->dailyBudget == 100, 'daily_budget' );
    ok( $self->{'obj'}->name eq 'Campaign #9', 'name' );

    # language_targeting
    my $expected_ref = [ 'en', 'es' ];
    $self->{'obj'}->languageTargeting( { languages => [ 'en', 'es', ], } );
    my $got_ref = $self->{'obj'}->languageTargeting();
    ok( $got_ref->{'languages'}[0] eq $expected_ref->[0],
        'language_targeting' );
    ok( $got_ref->{'languages'}[1] eq $expected_ref->[1],
        'language_targeting' );

    $self->{obj}->languageTargeting( { languages => 'en', } );
    $got_ref = $self->{'obj'}->languageTargeting();
    ok( $got_ref->{languages}[0] eq 'en', 'language_targeting' );

    $self->{obj}->languageTargeting( { languages => ['en'], } );
    $got_ref = $self->{'obj'}->languageTargeting();
    ok( $got_ref->{languages}[0] eq 'en', 'language_targeting' );

    # geo_targeting
    $self->{'obj'}->geoTargeting(
        {
            countries => [ 'US',             'IN', ],
            regions   => [ 'US-CA',          'BR-AC' ],
            cities    => [ 'Pelican, AK US', 'Sitka, AK US' ],
            metros    => [ 606,              693 ],
        }
    );
    $got_ref = $self->{'obj'}->geoTargeting();

    ok( $got_ref->{'countries'}[1] eq 'IN', 'geo_targeting (countries)' );
    ok( $got_ref->{'cities'}[0] eq 'Pelican, AK US',
        'geo_targeting (cities)' );

    $self->{'obj'}->geoTargeting( { countries => 'US', } );
    $got_ref = $self->{'obj'}->geoTargeting();
    ok( $got_ref->{'countries'}[0] eq 'US', 'geo_targeting (countries)' );

    $self->{'obj'}->geoTargeting(
        {
            countries => 'US',
            cities    => 'Pelican, AK US',
        }
    );
    $got_ref = $self->{'obj'}->geoTargeting();
    ok( $got_ref->{'countries'}[0] eq 'US', 'geo_targeting (countries)' );
    ok( $got_ref->{'cities'}[0] eq 'Pelican, AK US',
        'geo_targeting (cities)' );

    # networkTargeting
    $self->{'obj'}->networkTargeting(
        { networkTypes => [ 'GoogleSearch', 'ContentNetwork' ] } );
    $got_ref = $self->{'obj'}->networkTargeting();
    ok( $got_ref->{'networkTypes'}[0] eq 'GoogleSearch',
        'network_targeting' );

    # networkTargeting
    $self->{'obj'}->networkTargeting( { networkTypes => 'GoogleSearch', } );
    $got_ref = $self->{'obj'}->networkTargeting();
    ok( $got_ref->{'networkTypes'}[0] eq 'GoogleSearch',
        'network_targeting' );

    # test new method
    $campaign = Google::Adwords::Campaign->new(
        {
            dailyBudget       => 1000,
            languageTargeting => { languages => 'en', },
        }
    );
    ok( $campaign->dailyBudget == 1000, 'new' );
    my $lang_ref = $campaign->languageTargeting;
    ok( $lang_ref->{languages}[0] eq 'en', 'new' );

    # bug id 33
    $campaign->name('Me & You');
    ok( $campaign->name eq 'Me & You', 'bug id 33' );
} # end sub accessors :

1;

