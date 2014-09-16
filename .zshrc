#!/bin/zsh
# zsh configuration file
# Written by ayekat on a cold night in march 2013.


# ------------------------------------------------------------------------------
# GENERAL (SHRC) {{{
# Load general configuration (bash and zsh).
# Contains:
# - SYSTEM
# - ALIASES
# - START-UP ACTIONS
. ~/.shrc

# }}}
# ------------------------------------------------------------------------------
# LOOK {{{

# Enable colours:
autoload -U colors && colors

# VCS settings:
setopt prompt_subst
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' check-for-changes true
zstyle ':vcs_info:git*' formats "[%b]"
autoload -Uz vcs_info

# Run before the prompt is shown:
precmd() {
	# git info:
	vcs_info
	git_untracked="$(
	[ -n "$(git status --porcelain 2>/dev/null | grep '^??')" ] \
		&& printf "$fg[red]")"
	git_unstaged="$(
	[ -n "$(git status --porcelain 2>/dev/null | grep '^.M')" ] \
		&& printf "$fg[red]")"
	git_staged="$(
	[ -n "$(git status --porcelain 2>/dev/null | grep '^M.')" ] \
		&& printf "$fg[yellow]")"
	git_ahead="$(
	[ -n "$(git status --porcelain -b 2>/dev/null|head -n 1|grep -o ahead)" ] \
		&& printf "$fg[cyan]")"
	if [ -n "$vcs_info_msg_0_" ]; then
		vcs_git="%{$fg[blue]$git_ahead$git_staged$git_unstaged$git_untracked%}"
		vcs_git+="$vcs_info_msg_0_"
	else
		vcs_git=""
	fi

	# measure execution time:
	rprompt="%(?.%{$fg[black]%},.%{$fg_bold[red]%}[%?])%{$reset_color%}"
	if [ -n "$timer" ]; then
		timer_show=$(($SECONDS - $timer))
		if [ ${timer_show} -ne 0 ]; then
			rprompt+=" %{$fg[blue]%}${timer_show} sec%{$reset_color%}"
		fi
		unset timer
		unset timer_show
	fi
	export RPROMPT="$rprompt"
}

# Run before a command is executed:
preexec() {
	timer=${timer:-$SECONDS}
}

# Left prompt: pretty dots or hostname:
vcs_empty=""
if [ -n "$SSH_TTY" ]; then
	vcs_empty+="%{$fg[magenta]%}%m"
elif [ $TERM = 'linux' ]; then
	for c in green yellow red magenta blue cyan; do
		vcs_empty+="%{$fg_bold[$c]%}:"
	done
else
	for c in 10 11 9 13 12 14; do
		vcs_empty+="%{$(tput setaf $c)%}:"
	done
fi
PROMPT='${vcs_git:-${vcs_empty}} %{$fg[green]%}%~%{$reset_color%} '

# }}}
# ------------------------------------------------------------------------------
# FEEL {{{

# I use vim, but I'm used to emacs-keybinds in the terminal:
bindkey -e

# However we don't need to exagerate, do we?
# github: should look like "^[[3~"
bindkey "[3~" delete-char

# Disable zsh menu for autocompletion:
#setopt no_auto_menu

# The following lines were added by compinstall
zstyle ':completion:*' format "[%{$fg_bold[default]%}%d%{$reset_color%}]"
zstyle ':completion:*' group-name ''
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' ignore-parents parent pwd
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' squeeze-slashes true
zstyle :compinstall filename '/home/ayekat/.zshrc'
autoload -Uz compinit && compinit
# End of lines added by compinstall

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
