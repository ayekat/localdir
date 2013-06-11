#!/bin/sh
# zsh configuration file
# Written by ayekat on a cold night in march 2013.


# Load general configuration (bash and zsh).
# Contains:
# - SYSTEM
# - ALIASES
# - START-UP ACTIONS
. ~/.shrc


# ------------------------------------------------------------------------------
# LOOK {{{

# Enable colours:
autoload -U colors && colors

# Enable and format VCS:
setopt prompt_subst         # override instead of append updated prompt
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' stagedstr " %{$fg[green]%}●"
zstyle ':vcs_info:*' unstagedstr " %{$fg[red]%}●"
zstyle ':vcs_info:git*' check-for-changes true
zstyle ':vcs_info:git*' formats \
		"%%B%{$fg[black]%}[%{$fg[green]%}%b%%b%u%c%%B%{$fg[black]%}]%%b"
precmd() { vcs_info; }      # update before displaying prompt

# Left prompt (hostname + pwd):
[ $IS_DESKTOP ] && PROMPT="%{$fg[yellow]%}" || PROMPT="%{$fg[magenta]%}"
PROMPT+="%m "
PROMPT+="%{$fg[green]%}%~%{$reset_color%} "

# Right prompt:
RPROMPT='${vcs_info_msg_0_}'

# Constantly updating clock (*yuck!*)
# Thanks to this guy: http://www.zsh.org/mla/users/2007/msg00944.html
# It's recommended to disable this, as in theory it may sound nifty to have a
# timestamp for each command, but in practice it causes annoying things.
TMOUT=1                     # timeout (interval)
TRAPALRM() {                # event, every $TMOUT seconds:
	zle reset-prompt        # -> update the prompt
}
RPROMPT+='%{$fg[blue]%}[%s$(date +%H:%M:%S)]%{$reset_color%}'

# }}}
# ------------------------------------------------------------------------------
# FEEL {{{

# Enable autocompletion feature:
autoload -Uz compinit && compinit

# I use vim, but I'm used to emacs-keybinds in the terminal:
bindkey -e

# However we don't need to exagerate, do we?
# github: should look like "^[[3~"
bindkey "[3~" delete-char

# Disable zsh menu for autocompletion:
setopt no_auto_menu

# Enable autocompletion for special directories (such as '..'):
zstyle ':completion:*' special-dirs true

# }}}
# ------------------------------------------------------------------------------
# HISTORY {{{

setopt append_history       # append, instead of overwrite
setopt hist_ignore_dups     # ignore duplicate commands
setopt share_history        # allow to acces to history of previous shells

HISTFILE=$HOME/.zhistory
HISTSIZE=10000              # maximum history size in terminal's memory
SAVEHIST=10000              # maximum size of history file

# }}}

