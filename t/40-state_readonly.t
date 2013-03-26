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

    plan tests => 6;
}

my $mw = tkinit;
$mw->geometry('+20+20');

TestState('readonly');

Tk::MainLoop;

sub TestState {
    my $mode = shift;

    my $b1 = $mw->Button(-text => "one")->pack;
    my $jcb;
    eval {
        $jcb = $mw->JComboBox(
            -mode       => $mode,
            -entrywidth => 15,
            -state      => 'normal',
        );
    }->pack;
    ok(!$@, 'create JCB');
    my $b2 = $mw->Button(-text => 'two')->pack;

    $mw->update;
    $b1->focusForce;

    my $delay = 10;

    ## Verify initial focus
    my $w;
    $mw->after(
        $delay * 100,
        sub {
            $b1->focusNext;
            $w = $mw->focusCurrent;
            is( ref($w), 'Tk::Entry', "focus on 'Tk::Entry'" )
                if $mode eq 'editable';
            is( ref($w), 'Tk::Label', "focus on 'Tk::Label'" )
                if $mode eq 'readonly';
            }
    );

    $delay++;

    $mw->after(
        $delay * 100,
        sub {
            $w->focusNext;
            $w = $mw->focusCurrent;
            is(ref($w), 'Tk::Button', "focus on 'Tk::Button'");
            is($w->cget('-text'), 'two', "button label is 'two'");
        }
    );

    $delay++;

    $mw->after(
        $delay * 100,
        sub {
            $jcb->configure(-state => 'disabled');

            $b1->focusForce;
            $b1->focusNext;
            $w = $mw->focusCurrent;
            is(ref($w), 'Tk::Button', "focus on 'Tk::Button'");
            is($w->cget('-text'), 'two', "button label is 'two'");
        }
    );

    $delay++;

    $mw->after( $delay * 100, sub { $mw->destroy } );
}

#-- End test
