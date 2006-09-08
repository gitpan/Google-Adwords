use 5.008008;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Google::Adwords',
    VERSION_FROM      => 'lib/Google/Adwords.pm', # finds $VERSION
    PREREQ_PM         => {
        'SOAP::Lite'    => '0.65',
        'version'       => '0.50',
        'Readonly'      => '1.03',
        'Class::Accessor::Chained'  => '0.01',
        'Date::Manip'   => '5.42',
        'Test::Class'   => '0.11',
        'Test::More'    => '0.62',
        'IO::Prompt'    => '0.099004',
    }, 
    ABSTRACT_FROM  => 'lib/Google/Adwords.pm', 
    AUTHOR         => 'Rohan Almeida <rohan@almeida.in>'
);
