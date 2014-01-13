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

# This was removed, dunno why:
export XDG_CONFIG_HOME="$HOME"/.config


# OUTPUT -----------------------------------------------------------------------

# Enable colour profile:
lcdadjust &


# INPUT ------------------------------------------------------------------------

# Load swiss keyboard layout and swap Escape and Caps Lock:
setxkbmap -layout ch -option 'caps:swapescape' &

# Sanitise Thinkpad mouse:
if [ "$HOSTNAME" = 'ixh' ]; then
	# Swap left and right button:
	xmodmap -e 'pointer = 3 2 1 4 5 6 7 8 9 10 11 12'

	# Enable scrolling through middle click + trackpad:
	xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation" 1
	xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Button" 2
	xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Axes" 6 7 4 5

	# Enable middle click drag&drop (work-around for above option):
	xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Middle Button Emulation" 1

	# Disable touchpad, it's horrible:
	synclient TouchpadOff=1
fi


# SERVICES ---------------------------------------------------------------------

# Start the thunar daemon:
thunar --daemon &

# Set the wallpaper:
nitrogen --restore &

# Activate Japanese input:
if [ -e /usr/bin/uim-xim ]; then
	export GTK_IM_MODULE='uim'
	export XMODIFIERS=@im='anthy'
	uim-xim &
fi

# Apply Xmodmap if it exists:
[ -e ~/.Xmodmap ] && xmodmap ~/.Xmodmap

# Enable automatic lock on timeout:
ayelock start 5

# Enable wallpaper cycling:
#nitrogencycle &


# SERVICES (TERMINALS) ---------------------------------------------------------

# Add personal font directory:
xset +fp $HOME/.local/share/fonts/

# Start the urxvt daemon:
#urxvtd &

# Start a scratchpad:
{ xfce4-terminal --execute tmx SCRATCHPAD; } &


# WM ---------------------------------------------------------------------------

# If no WM is specified, default to karuiwm:
[ -z "$WM" ] && WM=karuiwm

# Some Java applications refuse to work correctly when they don't know the WM.
# Set the WM name to a value known to Java to fix that:
case "$WM" in
	xmonad|dwm|karuiwm) wmname LG3D ;;
	openbox) ;;
esac
exec "$WM" > /tmp/xorg-"$USER"-"$DISPLAY".log 2>&1

