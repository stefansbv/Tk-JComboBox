#! /usr/local/bin/perl

#################################################################
## Name: 02_Options_Basic.t
## 
## Purpose: Tests all Basic operations - those that implement
##  "standard" Tk options, or redefine them. There are a few 
##  additional ones that configure the appearance of the combobox.
##
## Tested Options: (also tests -mode)
##  -arrowbitmap
##  -arrowimage
##  -background
##  -borderwidth 
##  -cursor
##  -entrywidth
##  -font
##  -foreground
##  -gap
##  -highlightcolor
##  -highlightbackground
##  -pady
##  -selectbackground
##  -selectforeground
##  -selectborderwidth
##  -takefocus
##  -textvariable
##
## NOTE: When creating new tests, be careful not to create a new 
## MainWindow for each Test. I find that it tends to interfere 
## with event generation (if you generate events for tests). 
## Creating a Test subroutine for each test tends to make it 
## easier to comment out tests or move them between modules. Also 
## it makes it easier to police variable use, so that a variable 
## used in one test does not inadvertantly affect another.
################################################################
 
use Carp;
use strict;

use Tk;
use Tk::Font;
use Tk::JComboBox;
use Test::More tests => 198;

####################################################
## Appearance-related Options
####################################################

#####################
## -arrowbitmap (2)
#####################
TestArrowbitmap('editable');
TestArrowbitmap('readonly');

#####################
## -arrowimage (3)
#####################
TestArrowimage('editable');
TestArrowimage('readonly');

#####################
## -background 
#####################
checkDescendantsTest("editable", -background => 'gray');
checkDescendantsTest("readonly", -background => 'gray');

#####################
## -borderwidth
#####################
checkDefaultValue(-borderwidth => 2);
checkCreateGetSet("editable", -borderwidth => 5, ['Frame']);
checkCreateGetSet("readonly", -borderwidth => 5, ['Frame']);

#####################
## -cursor
#####################
checkDescendantsTest("editable", -cursor => 'left_ptr');
checkDescendantsTest("readonly", -cursor => 'left_ptr');

#####################
## -entrywidth
#####################
checkDefaultValue(-entrywidth => -1);
checkCreateGetSet('editable', -entrywidth => 5, [[Entry => '-width']]);
checkCreateGetSet('readonly', -entrywidth => 5, [[Entry => '-width']]);

#####################
## -font
#####################
TestFont('editable');
TestFont('readonly');

#####################
## -foreground
#####################
checkCreateGetSet("editable",
   -foreground => 'red', [qw/Entry Listbox/]);
checkCreateGetSet("readonly",
   -foreground => 'red', [qw/Entry Listbox/]);

#####################
## -gap
#####################
checkDefaultValue(-gap => 0);
checkCreateGetSet("editable", -gap => 2);
checkCreateGetSet("readonly", -gap => 2);

#####################
## -highlightthickness
#####################
checkDefaultValue(-highlightthickness => 0);
checkCreateGetSet("editable", -highlightthickness => 2, ['Frame']);
checkCreateGetSet("readonly", -highlightthickness => 2, ['Frame']);

#####################
## -highlightcolor and
## -highlightbackground
#####################
TestHighlight('editable');
TestHighlight('readonly');

#####################
## -pady
#####################
TestPadY('editable');
TestPadY('readonly');

#####################
## -relief
#####################
TestRelief("editable", "sunken");
TestRelief("readonly", "groove");

#####################
## -selectbackground
#####################
checkCreateGetSet('editable', 
   -selectbackground => 'gray', 
   [qw/Entry Listbox/]);

checkCreateGetSet('readonly',
   -selectbackground => 'blue',
   ['Listbox']);

#####################
## -selectforeground
#####################
checkCreateGetSet('editable', 
   -selectforeground => 'gray', 
   [qw/Entry Listbox/]);

checkCreateGetSet('readonly',
   -selectforeground => 'blue',
   ['Listbox']);

#####################
## -selectborderwidth
#####################
checkCreateGetSet('editable', 
   -selectborderwidth => 4, 
   [qw/Entry Listbox/]);

checkCreateGetSet('readonly',
   -selectborderwidth => 4,
   ['Listbox']);

#####################
## -takefocus
#####################   
TestTakeFocus('readonly');
TestTakeFocus('editable');

#####################
## -textvariable
#####################
TestTextVariable('readonly');
TestTextVariable('editable');

############################################################
## Test Subroutines
############################################################

sub checkCreateGetSet 
{
   my ($mode, $name, $value, $swAR) = @_;
   my ($mw, $w) = Setup(-mode => $mode, $name, $value);
   is($w->cget($name), $value);
   checkSubwidgetOption($w, $name, $value, $swAR);	
   $w->destroy;

   $w = $mw->JComboBox(-mode => $mode);
   $w->configure($name, $value);
   is($w->cget($name), $value);
   checkSubwidgetOption($w, $name, $value, $swAR);
   $mw->destroy;
}

sub checkDescendantsForOption
{
   my ($jcb, $name, $value) = @_;
   my $unexpectedOption = 0;
   foreach my $w ($jcb->Descendants) {
      $unexpectedOption++ if ($w->cget($name) ne $value);
   }
   return $unexpectedOption;
}

sub checkDescendantsTest
{
   my ($mode, $name, $value) = @_;

   ## create
   my ($mw, $jcb) = Setup(-mode => $mode, $name, $value);
   is(checkDescendantsForOption($jcb, $name, $value), 0);

   ## configure method
   $jcb = $mw->JComboBox(-mode => $mode);
   $jcb->configure($name, $value);
   is(checkDescendantsForOption($jcb, $name, $value), 0);
   $mw->destroy;
   checkCreateGetSet($mode, $name => $value);
}

sub checkDefaultValue
{
   my ($option, $value, $mode) = @_;
   my $mw = MainWindow->new;
   my $jcb;
   if ($mode) { $jcb = $mw->JComboBox(-mode => $mode); }
   else       { $jcb = $mw->JComboBox(); }

   is($jcb->cget($option), $value);
   $mw->destroy;
}

sub checkFont
{
   my ($w, $font) = @_;
   is($w->cget(-font)->configure(-family), 
      $font->configure(-family));
   is($w->cget(-font)->configure(-size),
      $font->configure(-size));      
}

sub checkSubwidgetOption 
{
   my ($cw, $name, $value, $swAR) = @_;
   if ($swAR && ref($swAR) eq "ARRAY") {
      foreach my $sw (@{$swAR}) {
         if (ref($sw) eq "ARRAY") {
            is($cw->Subwidget($sw->[0])->cget($sw->[1]),
              $value);
         }
         else {
            is($cw->Subwidget($sw)->cget($name), $value);
         }
      }
   }
}

sub FocusTraverse
{
   my ($main, $currentFocus) = @_;
   if (!defined($currentFocus)) {
      $main->eventGenerate('<Tab>');
      $currentFocus = $main->focusCurrent;
   }
   else {
      $currentFocus->eventGenerate('<Tab>');
      $currentFocus = $main->focusCurrent;
   }
   return $currentFocus;
}

sub Setup
{
   my $pack = 0;
   if ($_[0] eq "pack") {
      shift @_;
      $pack = 1;
    }
   my $mw = MainWindow->new;
   my $jcb = $mw->JComboBox(@_);
   $jcb->pack if $pack;
   return ($mw, $jcb);
}

sub TestArrowbitmap
{
   my $mode = shift;
   
   my $bitmap = "test-$mode";
   my $mw = MainWindow->new;
   my $bits = pack("b9"x4,
      "....1....",
      "...111...",
      "..11111..",
      ".1111111.");
   $mw->DefineBitmap($bitmap,9,4,$bits);
 
   my $jcb = $mw->JComboBox(-mode => $mode, -arrowbitmap => $bitmap);
   is( $jcb->Subwidget('Button')->cget(-bitmap), $bitmap);
   $jcb->destroy;

   $jcb = $mw->JComboBox(-mode => $mode);
   $jcb->configure(-arrowbitmap => $bitmap);
   is( $jcb->Subwidget('Button')->cget(-bitmap), $bitmap);
   $mw->destroy;
}

sub TestArrowimage
{
   my $mode = shift;
   my $mw = MainWindow->new;
   my $image = $mw->Photo("button",
      -format => "gif", 
      -file => "t/button.gif"
   );

   my $jcb = $mw->JComboBox(-mode => $mode, -arrowimage => $image);
   is( $jcb->Subwidget('Button')->cget(-image),
   $jcb->cget(-arrowimage));
   $jcb->destroy;

   $jcb = $mw->JComboBox(-mode => $mode);
   is( $jcb->cget(-arrowimage), undef); 
   $jcb->configure(-arrowimage => $image);
   is( $jcb->Subwidget('Button')->cget(-image),
   $jcb->cget(-arrowimage));

   $image->delete;
   $mw->destroy;
}

sub TestFont
{
   my $mode = shift;
   my $mw = MainWindow->new;

   my $font = $mw->Font(
     -family => 'Times',
     -size => 20
   );

   my $jcb = $mw->JComboBox(
      -mode => $mode,
      -font => $font
   );
   checkFont($jcb, $font);
   checkFont($jcb->Subwidget('Listbox'), $font);
   checkFont($jcb->Subwidget('Entry'), $font);
   $jcb->destroy;

   $jcb = $mw->JComboBox(-mode => $mode);
   $jcb->configure(-font => $font);
   checkFont($jcb, $font);
   checkFont($jcb->Subwidget('Entry'), $font);
   checkFont($jcb->Subwidget('Listbox'), $font);
   $mw->destroy;
}

sub TestHighlight
{
   my $mode = shift;
   checkCreateGetSet($mode, -highlightcolor => 'red', ['Frame']);
   checkCreateGetSet($mode, -highlightbackground => 'blue', ['Frame']);

   my ($mw, $jcb) = Setup(
      -mode => $mode,
      -highlightcolor => 'red',
      -highlightbackground => 'blue'
   );
   $jcb->update;
   $jcb->Focus;
  
   is( $jcb->Subwidget('Frame')->cget(-highlightcolor), 'blue');
   is( $jcb->Subwidget('Frame')->cget(-highlightbackground), 'red');
   $mw->destroy;
}

sub TestPadY
{
   my $mode = shift;
   checkCreateGetSet($mode, -pady => 2);

   my ($mw, $jcb) = Setup(qw/pack -mode/, $mode);
   $jcb->update;

   $jcb->configure(-pady => 5);
   my %gridInfo = $jcb->Subwidget('Button')->gridInfo;
   is( $gridInfo{'-ipady'}, 5);
   $mw->destroy;
}

sub TestRelief 
{
   my ($mode, $relief) = @_;
   checkDefaultValue(-relief => $relief, $mode);
   checkCreateGetSet($mode, -relief => $relief, ['Frame']);
}

sub TestTakeFocus
{
   my $mode = shift;
   my $result;

   checkCreateGetSet($mode, -takefocus => 0, ['Entry']);
   
   ## With takefocus set to 1, focus should go to the (ext) Button,
   ## The Entry subwidget, and then to the next (ext) Button.
   my $main = MainWindow->new;

   my $b1 = $main->Button(-text => "one")->pack;
   my $jcb = $main->JComboBox(
      -mode => $mode,
      -takefocus => 1
   )->pack;
   my $b2 = $main->Button(-text => 'two')->pack;
   $main->focus;
   $main->update;

   ## Verify initial focus
   $b1->focusForce;
   my $currentFocus = $main->focusCurrent;

   is(ref($currentFocus), 'Tk::Button');
   is($currentFocus->cget(-text), 'one');

   ## Verify that subwidget gets focus
   $result = 'Tk::Label' if $mode eq 'readonly';
   $result = 'Tk::Entry' if $mode eq 'editable';
   $currentFocus = FocusTraverse($main, $currentFocus);
   is(ref($currentFocus), $result);

   $currentFocus = FocusTraverse($main, $currentFocus);
   is(ref($currentFocus), 'Tk::Button');
   is($currentFocus->cget(-text), 'two');

   ## Now with takefocus set to 0, focus should skip the
   ## the Entry subwidget, and go from one ext Button to the
   ## other.
   $jcb->configure(-takefocus => 0);
   $currentFocus = FocusTraverse($main, $currentFocus);
   is(ref($currentFocus), 'Tk::Button');
   is($currentFocus->cget(-text), 'one');

   $currentFocus = FocusTraverse($main, $currentFocus);
   is(ref($currentFocus), 'Tk::Button');
   is($currentFocus->cget(-text), 'two');

   $main->destroy;
}

sub TestTextVariable 
{
   my $mode = shift;
   my $textVar;

   checkCreateGetSet($mode, -textvariable => \$textVar, ['Entry']);

   my ($mw, $jcb) = Setup(-mode => $mode);
   $jcb->configure(-textvariable => \$textVar);

   $jcb->DisplayedName("test1");
   $jcb->update;
   is($textVar, "test1");

   $jcb->addItem("test2", -selected => 1);
   $jcb->update;
   is($textVar, "test2");

   $mw->destroy;
}






