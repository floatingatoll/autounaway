# Originally by Larry Daffner. Trepanation to remove all auto-away crap.
# This now will un-AWAY you if you're AWAY and do something. That's it.
# (c) 2012 Richard Soderberg. Same terms as Larry's (c) 2000 below.
# (c) 2000 Larry Daffner (vizzie@airmail.net)
#     You may freely use, modify and distribute this script, as long as
#      1) you leave this notice intact
#      2) you don't pretend my code is yours
#      3) you don't pretend your code is mine
#
# share and enjoy!

# Thanks to Adam Monsen for multiserver and config file fix

use Irssi;
use Irssi::Irc;

use vars qw($VERSION %IRSSI);
$VERSION = "0.1";
%IRSSI = (
    authors => 'Richard Soderberg',
    contact => 'rsod@cpan.org',
    name => 'Autoreturn from away',
    description => 'Automatically returns from away when activity',
    license => 'BSD',
    url => '',
    changed => 'Wed Apr 11 10:21:00 EDT 2012',
    changes => 'Remove auto-away functionality from autoaway.pl'
);

my ($away_state);
$away_state = 0;

#
# away = Set us away or back, within the autoaway system
sub cmd_away {
  my ($data, $server, $channel) = @_;
  
  if ($data eq "") {
    $away_state = 0;
    foreach my $server (Irssi::servers()) {
      $server->command("/AWAY");
    }
  } else {
    $away_state = 1;
    foreach my $server (Irssi::servers()) {
      $server->command("/AWAY $data");
    }
  }
}

sub reset_timer {
  if ($away_state eq 1) {
    $away_state = 0;
    &cmd_away("");
  }
}

Irssi::command_bind('away', 'cmd_away');
Irssi::signal_add('send command', 'reset_timer');
