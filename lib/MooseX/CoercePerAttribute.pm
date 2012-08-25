package MooseX::CoercePerAttribute;

use 5.006;
use strict;
use warnings;

=head1 NAME

MooseX::CoercePerAttribute - Define Coercions per attribute!

=head1 VERSION

Version 0.7

=cut

our $VERSION = '0.801';

use Moose::Role;
use Moose::Util::TypeConstraints;
Moose::Util::meta_attribute_alias('CoercePerAttribute');

before _process_coerce_option => sub {
    my ($class, $name, $options) = @_;

    my $coercion = $options->{coerce};
    return unless $coercion && $coercion != 1;

    # Create an anonomous subtype of the TC object so as to not mess with the existing TC
    my $anon_subtype = $options->{type_constraint} = Moose::Meta::TypeConstraint->new(
        parent => $options->{type_constraint},
        );

    $class->throw_error(
        "Couldn't build coercion from supplyed arguments for ($name)",
        data => $coercion,
        ) unless ((ref $coercion) =~ /ARRAY|HASH/) || !$anon_subtype;

    my @coercions;
    @coercions = @$coercion if ref $coercion eq 'ARRAY';

    if (ref $coercion eq 'HASH'){
        # We comvert the hash of coercions into sub refs to create the TypeCoercion.
        for my $fromtype (keys %$coercion){
            push @coercions, sub {
                coerce shift,
                    from $fromtype,
                        &via($coercion->{$fromtype}),
                };
            }
        }

    for my $coercion (@coercions){
        $coercion->($anon_subtype) if ref $coercion eq 'CODE';
        }

    $class->throw_error(
        "Coerce for ($name) doesn't set a coercion for ($anon_subtype), see man MooseX::CoercePerAttribute for usage",
        data => $coercion
        ) unless $anon_subtype->has_coercion;
    };

=pod

=head1 DESCRIPTION

A simple Moose Trait to allow you to define coercions per attribute.

=head1 SYNOPSIS

This module allows for coercions to be declasred on a per attribute bases. Accepting either an array of  Code refs of the coercion to be run or an HashRef of various arguments to create a coearcion routine from .

    use MooseX::CoercePerAttribute;

	has foo => (isa => 'Str', is => 'ro', coerce => 1);
	has bar => (
        traits  => [CoercePerAttribute],
        isa     => Bar,
        is      => 'ro',
        coerce  => {
		    Str => sub {
                my ($value, $options);
                ...
                },
            Int => sub {
                my ($value, $options);
                ...
                },
            },
        );

    use Moose::Util::Types;

	has baz => (
        traits  => [CoercePerAttribute],
        isa     => Baz,
        is      => 'ro',
        coerce  => [
            sub {
		        coerce $_[0], from Str, via {}
				}]
        );

=head1 USAGE

This trait allows you to declare a type coercion inline for an attribute. The Role will create an __ANON__ sub TypeConstraint object of the TypeConstraint in the attributes isa parameter. The type coercion can be supplied in one of two methods. The coercion should be supplied to the Moose Attribute coerce parameter.

1. The recomended usage is to supply a hashref declaring the type to coerce from and a subref to be excuted.
    coerce => {$Fromtype => sub {}}

2. Alternatively you can supply and arrayref of coercion coderefs. These should be in the same format as defined in L<Moose::Util::TypeConstraints> and will be passed the __ANON__ subtype as its first argument. If you use this method then you will need to use Moose::Util::TypeConstraints in you module.
    coerce => [sub {coerce $_[0], from Str, via sub {} }]

=head1 AUTHOR

mrf, C<< <mrf at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-moosex-coerceperattribute at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooseX-CoercePerAttribute>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc MooseX::CoercePerAttribute


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=MooseX-CoercePerAttribute>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/MooseX-CoercePerAttribute>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/MooseX-CoercePerAttribute>

=item * Meta CPAN

L<http:://meta.cpan.org/dist/MooseX-CoercePerAttribute/>

=item * Search CPAN

L<http://search.cpan.org/dist/MooseX-CoercePerAttribute/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2012 mrf.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of MooseX::CoercePerAttribute
