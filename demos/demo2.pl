use Tk;
use Tk::JComboBox;


my $mw = MainWindow->new;

my @items = qw(red blue yellow green orange purple brown black white);

my $jcb = $mw->JComboBox(
  -mode => 'editable',
  -listbackground => 'white',
  -highlightthickness => 0,
  -relief => 'sunken',  
  -maxrows => 5,
  -choices => [
    @items,
    { -name => 'grey', -selected => 1}
  ]
)->pack( -padx => 20, -pady => 20);

MainLoop;
