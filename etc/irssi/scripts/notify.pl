#!/usr/bin/perl
##
## Put me in ~/.irssi/scripts, and then execute the following in irssi:
##
##       /load perl
##       /script load notify
##

use strict;
use Irssi;
use vars qw($VERSION %IRSSI);
use Data::Dumper;

$VERSION = "0.01";
%IRSSI = (
    authors     => 'Luke Macken',
    contact     => 'lewk@csh.rit.edu',
    name        => 'notify.pl',
    description => 'TODO',
    license     => 'GNU General Public License',
    url         => 'http://www.csh.rit.edu/~lewk/code/irssi-notify',
);

sub notify {
    my ($dest, $text, $stripped) = @_;
    my $server = $dest->{server};

	#open(my $fh, '>', '/home/ayekat/irssi_debug');
	#print $fh Dumper($dest);
	#print $fh Dumper($stripped);
	#print $fh "---------------------------------------------------------\n";

    return if (!$server || !(($dest->{level} & MSGLEVEL_HILIGHT)
                             || $dest->{target} !~ /^#|^$/));

    $stripped =~ s/[^a-zA-Z0-9 .,!?\@:\>]//g;
    $stripped =~ s/^ *//g;
    return if ($stripped =~ /^$server->{nick}/);

    system("notify-send 'IRC: $dest->{target}' '$stripped'");
}

Irssi::signal_add('print text', 'notify');
