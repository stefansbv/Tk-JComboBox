use Tk;
use Tk::JComboBox;


my $mw = MainWindow->new;

my @items = qw(red blue yellow green orange purple brown black white);

my $value;

my $jcb = $mw->JComboBox(
  -mode => 'editable',
  -listbackground => 'white',
  -highlightthickness => 0,
  -textvariable => \$value,
  -relief => 'sunken',  
  -maxrows => 5,
  -choices => [
    @items,
    { -name => 'grey', -selected => 1}
  ]
)->pack( -padx => 20, -pady => 20);

$mw->Button(
  -text => 'print value',
  -command => sub {
    print $jcb->getSelectedValue . "\n";
    print $value . "\n";
})->pack;
    


MainLoop;
