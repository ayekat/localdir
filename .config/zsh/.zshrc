#!/bin/zsh
# zsh configuration file
# Written by ayekat on a cold night in march 2013.


# ------------------------------------------------------------------------------
# GENERAL (SHRC) {{{
# Load general configuration (bash and zsh).

. ~/.shrc

# }}}
# ------------------------------------------------------------------------------
# PROMPT {{{

# Enable colours:
autoload -U colors && colors

# Define prompt colours:
if [ "$TERM" != 'linux' ]; then
	pc_vim_normal="$(tput setaf 22)$(tput setab 148)"
	pc_vim_insert="$(tput setaf 45)$(tput setab  23)"
else
	pc_vim_normal="$fg[black]$bg[green]"
	pc_vim_insert="$fg[cyan]$bg[blue]"
fi
pc_git_clean="$fg[blue]"
pc_git_ahead="$fg[cyan]"
pc_git_ready="$fg[yellow]"
pc_git_dirty="$fg[red]"
pc_host="$fg[yellow]"
pc_pwd="$fg[green]"
pc_time="$fg[green]"
pc_retval_bad="$fg_bold[red]"
pc_retval_good="$fg[black]"

# Define vim mode strings:
vim_mode_normal='CMD'
vim_mode_insert='INS'
vim_mode=$vim_mode_insert

# VCS settings:
setopt prompt_subst
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' check-for-changes true
zstyle ':vcs_info:git*' formats "%b"
autoload -Uz vcs_info
gstat() { git status --porcelain 2>/dev/null; }
ghead() { git status --porcelain -b 2>/dev/null | head -n 1; }

build_prompt() #{{{
{
	# Set colours depending on mode:
	if [ "$vim_mode" = "$vim_mode_normal" ]; then
		pc_vim="$pc_vim_normal"
	else
		pc_vim="$pc_vim_insert"
	fi

	# Build prompt:
	prompt="%{$pc_vim%} ${vim_mode:-$vim_mode_insert} %{$reset_color%} "
	if [ -n "$git_branch" ]; then
		case $git_state in
			clean) prompt+="%{$pc_git_clean%}" ;;
			ahead) prompt+="%{$pc_git_ahead%}" ;;
			ready) prompt+="%{$pc_git_ready%}" ;;
			dirty) prompt+="%{$pc_git_dirty%}" ;;
		esac
		prompt+="[$git_branch]%{$reset_color%} "
	fi
	[ -n "$SSH_TTY" ] && prompt+="%{$pc_host%}%m:%{$reset_color%}"
	prompt+="%{$pc_pwd%}%~%{$reset_color%}"
	export PROMPT="$prompt "
}
#}}}

build_rprompt() #{{{
{
	# Build right prompt:
	rprompt=''
	rprompt+="%(?.%{$pc_retval_good%}·.%{$pc_retval_bad%}[%?] )%{$reset_color%}"
	if [ -n "$timer" ]; then
		timer_show=$(($SECONDS - $timer))
		if [ ${timer_show} -ne 0 ]; then
			rprompt+="%{$pc_time%}${timer_show} sec%{$reset_color%}"
		fi
		unset timer
		unset timer_show
	fi
	export RPROMPT="$rprompt"
}
#}}}

preexec() {
	timer=${timer:-$SECONDS}
}

precmd() {
	# VCS: update information, reset state:
	vcs_info
	git_state=''
	git_branch="$vcs_info_msg_0_"
	if [ -n "$git_branch" ]; then
		git_state='clean'
		ghead | grep -o 'ahead' >/dev/null && git_state='ahead'
		gstat | grep  '^[MADR].' >/dev/null && git_state='ready'
		gstat | grep  '^.[M?D]' >/dev/null && git_state='dirty'
	fi

	build_prompt
	build_rprompt
}

precmd

# }}}
# ------------------------------------------------------------------------------
# FEEL {{{

# Use vim mode, but keep handy emacs keys in insert mode:
bindkey -v
bindkey -M viins ''    backward-delete-char
bindkey -M viins '[3~' delete-char
bindkey -M viins ''    beginning-of-line
bindkey -M viins ''    end-of-line
bindkey -M viins ''    backward-kill-line
bindkey -M viins ''    up-line-or-history
bindkey -M viins ''    down-line-or-history

# Handler for mode change:
function zle-keymap-select {
	vim_mode="${${KEYMAP/vicmd/${vim_mode_normal}}/(main|viins)/${vim_mode_insert}}"
	build_prompt
	zle reset-prompt
}
zle -N zle-keymap-select

# Handler for after entering a command (reset to insert mode):
function zle-line-finish {
	vim_mode=$vim_mode_insert
	build_prompt
}
zle -N zle-line-finish

# ^C puts us back in insert mode; repropagate to not interfere with dependants:
function TRAPINT() {
	vim_mode=$vim_mode_insert
	build_prompt
	return $((128 + $1))
}

# Disable zsh menu for autocompletion:
#setopt no_auto_menu

# }}}
# ------------------------------------------------------------------------------
# COMPINSTALL {{{

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

HISTFILE=$ZDOTDIR/.zhistory
HISTSIZE=10000              # maximum history size in terminal's memory
SAVEHIST=10000              # maximum size of history file

# }}}
