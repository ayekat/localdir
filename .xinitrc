#!/bin/bash
# Xinit ressource file for starting dwm
# Written by ayekat on a rainy day in october 2012


# First of all, make sure we are in the home directory, to avoid weird default
# working directory paths when opening a shell under X:
cd


# MONITOR OPTIONS --------------------------------------------------------------

# Get the number of monitors:
export NUMSCREENS=$(xrandr | grep ' connected ' | wc -l)

# Activate (LCD) monitor color calibration:
lcdadjust start

# Xrandr examples (not for daily use, graphic card driver usually takes care of
# this):
#xrandr --output VGA-0 --mode 1920x1050
#xrandr --output VGA-0 --right-of LVDS
#xrandr --output VGA-0 --off


# DWM --------------------------------------------------------------------------

# Some Java applications refuse to work correctly when they don't know the WM.
# Set the WM name to a known value to fix that:
wmname LG3D


# VARIABLES --------------------------------------------------------------------
# NOTE: These are Xorg specific variables only (see also .bash_profile).

# Altera:
# (user is recommended to be in 'plugdev' group, for using USB device)
if [[ -d $HOME/.local/bin/altera ]]; then
	ALTERA="$HOME/.local/bin/altera"
	export PATH="$ALTERA/quartus/bin:$PATH"      # Quartus
	export PATH="$ALTERA/modelsim_ase/bin:$PATH" # ModelSim
	export PATH="$ALTERA/nios2eds/bin:$PATH"     # NIOS2
	export PATH="$ALTERA/nios2eds/sdk2/bin:$PATH"
	export PATH="$ALTERA/nios2eds/bin/gnu/H-i686-pc-linux-gnu/bin:$PATH"
	unset ALTERA
fi


# SERVICES ---------------------------------------------------------------------

# Start the thunar daemon:
thunar --daemon &

# Set the wallpaper:
nitrogen --restore &

# Activate Japanese input:
if [[ -e /usr/bin/uim-xim ]]; then
	export GTK_IM_MODULE='uim'
	export XMODIFIERS=@im='anthy'
	uim-xim &
fi


# SESSION ----------------------------------------------------------------------

# dwmloop runs dwm in a loop, to allow on-the-fly restarts.
# See the file for more information:
exec dwmloop

