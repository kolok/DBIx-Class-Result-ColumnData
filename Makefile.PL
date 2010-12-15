use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'DBIx::Class::Result::ColumnData',
    AUTHOR              => q{Nicolas Oudard <nicolas@oudard.org>},
    VERSION_FROM        => 'lib/DBIx/Class/Result/ColumnData.pm',
    LICENSE             => 'perl',
    PL_FILES            => {},
    PREREQ_PM => {
        'DBIx::Class'=> 0,
        'DateTime' => 0.65,
        'DateTime::Format::SQLite' => 0.11,
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'DBIx-Class-Result-ColumnData-*' },
);
