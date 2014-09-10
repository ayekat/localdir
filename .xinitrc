#!/bin/sh
# Xinit ressource file for starting dwm
# Written by ayekat on a rainy day in october 2012


# First of all, make sure we are in the home directory, to avoid weird default
# working directory paths when opening a shell under X:
cd


# VARIABLES --------------------------------------------------------------------
# NOTE: These are Xorg specific variables only (see also .bash_profile).

# Altera:
# - user is recommended to be in 'plugdev' group, for using USB device
# - quartus starts Quartus
# - vsim starts ModelSim
if [ -d "$HOME"/.local/bin/altera ]; then
	ALTERA="$HOME"/.local/bin/altera
	export PATH="$ALTERA/quartus/bin:$PATH"        # Quartus
	export PATH="$ALTERA/modelsim_ase/linux:$PATH" # ModelSim
	export PATH="$ALTERA/nios2eds/bin:$PATH"       # NIOS2
	export PATH="$ALTERA/nios2eds/sdk2/bin:$PATH"
	export PATH="$ALTERA/nios2eds/bin/gnu/H-i686-pc-linux-gnu/bin:$PATH"
	unset ALTERA
fi


# INPUT (KEYBOARD) -------------------------------------------------------------

# Load swiss keyboard layout and swap Escape and Caps Lock:
setxkbmap -layout ch -option 'caps:swapescape'

# Swap Alt and Windows key:
xmodmap -e 'remove mod4 = Super_L'
xmodmap -e 'remove mod1 = Alt_L'
xmodmap -e 'add mod1 = Super_L'
xmodmap -e 'add mod4 = Alt_L'


# INPUT (MOUSE) ----------------------------------------------------------------

# Thinkpad mouse:
if [ "$HOSTNAME" = 'ixh' ]; then
	dev='TPPS/2 IBM TrackPoint'
	ptr='3 2 1 4 5 6 7 8 9 10'
else
	dev='pointer:Lenovo ThinkPad Compact USB Keyboard with TrackPoint'
	ptr='3 2 1 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22'
fi

# Swap left and right button:
xmodmap -e "pointer = $ptr"

# Enable scrolling through middle click + trackpad:
xinput set-prop "$dev" 'Evdev Wheel Emulation' 1
xinput set-prop "$dev" 'Evdev Wheel Emulation Button' 2
xinput set-prop "$dev" 'Evdev Wheel Emulation Axes' 6 7 4 5

# Enable middle click drag&drop (work-around for above option):
xinput set-prop "$dev" 'Evdev Middle Button Emulation' 1


# OUTPUT -----------------------------------------------------------------------

# Enable colour profile:
lcdadjust &


# SERVICES ---------------------------------------------------------------------

# Start the urxvt daemon:
urxvtd -f -o

# Start a scratchpad:
{ urxvtc -e tmx SCRATCHPAD; } &

# Set the wallpaper:
nitrogen --restore &

# Activate Japanese input:
if [ -e /usr/bin/uim-xim ]; then
	export GTK_IM_MODULE='uim'
	export XMODIFIERS=@im='anthy'
	uim-xim &
fi

# Enable automatic lock on timeout:
scrock --daemon start


# WM ---------------------------------------------------------------------------

# If no WM is specified, default to karuiwm:
[ -z "$WM" ] && WM=karuiwm

# Some Java applications refuse to work correctly when they don't know the WM
# (happens often with tiling WMs); set the WM name to a value known to Java to
# fix that:
case "$WM" in
	xmonad|dwm|karuiwm) wmname LG3D ;;
esac

# Launch WM and log all of its output:
exec "$WM" > /tmp/xorg-"$USER"-"$DISPLAY".log 2>&1
