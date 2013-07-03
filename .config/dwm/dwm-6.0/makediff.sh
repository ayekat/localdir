#!/bin/sh

diff -u dwm.c{.orig,} > dwm-6.0.diff
sed -i 's/--- dwm.c.orig/--- a\/dwm.c/' dwm-6.0.diff
sed -i 's/+++ dwm.c/+++ b\/dwm.c/' dwm-6.0.diff

