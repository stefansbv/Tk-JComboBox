#! /usr/local/bin/perl 
## 05_Bugs -- Test Cases for reported bugs

use Carp;
use Tk;
use Tk::JComboBox;
use Test::More tests => 16;

my $mw = MainWindow->new;

###########################################################
## ID: CPAN #11707 - Reported By Ken Prows
## BUG: AutoFind sub does not scroll down to "see" the new
## selection 
## --------------------------------------------------------
## When there are a lot of choices is the combo box, it is 
## convenient to press a letter/number on the keyboard to 
## scroll down to the choices that begin with that letter. 
## The AutoFind sub seems to do this. However, the AutoFind 
## sub only highlights the choice that begins with the 
## letter. It does not scroll down/up so that it is viewable. 
###########################################################
TestItemVisibleAfterAutoFind("readonly");
TestItemVisibleAfterAutoFind("editable");

############################################################
## Test Subroutines
############################################################
sub TestItemVisibleAfterAutoFind
{
   my $mode = shift;
   my @list = (qw/alpha bravo charlie delta echo foxtrot golf hotel india/);
   
   my $jcb = $mw->JComboBox(
      -choices => \@list,
      -maxrows => 4,
      -mode => $mode
   )->pack;
   $mw->update;

   checkItemVisibility($jcb, "a", 0);
   checkItemVisibility($jcb, "i", 8);
   checkItemVisibility($jcb, "e", 4);
   checkItemVisibility($jcb, "a", 0);
   $jcb->destroy;
}

sub checkItemVisibility 
{
   my ($jcb, $key, $expectedIndex) = @_;

   $jcb->clearSelection;
   my $entry = $jcb->Subwidget('Entry');
   my $listbox = $jcb->Subwidget('Listbox');

   $entry->focus;
   $entry->eventGenerate('<KeyPress>', -keysym => $key);
   my ($index) = $listbox->curselection;

   ## Was the expected Index selected?
   is($index, $expectedIndex); 
   
   my $result = "visible";
   $result = "not visible" if $listbox->bbox($index) eq "";
   is($result, "visible");
}


