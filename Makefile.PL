use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Google::Adwords',
    VERSION_FROM      => 'lib/Google/Adwords.pm', # finds $VERSION
    PREREQ_PM         => {
        'SOAP::Lite'    => 0,
        'Crypt::SSLeay' => 0,
        'version'       => 0,
        'Readonly'      => 0,
        'Class::Accessor::Chained'  => 0,
        'Date::Manip'   => 0,
        'Test::Class'   => 0,
        'Test::More'    => 0,
        'Test::MockModule'    => 0,
        'HTML::Entities'    => 0,
    }, 
    ABSTRACT_FROM  => 'lib/Google/Adwords.pm', 
    AUTHOR         => 'Rohan Almeida <rohan@almeida.in>'
);
