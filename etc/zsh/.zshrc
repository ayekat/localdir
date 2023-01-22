# Configuration for interactive zsh.
# Written by ayekat on a cold night in march 2013.

# Shell-agnostic configuration:
emulate sh -c ". $XDG_CONFIG_HOME/sh/interactive"

# ------------------------------------------------------------------------------
# LOOK & FEEL {{{

# Enable syntax highlighting:
for zshshroot in \
	"$XDG_DATA_HOME"/zsh/plugins \
	/usr/share/zsh/plugins \
	/usr/share
do
	zshshfile=$zshshroot/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	if [[ -e "$zshshfile" ]]; then
		. "$zshshfile"
		break
	fi
done
unset zshshfile zshshroot

# Handle IFS correctly:
setopt SH_WORD_SPLIT

# }}}
# ------------------------------------------------------------------------------
# PROMPT {{{

# Enable colours:
autoload -U colors && colors

# Allow shell substitutions as part of prompt format string:
setopt prompt_subst

# Define prompt colours:
if [[ "$TERM" != 'linux' ]]; then
	pc_vim_normal=$(printf '\033[38;5;22;48;5;148m')
	pc_vim_insert=$(printf '\033[38;5;45;48;5;23m')
else
	pc_vim_normal="$fg[black]$bg[green]"
	pc_vim_insert="$fg[cyan]$bg[blue]"
fi
pc_time="$fg[green]"
pc_retval_bad="$fg_bold[red]"
pc_retval_good="$fg[black]"

# Define vim mode strings:
vim_mode_normal='CMD'
vim_mode_insert='INS'
vim_mode=$vim_mode_insert

function build_prompt() #{{{
{
	PROMPT=''

	# Background jobs:
	PROMPT+="%(1j.%{$pc_jobs%} %j %{$reset_color%}.)"

	# Vim mode:
	if [[ "$vim_mode" = "$vim_mode_normal" ]]; then
		pc_vim="$pc_vim_normal"
	else
		pc_vim="$pc_vim_insert"
	fi
	PROMPT+="%{$pc_vim%} ${vim_mode:-$vim_mode_insert} %{$reset_color%} "

	# Git:
	${ZSH_GIT_PROMPT:-true} || GIT_PROMPT=
	if ${ZSH_GIT_PROMPT:-true} && [[ $# -eq 0 ]]; then
		GIT_PROMPT=

		# Watched repositories:
		watched_clean=true
		build_watched_prompt() {
			git_update "$1" || return
			if [[ -z "$git_status" ]] \
			&& [[ -z "$git_remote"  ]] \
			&& [[ -z "$git_detached" ]]; then
				return
			fi
			if $watched_clean; then
				GIT_PROMPT+="%{$pc_git_bracket%}["
				watched_clean=false
			fi
			if [[ -n "$git_detached" ]] || [[ -n "$git_state" ]]; then
				GIT_PROMPT+="%{$pc_git_detached%}"
			fi
			case "$git_status" in
				(modified) GIT_PROMPT+="%{$pc_git_status_mod%}" ;;
				(staged)   GIT_PROMPT+="%{$pc_git_status_stg%}" ;;
				('')       GIT_PROMPT+="%{$pc_git_status_cln%}" ;;
			esac
			GIT_PROMPT+="$2%{$reset_color%}"
		}
		build_watched_prompt "$HOME/.local" 'd'
		build_watched_prompt "$HOME/.local/lib/private" 'L'
		build_watched_prompt "$XDG_STATE_HOME/pass" 'p'
		build_watched_prompt "$XDG_STATE_HOME/totp" 't'
		if ! $watched_clean; then
			GIT_PROMPT+="%{$pc_git_bracket%}]%{$reset_color%} "
		fi
		unset -f build_watched_prompt
		unset watched_clean

		# Current repository:
		if git_update "$(pwd)"; then
			GIT_PROMPT+="%{$pc_git_bracket%}["

			# Branch/status:
			if [[ -n "$git_detached" ]]; then
				GIT_PROMPT+="%{$pc_git_detached%}"
			fi
			case "$git_status" in
				(modified) GIT_PROMPT+="%{$pc_git_status_mod%}" ;;
				(staged)   GIT_PROMPT+="%{$pc_git_status_stg%}" ;;
				('')       GIT_PROMPT+="%{$pc_git_status_cln%}" ;;
			esac
			GIT_PROMPT+="$git_branch"

			# Remote:
			if [[ -n "$git_remote" ]]; then
				GIT_PROMPT+="%{$pc_git_bracket%}|"
				case "$git_remote" in
					(ahead)    GIT_PROMPT+="%{$pc_git_remote_ahd%}" ;;
					(behind)   GIT_PROMPT+="%{$pc_git_remote_bhd%}" ;;
					(diverged) GIT_PROMPT+="%{$pc_git_remote_div%}" ;;
				esac
				GIT_PROMPT+="$git_remote"
			fi

			# State:
			if [[ -n "$git_state" ]]; then
				GIT_PROMPT+="%{$pc_git_bracket%}|%{$pc_git_state%}$git_state"
			fi

			GIT_PROMPT+="%{$pc_git_bracket%}]%{$reset_color%} "
		fi
	fi
	PROMPT+="$GIT_PROMPT"

	# Hostname (if SSH):
	if [[ -n "${SSH_CONNECTION:-}" ]]; then
		PROMPT+="%{$pc_host%}%M:%{$reset_color%}"
	fi

	# PWD:
	PROMPT+="%{$pc_pwd%}%~%{$reset_color%} "

	export PROMPT
}
#}}}

function build_rprompt() #{{{
{
	RPROMPT=''

	# Last command's return value:
	RPROMPT+="%(?..%{$pc_retval_bad%}[%?]%{$reset_color%})"

	# Last command's duration:
	if [[ -n "$timer" ]]; then
		timer_total=$(($SECONDS - $timer))
		timer_sec=$(($timer_total % 60))
		timer_min=$(($timer_total / 60 % 60))
		timer_hour=$(($timer_total / 3600 % 24))
		timer_day=$(($timer_total / 86400))
		if [[ ${timer_total} -gt 1 ]]; then
			tp=''
			[[ -z "$tp" ]] && [[ $timer_day  -eq 0 ]] || tp+="${timer_day}d "
			[[ -z "$tp" ]] && [[ $timer_hour -eq 0 ]] || tp+="${timer_hour}h "
			[[ -z "$tp" ]] && [[ $timer_min  -eq 0 ]] || tp+="${timer_min}m "
			[[ -z "$tp" ]] && [[ $timer_sec  -eq 0 ]] || tp+="${timer_sec}s"
			RPROMPT+=" %{$pc_time%}${tp}%{$reset_color%}"
			unset tp
		fi
		unset timer_total timer_sec timer_min timer_hour timer_day timer
	fi

	export RPROMPT
}
#}}}

function preexec()
{
	timer=${timer:-$SECONDS}
	unset PROMPT
	unset RPROMPT
}

function precmd()
{
	build_prompt
	build_rprompt
}

precmd

# }}}
# ------------------------------------------------------------------------------
# VIM {{{

# Use vim mode, but keep handy emacs keys in insert mode:
bindkey -v
bindkey -M viins '^?'    backward-delete-char
bindkey -M viins '^[[3~' delete-char
bindkey -M viins '^A'    beginning-of-line
bindkey -M viins '^E'    end-of-line
bindkey -M viins '^K'    kill-line
bindkey -M viins '^N'    down-line-or-history
bindkey -M viins '^P'    up-line-or-history
#bindkey -M viins '^R'    history-incremental-search-backward
bindkey -M viins '^U'    backward-kill-line
bindkey -M viins '^W'    backward-kill-word

# Use vim to edit command lines:
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Handler for mode change:
function zle-keymap-select()
{
	vim_mode="${${KEYMAP/vicmd/${vim_mode_normal}}/(main|viins)/${vim_mode_insert}}"
	build_prompt mode
	zle reset-prompt
}
zle -N zle-keymap-select

# Handler for after entering a command (reset to insert mode):
function zle-line-finish()
{
	vim_mode=$vim_mode_insert
	build_prompt mode
}
zle -N zle-line-finish

# ^C puts us back in insert mode; repropagate to not interfere with dependants:
function TRAPINT() {
	vim_mode=$vim_mode_insert
	build_prompt
	return $((128 + $1))
}

# Delay for key sequences:
KEYTIMEOUT=1

# }}}
# ------------------------------------------------------------------------------
# COMPLETION {{{

# Make sure the zsh cache directory exists:
[[ -d "$XDG_CACHE_HOME/zsh" ]] || mkdir -p "$XDG_CACHE_HOME/zsh"

# The following lines were added by compinstall

zstyle ':completion:*' format "[%{$fg_bold[default]%}%d%{$reset_color%}]"
zstyle ':completion:*' group-name ''
zstyle ':completion:*' ignore-parents parent pwd
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true
zstyle ':compinstall' filename "$XDG_CONFIG_HOME/zsh/.zshrc"

autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"
# End of lines added by compinstall

# Do not autocomplete when ambiguous (bash-like):
setopt no_auto_menu

# Print 'completing ...' when completing:
function expand-or-complete-with-dots ()
{
	printf "$fg[blue] completing ...$reset_color\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
	zle expand-or-complete
	zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots

# }}}
# ------------------------------------------------------------------------------
# HISTORY {{{

# Make sure the zsh log directory exists:
mkdir -p "$XDG_STATE_HOME/zsh"

setopt inc_append_history       # immediately append history to history file
setopt hist_ignore_dups         # ignore duplicate commands
setopt hist_ignore_space        # ignore commands with leading space

export HISTFILE="$XDG_STATE_HOME/zsh/zhistory"
export HISTSIZE=1000000         # maximum history size in terminal's memory
export SAVEHIST=1000000         # maximum size of history file

# prevent commands from entering the history
function zshaddhistory()
{
	line=${1%%$'\n'}
	case "$line" in
		(fg|bg) return 1 ;;
	esac
}

# }}}
# ------------------------------------------------------------------------------
# I/O {{{

# Don't multiply stdout (i.e. `>/dev/null | cat` shouldn't output anything):
unsetopt multios

# }}}
