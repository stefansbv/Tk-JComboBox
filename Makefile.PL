use 5.008;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Tk::JComboBox',
    'DISTNAME'          => 'Tk-JComboBox',
    'ABSTRACT'          => 'Combo Box similar to the Java Component',
    'VERSION_FROM'	=> 'lib/Tk/JComboBox.pm', # finds $VERSION
    'dist'              => { COMPRESS => 'gzip -9f', SUFFIX => 'gz' },
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (AUTHOR     => 'rcseege <rcseege@comcast.net>') : ()),
);
