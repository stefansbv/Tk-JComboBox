#!/usr/local/bin/perl

require 5;
use strict;  
#use lib qw(/home1/gbartels/textlist);

use Tk;
use Tk::TextList;

my $mw = MainWindow->new;


#my $obj = 'Listbox';
my $obj = 'TextList';

$mw->title($obj);

my @choices = qw 
/
alpha bravo charlie delta echo foxtrot golf hotel india juliet kilo
lima mike november oscar papa quebec romea sierra tango uniform victor
wiskey xray yankee zulu
/;


my $lb = $mw->Scrolled('TextList',
  -selectmode => 'extended',
  -justify => 'right',
  -takefocus => 1,
)->pack;
$lb->insert('end', @choices);

 $mw->bind('<F1>',
sub
{
	print "current selections are: \n";
	my @list = $lb->curselection;
	print join(' ',@list);
	print "\n\n\n";
});

 $mw->bind('<F2>',
sub
{
	print "current tags are: \n";
	my @list = $lb->tagNames;
	print join(' ',@list);
	print "\n\n\n";


});

$lb->tagConfigure('TEST_TAG', foreground=>'red', justify => 'center');
$lb->tagAdd('TEST_TAG', 10,13);
$lb->tagAdd('TEST_TAG', 4);
$lb->tagAddChar('TEST_TAG', 1, 4);

$lb->configure(-width=>20);

MainLoop;
