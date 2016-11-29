#!/usr/bin/env zsh
# Environment set and actions performed when logging into zsh.
# Written by ayekat a long time ago;
#                             Fixed on a cold sunday afternoon in November 2014.

# ------------------------------------------------------------------------------
# GENERAL {{{

# Make zsh handle IFS correctly:
setopt SH_WORD_SPLIT

# Load general shell environment (bash and zsh):
. "$XDG_CONFIG_HOME/sh/environment"

# Load general shell login configuration (bash and zsh):
. "$XDG_CONFIG_HOME/sh/login"

# }}}
# ------------------------------------------------------------------------------
