use strict;
use warnings;

use Test::More;
use Tk;
use Tk::Font;
use Tk::JComboBox;

use lib qw( lib ../lib );

BEGIN {
    unless ( $ENV{DISPLAY} or $^O eq 'MSWin32' ) {
        plan skip_all => 'Needs DISPLAY';
        exit 0;
    }

    eval { use Tk; };
    if ($@) {
        plan( skip_all => 'Perl Tk is required for this test' );
    }

    plan tests => 10;
}

my $mw = tkinit;
$mw->geometry('+20+20');

TestTakeFocus('readonly');

Tk::MainLoop;

sub TestTakeFocus {
    my $mode = shift;

    my $b1 = $mw->Button(-text => "one")->pack;
    my $jcb;
    eval {
        $jcb = $mw->JComboBox(
            -mode       => $mode,
            -entrywidth => 15,
            -takefocus  => 1,
        );
    };
    ok(!$@, 'create JCB');

    $jcb->pack( -expand => 1, -fill => 'both');
    my $b2 = $mw->Button(-text => 'two')->pack;

    my $delay = 10;

    ## Verify initial focus
    $mw->after(
        $delay * 100,
        sub {
            $mw->focus;
            $mw->update;

            $b1->focusForce;
            my $currentFocus = $mw->focusCurrent;

            is(ref($currentFocus), 'Tk::Button', "focus on 'Tk::Button'");
            is($currentFocus->cget('-text'), 'one', "button label is 'one'");
        }
    );

    $delay++;

    ## Verify that subwidget gets focus

    $mw->focus;
    $mw->update;
    my $currentFocus = $mw->focusCurrent;
    diag "Focus is on ", ref$currentFocus, "\n";

    my $result;
    $result = 'Tk::Label' if $mode eq 'readonly';
    $result = 'Tk::Entry' if $mode eq 'editable';

    $mw->after(
        $delay * 100,
        sub {
            $currentFocus = FocusTraverse($mw, $currentFocus);
            is(ref($currentFocus), $result, "focus on '$result'");
        }
    );

    $delay++;

    $mw->after(
        $delay * 100,
        sub {
            $currentFocus = FocusTraverse($mw, $currentFocus);
            is(ref($currentFocus), 'Tk::Button', "focus on 'Tk::Button'");
            is($currentFocus->cget('-text'), 'two', "button label is 'two'");
        }
    );

    ## Now with takefocus set to 0, focus should skip the
    ## the Entry subwidget, and go from one ext Button to the
    ## other.
    $delay++;

    $mw->after(
        $delay * 100,
        sub {
            $jcb->configure(-takefocus => 0);
            $currentFocus = FocusTraverse($mw, $currentFocus);
            is(ref($currentFocus), 'Tk::Button', "focus on 'Tk::Button'");
            is($currentFocus->cget('-text'), 'one', "button label is 'one'");
        }
    );

    $delay++;

    $mw->after(
        $delay * 100,
        sub {
            $currentFocus = FocusTraverse($mw, $currentFocus);
            is(ref($currentFocus), 'Tk::Button', "focus on 'Tk::Button'");
            is($currentFocus->cget('-text'), 'two', "button label is 'two'");
        }
    );

    $delay++;

    $mw->after( $delay * 100, sub { $mw->destroy } );
}

sub FocusTraverse {
    my ($main, $currentFocus) = @_;

    if (defined $currentFocus ) {
        $currentFocus->eventGenerate('<Tab>');
        $currentFocus = $main->focusCurrent;
    }
    else {
        $main->eventGenerate('<Tab>');
        $currentFocus = $main->focusCurrent;
    }

    return $currentFocus;
}

#-- End test
