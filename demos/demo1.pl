use Tk;
use Tk::JComboBox;


my $mw = MainWindow->new;

my @items = qw(red blue yellow green orange purple brown black white);

my $jcb = $mw->JComboBox(
  -choices => \@items,
  -highlightthickness => 0,
  -relief => 'groove',
)->pack( -padx => 20, -pady => 20);

MainLoop;
