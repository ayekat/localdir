# Initial ZSH configuration, sourced in all cases.

# This file serves the purpose of "bootstrapping" zsh from the right location,
# namely $XDG_CONFIG_HOME/zsh. But since XDG_CONFIG_HOME might not be set here,
# we need to do it ourselves:
export XDG_CONFIG_HOME=~/.local/etc
export ZDOTDIR=$XDG_CONFIG_HOME/zsh
