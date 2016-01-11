use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Text::Quote::Self',
    AUTHOR              => q{Konstantin S. Uvarin <khedin@gmail.com>},
    VERSION_FROM        => 'lib/Text/Quote/Self.pm',
    ABSTRACT_FROM       => 'lib/Text/Quote/Self.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Text-Escape-Self-*' },
);
