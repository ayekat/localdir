#!/usr/bin/env bash
# Environment set and actions performed when logging into bash.
# Written by ayekat a long time ago;
#                             Fixed on a cold sunday afternoon in November 2014.

# ------------------------------------------------------------------------------
# GENERAL {{{

# Load general shell environment (bash and zsh):
. "$XDG_CONFIG_HOME/sh/environment"

# Load general shell login configuration (bash and zsh):
. "$XDG_CONFIG_HOME/sh/login"

# }}}
# ------------------------------------------------------------------------------
# CONFIG {{{

# Since bash does not source the configuration at login, load it here:
. ~/.bashrc

# }}}
# ------------------------------------------------------------------------------
