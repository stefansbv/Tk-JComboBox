use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'AUTHOR'    => 'Rob Seegel (RobSeegel@aol.com)',
    'ABSTRACT'  => 'Java-like ComboBox',
    'NAME'	=> 'Tk::JComboBox',
    'VERSION_FROM' => 'JComboBox.pm', 
    'PREREQ_PM'  => {Tk=>0}
);
