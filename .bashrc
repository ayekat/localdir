#!/usr/bin/sh
# bash configuration file
# Written by ayekat on a rainy day in 2009.


# Load general configuration (bash and zsh).
# Contains:
# - SYSTEM
# - ALIASES
# - START-UP ACTIONS
. ~/.shrc


# ------------------------------------------------------------------------------
# START {{{

# Check if this is an interactive session:
test -z "$PS1" && return

# }}}
# ------------------------------------------------------------------------------
# PROMPT {{{

# Vim statusline colours (fg):
#  22 normal prompt
# 208 visual prompt
#   7 normal filename
# 244 normal middle
#   8 insert prompt
#   7 insert filename
#  45 insert middle
#
# Vim statusline colours (bg):
# 148 normal prompt
#  52 visual prompt
#   8 normal filename
#   0 normal middle
#   7 insert prompt
#  31 insert filename
#  23 insert middle

# Create prompt:
ayeprompt_assemble() {
	git rev-parse 2> /dev/null && git_set=1
	PS1=""

	# Hostname (only if SSH):
	if [ -z "$SSH_TTY" ]; then
		if [ ! $git_set ]; then
			if [ $TERM = 'linux' ]; then
				PS1+="\[\e[1m\]"
				for c in 32 33 31 35 34 36; do
					PS1+="\[\e[${c}m\]:"
				done
			else
				for c in 10 11 9 13 12 14; do
					PS1+="\[\e[38;5;${c}m\]:"
				done
			fi
			PS1+="\[\e[0m\] "
		fi
	else
		PS1+="\[\e[35m\]\h "
	fi
	PS1+="\[\e[0m\]"

	# Git branch (only if in git repo):
	if [ $git_set ]; then
		git_diff=$(git diff --shortstat )
		git_branch=$(git branch | grep '*' | cut -c 3-)
		[ -z $git_branch ] && git_branch='empty'
		git_status=$(git status -s)
		git_ahead=$(git status -sb | grep ahead)
		if [ -z "$git_diff" ] && [ -z "$git_status" ]; then
			if [ -z "$git_ahead" ]; then git_colour=34; else git_colour=36; fi
		else
			git_colour=33
		fi
		PS1+="\[\e[${git_colour}m\][$git_branch]\[\e[0m\] "
		unset git_colour
	fi

	# Working directory
	PS1+="\[\e[32m\]\w\[\e[0m\] "

	# Clean variables:
	unset git_set
	unset git_status
	unset git_diff
	unset git_branch
}

# Configure Prompt:
PROMPT_COMMAND='ayeprompt_assemble'

# }}}
# ------------------------------------------------------------------------------
# FEEL {{{

# Enable tab completion with sudo:
complete -cf sudo

# Enable Vi/ViM-like behaviour (default: emacs):
#set -o vi

# }}}
# ------------------------------------------------------------------------------
# HISTORY {{{

export HISTIGNORE='&:[bf]g:exit'
export HISTSIZE=10000

# }}}

