#!/bin/sh
# Calibrates the screen and creates an ICC profile.
# You may need to add yourself to the plugdev group.
# The ICC profile can be applied with `dispwin PROFILE.icc'.

if [ $# -ne 1 ]; then
	echo "usage: $0 PROFILE"
	exit 1
fi
if [ -e "$1".icc -o -e "$1".cal ]; then
	echo "there is already a colour profile for $1" >&2
	exit 1
fi

dispcal -v -yl -P .5,.5,1.5 -o "$1"

