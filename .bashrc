#!/usr/bin/env bash
# Configuration for interactive bash.
# Written by ayekat on a rainy day in 2009.

# ------------------------------------------------------------------------------
# START {{{

# bash does not check whether sourcing bashrc only on interactive shells:
[ -z "$PS1" ] && return

# }}}
# ------------------------------------------------------------------------------
# GENERAL {{{

# Load general configuration (bash and zsh):
. $XDG_CONFIG_HOME/sh/config

# }}}
# ------------------------------------------------------------------------------
# PROMPT {{{

# Create prompt:
ayeprompt_assemble()
{
	PROMPT=''

	# Background jobs:
	jobs_count="$(jobs | awk '{print $2}' | grep -v 'Done' | wc -l)"
	if [ $jobs_count -ne 0 ]; then
		PROMPT+="\[${pc_jobs}\] $jobs_count \[\033[0m\] "
	fi

	# VCS (dotfiles):
	vcs_update "$XDG_CONFIG_HOME/dotfiles"
	case "$vcs_state" in (ahead|ready|dirty|merge)
		case "$vcs_state" in
			ahead) PROMPT+="\[$pc_dot_ahead\]" ;;
			ready) PROMPT+="\[$pc_dot_ready\]" ;;
			dirty) PROMPT+="\[$pc_dot_dirty\]" ;;
			merge) PROMPT+="\[$pc_dot_merge\]" ;;
		esac
		PROMPT+=" . \[\033[0m\] "
	esac

	# VCS:
	vcs_update "$(pwd)"
	if [ -n "$vcs_state" ]; then
		case $vcs_state in
			huge)  PROMPT+="\[$pc_vcs_huge\]"  ;;
			clean) PROMPT+="\[$pc_vcs_clean\]" ;;
			ahead) PROMPT+="\[$pc_vcs_ahead\]" ;;
			ready) PROMPT+="\[$pc_vcs_ready\]" ;;
			dirty) PROMPT+="\[$pc_vcs_dirty\]" ;;
			merge) PROMPT+="\[$pc_vcs_merge\]" ;;
		esac
		PROMPT+="[$vcs_branch]\[\033[0m\] "
	fi

	# Hostname (if SSH):
	if [ -n "$SSH_CONNECTION" ]; then
		PROMPT+="\[$pc_host\]\h:\[\033[0m\]"
	elif [ -z "$vcs_branch" ]; then
		if [ "$TERM" = 'linux' ]; then
			PROMPT+="\[\033[1m\]"
			for c in 32 33 31 35 34 36; do
				PROMPT+="\[\033[${c}m\]:"
			done
		else
			for c in 10 11 9 13 12 14; do
				PROMPT+="\[\033[38;5;${c}m\]:"
			done
		fi
		PROMPT+="\[\033[0m\] "
	fi

	# PWD:
	PROMPT+="\[$pc_pwd\]\w\[\033[0m\] "

	# Root?
	if [ $(id -u) = 0 ]; then
		PROMPT+="\[$pc_prompt\]#\[\033[0m\] "
	fi

	PS1="$PROMPT"
}

# Print Prompt:
PROMPT_COMMAND='ayeprompt_assemble'

# }}}
# ------------------------------------------------------------------------------
# FEEL {{{

# Enable tab completion with sudo/man:
complete -cf sudo
complete -cf man

# Enable Vi/ViM-like behaviour (default: as defined in .inputrc):
#set -o vi
set -o emacs

# Update dimension information upon resize:
shopt -s checkwinsize

# }}}
# ------------------------------------------------------------------------------
# HISTORY {{{

export HISTFILE=$XDG_LOG_HOME/bash_history
export HISTIGNORE='&:[bf]g:exit'
export HISTSIZE=100000
export HISTFILESIZE=100000

# }}}
#-------------------------------------------------------------------------------
# BANDCAMP {{{
# Thanks to d3lxa

bcplay () {
	mplayer -novideo -playlist <(bcurl "$1" | grep '^http://')
	echo -e '\a'
}

bcurl () {
	curl -L -sS "$1" | perl -ne 'print "$1\n" while (m{"mp3-128":"([^"]+)"}g); print "tag: $1\n" if m{<a class="tag" href="[^"]+/([^"]+)};'
}

# }}}
# ------------------------------------------------------------------------------
