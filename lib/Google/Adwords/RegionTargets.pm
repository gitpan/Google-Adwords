package Google::Adwords::RegionTargets;
use strict;
use warnings;

use version; our $VERSION = qv('0.0.1');

use base 'Google::Adwords::Data';

my @fields = qw/
    _regions
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

# regions should always return an array ref
sub regions
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

        $self->set( '_regions', $put_ref );
        return $self;
    } # end if (@_)

    return $self->get('_regions');
} # end sub regions

1;

=pod

=head1 NAME
 
Google::Adwords::RegionTargets - Contains region targets
 
=head1 SYNOPSIS
 
    use Google::Adwords::RegionTargets;

    my $targets = Google::Adwords::RegionTargets->new();
    $targets->regions([ 'DE-BE' ]);


=head1 METHODS 
 
B<Mutators (read/write)>

* regions


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


