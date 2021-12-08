# Initial ZSH configuration, sourced in all cases.

# This file serves a single purpose: Set ZDOTDIR, so that all subsequent ZSH
# files are read from $XDG_CONFIG_HOME/zsh. The rest of the environment setup
# (including the declaration of the XDG basedir variables themselves) is then
# handled there.
#
# Note that because $XDG_CONFIG_HOME might not yet be set correctly here, we
# have to hardcode the path:
export ZDOTDIR=~/.local/etc/zsh
