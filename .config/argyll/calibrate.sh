#!/bin/bash
# Calibrates the screen and creates an ICC profile.
# The ICC profile can be applied with `dispwin $HOSTNAME.icc'.

if [[ -e $HOSTNAME.icc ]]; then
	printf "error: %s.icc already exists\n" $HOSTNAME
else
	dispcal -v -yl -P .5,.5,1.5 -o $HOSTNAME
fi

