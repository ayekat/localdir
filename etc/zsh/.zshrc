# Configuration for interactive zsh.
# Written by ayekat on a cold night in march 2013.

# Shell-agnostic configuration:
. $XDG_CONFIG_HOME/sh/config

# ------------------------------------------------------------------------------
# LOOK & FEEL {{{

# Enable syntax highlighting:
for hlpath in zsh/plugins/zsh-syntax-highlighting zsh-syntax-highlighting; do
	if [ -e "/usr/share/$hlpath/zsh-syntax-highlighting.zsh" ]; then
		. "/usr/share/$hlpath/zsh-syntax-highlighting.zsh"
		break
	fi
done

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
if [ "$TERM" != 'linux' ]; then
	pc_vim_normal="$(printf "\033[38;5;22;48;5;148m")"
	pc_vim_insert="$(printf "\033[38;5;45;48;5;23m")"
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

build_prompt() #{{{
{
	PROMPT=''

	# Background jobs:
	PROMPT+="%(1j.%{$pc_jobs%} %j %{$reset_color%}.)"

	# Vim mode:
	if [ "$vim_mode" = "$vim_mode_normal" ]; then
		pc_vim="$pc_vim_normal"
	else
		pc_vim="$pc_vim_insert"
	fi
	PROMPT+="%{$pc_vim%} ${vim_mode:-$vim_mode_insert} %{$reset_color%} "

	# VCS (watched):
	if [ -z "$1" ]; then
		VCS_PROMPT=''
		_vcs_clean=1
		_build_vcs_prompt() {
			vcs_update "$1"
			case "$vcs_state" in (ahead|dvrgd|ready|dirty|hdlss)
				if [ $_vcs_clean -eq 1 ]; then
					VCS_PROMPT+="%{$(printf "\033[34m")%}["
					_vcs_clean=0
				fi
				case "$vcs_state" in
					ahead) VCS_PROMPT+="%{$pc_vcs_ahead%}" ;;
					dvrgd) VCS_PROMPT+="%{$pc_vcs_dvrgd%}" ;;
					ready) VCS_PROMPT+="%{$pc_vcs_ready%}" ;;
					dirty) VCS_PROMPT+="%{$pc_vcs_dirty%}" ;;
					hdlss) VCS_PROMPT+="%{$pc_vcs_hdlss%}" ;;
				esac
				VCS_PROMPT+="$2"
			esac
		}
		_build_vcs_prompt "$XDG_LIB_HOME/dotfiles" 'd'
		_build_vcs_prompt "$XDG_LIB_HOME/utils" 'u'
		_build_vcs_prompt "$XDG_DATA_HOME/pass" 'p'
		if [ $_vcs_clean -eq 0 ]; then
			VCS_PROMPT+="%{$(printf "\033[34m")%}]%{$reset_color%} "
		fi
		unset -f _build_vcs_prompt
		unset _vcs_clean
	fi
	PROMPT+="$VCS_PROMPT"

	# VCS (PWD):
	vcs_update "$(pwd)"
	if [ -n "$vcs_state" ]; then
		case "$vcs_state" in
			huge)  PROMPT+="%{$pc_vcs_huge%}"  ;;
			clean) PROMPT+="%{$pc_vcs_clean%}" ;;
			ahead) PROMPT+="%{$pc_vcs_ahead%}" ;;
			dvrgd) PROMPT+="%{$pc_vcs_dvrgd%}" ;;
			ready) PROMPT+="%{$pc_vcs_ready%}" ;;
			dirty) PROMPT+="%{$pc_vcs_dirty%}" ;;
			hdlss) PROMPT+="%{$pc_vcs_hdlss%}" ;;
		esac
		PROMPT+="[$vcs_branch]%{$reset_color%} "
	fi

	# Hostname (if SSH):
	[ -n "$SSH_CONNECTION" ] && PROMPT+="%{$pc_host%}%M:%{$reset_color%}"

	# PWD:
	PROMPT+="%{$pc_pwd%}%~%{$reset_color%} "

	# Root?
	if [ $(id -u) = 0 ]; then
		PROMPT+="%{$pc_prompt%}#%{$reset_color%} "
	fi

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
		if [ ${timer_total} -gt 1 ]; then
			tp=''
			[ -z "$tp" ] && [ $timer_day -eq 0 ]  || tp+="${timer_day}d "
			[ -z "$tp" ] && [ $timer_hour -eq 0 ] || tp+="${timer_hour}h "
			[ -z "$tp" ] && [ $timer_min -eq 0 ]  || tp+="${timer_min}m "
			[ -z "$tp" ] && [ $timer_sec -eq 0 ]  || tp+="${timer_sec}s"
			RPROMPT+=" %{$pc_time%}${tp}%{$reset_color%}"
			unset tp
		fi
		unset timer_total timer_sec timer_min timer_hour timer_day timer
	fi

	export RPROMPT
}
#}}}

preexec()
{
	timer=${timer:-$SECONDS}
	unset PROMPT
	unset RPROMPT
}

precmd()
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
bindkey -M viins ''    backward-delete-char
bindkey -M viins '[3~' delete-char
bindkey -M viins ''    beginning-of-line
bindkey -M viins ''    end-of-line
bindkey -M viins ''    kill-line
bindkey -M viins ''    down-line-or-history
bindkey -M viins ''    up-line-or-history
#bindkey -M viins ''    history-incremental-search-backward
bindkey -M viins ''    backward-kill-line
bindkey -M viins ''    backward-kill-word

# Use vim to edit command lines:
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Handler for mode change:
zle-keymap-select() {
	vim_mode="${${KEYMAP/vicmd/${vim_mode_normal}}/(main|viins)/${vim_mode_insert}}"
	build_prompt mode
	zle reset-prompt
}
zle -N zle-keymap-select

# Handler for after entering a command (reset to insert mode):
zle-line-finish() {
	vim_mode=$vim_mode_insert
	build_prompt mode
}
zle -N zle-line-finish

# ^C puts us back in insert mode; repropagate to not interfere with dependants:
TRAPINT() {
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
test -d "$XDG_CACHE_HOME/zsh" || mkdir -p "$XDG_CACHE_HOME/zsh"

# The following lines were added by compinstall

zstyle ':completion:*' format "[%{$fg_bold[default]%}%d%{$reset_color%}]"
zstyle ':completion:*' group-name ''
zstyle ':completion:*' ignore-parents parent pwd
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true
zstyle :compinstall filename '/home/ayekat/.config/zsh/.zshrc'

autoload -Uz compinit
compinit -d $XDG_CACHE_HOME/zsh/zcompdump
# End of lines added by compinstall

# Do not autocomplete when ambiguous (bash-like):
setopt no_auto_menu

# Print 'completing ...' when completing:
expand-or-complete-with-dots () {
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
test -d "$XDG_DATA_HOME/zsh" || mkdir -p "$XDG_DATA_HOME/zsh"

setopt inc_append_history       # immediately append history to history file
setopt hist_ignore_dups         # ignore duplicate commands
setopt hist_ignore_space        # ignore commands with leading space

export HISTFILE="$XDG_DATA_HOME/zsh/zhistory"
export HISTSIZE=100000          # maximum history size in terminal's memory
export SAVEHIST=100000          # maximum size of history file

# prevent commands from entering the history
zshaddhistory() {
	line=${1%%$'\n'}
	case "$line" in
		fg|bg) return 1 ;;
	esac
}

# }}}
# ------------------------------------------------------------------------------
