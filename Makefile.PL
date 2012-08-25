use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'MooseX::CoercePerAttribute',
    AUTHOR              => q{mrf <mrf@cpan.org>},
    VERSION_FROM        => 'lib/MooseX/CoercePerAttribute.pm',
    ABSTRACT_FROM       => 'lib/MooseX/CoercePerAttribute.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More'    => 0,
        'Moose'         => 0,
        'Moose::Util::TypeConstraints' => 0,
        'Data::Dumper'  => 0,
        'Moose::Role'   => 0,
        'Moose::Util'   => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'MooseX-CoercePerAttribute-*' },
);
