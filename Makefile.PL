use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'Genealogy::Ahnentafel',
    VERSION_FROM      => 'lib/Genealogy/Ahnentafel.pm',
    PREREQ_PM         => {
        Moo                  => 0,
        MooX::ClassAttribute => 0,
        Types::Standard      => 0,
        Type::Utils          => 0,
},
    BUILD_REQUIRES    => {
        Test::Exception      => 0,
    },
    ABSTRACT_FROM     => 'lib/Genealogy/Ahnentafel.pm',
    AUTHOR            => 'Dave Cross <dave@perlhacks.com>',
    LICENSE           => 'perl',
);
