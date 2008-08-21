package Campaign;
use base qw/ Data /;

use Test::More;

use Google::Adwords::BudgetOptimizerSettings;
use Google::Adwords::ConversionOptimizerSettings;

sub test_class { return "Google::Adwords::Campaign"; }

sub accessors : Test(no_plan)
{
    my $self = shift;

    my $campaign = $self->{'obj'};

    $self->{'obj'}->budgetAmount(100);
    $self->{'obj'}->name('Campaign #9');

    ok( $self->{'obj'}->budgetAmount == 100, 'budgetAmount' );
    ok( $self->{'obj'}->name eq 'Campaign #9', 'name' );

    # budget optimizer
    my $budget_optimizer = Google::Adwords::BudgetOptimizerSettings->new();
    $budget_optimizer->bidCeiling(100);
    $budget_optimizer->enabled('true');

    $self->{obj}->budgetOptimizerSettings($budget_optimizer);

    ok(
        ref $self->{obj}->budgetOptimizerSettings eq
            'Google::Adwords::BudgetOptimizerSettings',
        'budgetOptimizerSettings'
    );
    ok( $self->{obj}->budgetOptimizerSettings->bidCeiling eq '100',
        'budgetOptimizerSettings bidCeiling' );

    # conversion optimizer
    my $conversion_opt = Google::Adwords::ConversionOptimizerSettings->new();
    $conversion_opt->maxCpaBidForAllAdGroups(100);
    $conversion_opt->enabled('true');

    $self->{obj}->conversionOptimizerSettings($conversion_opt);

    ok(
        ref $self->{obj}->conversionOptimizerSettings eq
            'Google::Adwords::ConversionOptimizerSettings',
        'conversionOptimizerSettings'
    );
    ok(
        $self->{obj}->conversionOptimizerSettings->maxCpaBidForAllAdGroups eq
            '100',
        'conversionOptimizerSettings maxCpaBidForAllAdGroups'
    );

    # bug id 33
    $campaign->name('Me & You');
    ok( $campaign->name eq 'Me & You', 'bug id 33' );
} # end sub accessors :

1;

