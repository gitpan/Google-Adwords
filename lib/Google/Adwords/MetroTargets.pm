package Google::Adwords::MetroTargets;
use strict;
use warnings;

use version; our $VERSION = qv('0.0.1');

use base 'Google::Adwords::Data';

my @fields = qw/
    _metros
    /;

__PACKAGE__->mk_accessors(@fields);

sub new
{
    my $proto = shift;

    my $class = ref $proto || $proto;

    if (@_)
    {
        my $obj     = $class->SUPER::new();
        my $hashref = shift;
        for ( keys %{$hashref} )
        {
            $obj->$_( $hashref->{$_} );
        }
        return $obj;
    }
    else
    {
        return $class->SUPER::new();
    }
} # end sub new

# metros should always return an array ref
sub metros
{
    my $self = shift;

    # if its a put
    if (@_)
    {
        my $put_ref = [];

        for (@_)
        {
            if ( ref $_ ne 'ARRAY' )
            {
                push @{$put_ref}, $_;
            }
            else
            {
                push @{$put_ref}, @{$_};
            }
        }

        $self->set( '_metros', $put_ref );
    } # end if (@_)

    return $self->get('_metros');
} # end sub metros

1;

=pod

=head1 NAME
 
Google::Adwords::MetroTargets - Contains metro targets
 
=head1 SYNOPSIS
 
    use Google::Adwords::MetroTargets;

    my $targets = Google::Adwords::MetroTargets->new();
    $targets->metros([ '803' ]);


=head1 METHODS 
 
B<Mutators (read/write)>

* metros

=head1 SEE ALSO

=over 4

=item * L<Google::Adwords::GeoTarget>

=back

=head1 AUTHOR
 
Rohan Almeida <rohan@almeida.in>

 
=head1 LICENSE AND COPYRIGHT
 
Copyright (c) 2006 Rohan Almeida <rohan@almeida.in>. All rights
reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


