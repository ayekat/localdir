#!/usr/bin/env perl
# Prints a table demonstrating all ANSI colour sequences.
# This is a more performant rewrite of a bash script that did the same thing.
# Written by ayekat on a boring monday evening in february 2013.

my @colours = ('black','red','green','yellow','blue','magenta','cyan','white');

# Basic ANSI colour sequences:
for ($fg = 30; $fg < 38; $fg++) {
	for ($th = 0; $th <= 1; $th++) {
		printf("%8s  \e[%d;%dm %d ",
			$th ? '' : $colours[$fg-30], $th, $fg, $fg);
		for ($bg = 40; $bg < 48; $bg++) {
			printf("\e[%d;%d;%dm %d;%d\e[0;%d;%dm ",
					$th, $fg, $bg, $fg, $bg, $fg, $bg);
		}
		print "\e[0m\n";
	}
}

print "\n";

# Extended 6x6x6 cube:
for ($l = 0; $l <=3; $l+=3) {
	for ($b = 0; $b < 6; $b++) {
		for ($g = $l; $g < $l+3; $g++) {
			for ($r = 0; $r < 6; $r++) {
				$c = 16+($r*36)+($g*6)+$b;
				printf("\e[%d;48;5;%dm %3d \e[0m", $l==3 ? 30 : 37, $c, $c);
			}
			print " ";
		}
		print "\n";
	}
	printf "\n";
}

# Grayscale:
for ($c = 232; $c < 256; $c++) {
	if ($c == 244) {print "\n";}
	printf("\e[%d;48;5;%dm %d \e[0m", $c >= 244 ? 30 : 37, $c, $c);
	# ugly linebreak:
}
print "\n";

# Some non-colour escape sequences:
#  1: bold
#  2: thin/weak
#  4: underlined
#  7: inverted
#  8: hidden
#  9: canceled
