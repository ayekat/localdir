#!/bin/zsh
# zsh configuration file
# Written by ayekat on a cold night in march 2013.


# ------------------------------------------------------------------------------
# GENERAL (SHRC) {{{
# Load general configuration (bash and zsh).

. ~/.config/sh/shrc

# }}}
# ------------------------------------------------------------------------------
# LOOK {{{

# Enable syntax highlighting:
path_syntax=/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -e "$path_syntax" ] && . "$path_syntax"
unset path_syntax

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
pc_git_clean="$fg[green]"
pc_git_ahead="$fg[cyan]"
pc_git_ready="$fg[yellow]"
pc_git_dirty="$fg[red]"
pc_host="$fg[magenta]"
pc_pwd="$fg[blue]"
pc_prompt="$fg_bold[red]"
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
	PROMPT=''

	# Set colours depending on mode:
	if [ "$vim_mode" = "$vim_mode_normal" ]; then
		pc_vim="$pc_vim_normal"
	else
		pc_vim="$pc_vim_insert"
	fi

	# Build prompt:
	PROMPT+="%{$pc_vim%} ${vim_mode:-$vim_mode_insert} %{$reset_color%} "
	if [ -n "$git_branch" ]; then
		case $git_state in
			clean) PROMPT+="%{$pc_git_clean%}" ;;
			ahead) PROMPT+="%{$pc_git_ahead%}" ;;
			ready) PROMPT+="%{$pc_git_ready%}" ;;
			dirty) PROMPT+="%{$pc_git_dirty%}" ;;
		esac
		PROMPT+="[$git_branch]%{$reset_color%} "
	fi
	[ -n "$SSH_CONNECTION" ] && PROMPT+="%{$pc_host%}%M:%{$reset_color%}"
	PROMPT+="%{$pc_pwd%}%~%{$reset_color%}"
	if [ $(id -u) = 0 ]; then
		PROMPT+="%{$pc_prompt%} #%{$reset_color%}"
	fi
	PROMPT+=' '

	export PROMPT
}
#}}}

build_rprompt() #{{{
{
	RPROMPT=''

	# Last command's return value:
	RPROMPT+="%(?..%{$pc_retval_bad%}[%?]%{$reset_color%})"

	# Last command's duration:
	if [ -n "$timer" ]; then
		timer_total=$(($SECONDS - $timer))
		timer_sec=$(($timer_total % 60))
		timer_min=$(($timer_total / 60 % 60))
		timer_hour=$(($timer_total / 3600 % 24))
		timer_day=$(($timer_total / 86400))
		if [ ${timer_total} -ne 0 ]; then
			tp=''
			[ -z "$tp" ] && [ $timer_day -eq 0 ]  || tp+="${timer_day}d "
			[ -z "$tp" ] && [ $timer_hour -eq 0 ] || tp+="${timer_hour}h "
			[ -z "$tp" ] && [ $timer_min -eq 0 ]  || tp+="${timer_min}m "
			[ -z "$tp" ] && [ $timer_sec -eq 0 ]  || tp+="${timer_sec}s"
			RPROMPT+=" %{$pc_time%}${tp}%{$reset_color%}"
			unset tp
		fi
		unset timer_total
		unset timer_sec
		unset timer_min
		unset timer_hour
		unset timer_day
		unset timer
	fi

	export RPROMPT
}
#}}}

preexec() {
	timer=${timer:-$SECONDS}

	# clean up some variables, so they don't linger:
	unset vcs_info_msg_0_
	unset vcs_info_msg_1_
	unset PROMPT
	unset RPROMPT
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
# VIM {{{

# Use vim mode, but keep handy emacs keys in insert mode:
bindkey -v
bindkey -M viins ''    backward-delete-char
bindkey -M viins '[3~' delete-char
bindkey -M viins ''    beginning-of-line
bindkey -M viins ''    end-of-line
bindkey -M viins ''    kill-line
bindkey -M viins ''    down-line-or-history
bindkey -M viins ''    up-line-or-history
bindkey -M viins ''    history-incremental-search-backward
bindkey -M viins ''    backward-kill-line
bindkey -M viins ''    backward-kill-word

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
# COMPLETION {{{

# The following lines were added by compinstall

zstyle ':completion:*' format "[%{$fg_bold[default]%}%d%{$reset_color%}]"
zstyle ':completion:*' group-name ''
zstyle ':completion:*' ignore-parents parent pwd
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true
zstyle :compinstall filename '/home/ayekat/.config/zsh/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Do not autocomplete when ambiguous (bash-like):
setopt no_auto_menu

# }}}
# ------------------------------------------------------------------------------
# HISTORY {{{

setopt append_history       # append, instead of overwrite
setopt hist_ignore_dups     # ignore duplicate commands
#setopt share_history        # allow to acces to history of previous shells

HISTFILE=$ZDOTDIR/.zhistory
HISTSIZE=100000             # maximum history size in terminal's memory
SAVEHIST=100000             # maximum size of history file

# }}}
