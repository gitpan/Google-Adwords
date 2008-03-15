package Campaign;
use base qw/ Data /;

use Test::More;

use Google::Adwords::BudgetOptimizerSettings;

sub test_class { return "Google::Adwords::Campaign"; }

sub accessors : Test(no_plan)
{
    my $self = shift;

    my $campaign = $self->{'obj'};

    $self->{'obj'}->dailyBudget(100);
    $self->{'obj'}->name('Campaign #9');

    ok( $self->{'obj'}->dailyBudget == 100, 'daily_budget' );
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

    # bug id 33
    $campaign->name('Me & You');
    ok( $campaign->name eq 'Me & You', 'bug id 33' );
} # end sub accessors :

1;

