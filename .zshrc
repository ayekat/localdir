#!/bin/sh
# zsh configuration file
# As there is currently no sane combination of terminal+zsh that works for me,
# I don't use zsh; thus this configuration file is rather theoretical.
# Written by ayekat on a cold night in march 2013.


# ------------------------------------------------------------------------------
# SYSTEM

# Read operating system information (if available):
if [ -e /etc/os-release ]; then
	arch=$(grep ID /etc/os-release | cut -c 4-)
elif [ $(uname) = 'Darwin' ]; then
	arch='darwin'
elif [ -e /etc/gentoo-release ]; then
	arch='gentoo'
else
	arch='unknown'
fi

# Determine if desktop (Xorg exists or OS X):
[ -e /usr/bin/xinit -o $arch = 'darwin' ] && IS_DESKTOP=1

# If not, we are on a server, so start or reattach to tmux session:
if [ ! $IS_DESKTOP ]; then
	# Hosteurope fuckery: tmux does not run correctly, so fallback to screen:
	if [ $HOSTNAME = 'rowland' ]; then
		[ -e /usr/bin/screen ] && [ $TERM != 'screen-bce' ] && screen -x && exit
	else
		[ -e /usr/bin/tmux ] && [ $TERM != 'screen-256color' ] && tmx 0 && exit
	fi
fi


# ------------------------------------------------------------------------------
# LOOK

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


# ------------------------------------------------------------------------------
# FEEL

# Enable autocompletion feature:
autoload -Uz compinit && compinit

# I use vim, but I'm used to emacs-keybinds in the terminal:
bindkey -e

# However we don't need to exagerate, do we?
bindkey "[3~" delete-char
# This --^ does not get displayed well on github; actually it is "^[[3~", where
# ^[ is achieved by pressing Ctrl-v, Esc.

# Disable zsh menu for autocompletion:
setopt no_auto_menu

# Enable autocompletion for special directories (such as '..'):
zstyle ':completion:*' special-dirs true


# ------------------------------------------------------------------------------
# ALIASES

alias cp='cp -i'
alias grep='grep --color=auto'
alias la='ls -a'
alias lah='ls -lah'
alias laht='ls -laht'
alias ll='ls -lh'
alias mv='mv -i'
alias sudo='sudo -p "[sudo]" password:\ '
# BSD vs GNU:
[ $arch = 'darwin' ] && alias ls='ls -G' || alias ls='ls --color=auto'

# Server only aliases (mostly additional security):
[ ! $IS_DESKTOP ] && alias rm='rm -i'

# Colored man pages (see above for format definitions):
man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;37m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
				/usr/bin/man "$@"
}

# Application specific aliases:
[ -e /usr/bin/thunar ] && alias open='thunar'
[ -e /usr/bin/valgrind ] && alias valgrind='valgrind --log-file=valgrind.log'

# Arch specific aliases:
if [ $arch = 'arch' ]; then
	alias cal='cal -m -3'
	[ $IS_DESKTOP ] && [ $TERM = 'linux' ] &&
			alias x='startx -- -nolisten tcp & disown && exit'
fi


# ------------------------------------------------------------------------------
# HISTORY

setopt append_history       # append, instead of overwrite
setopt hist_ignore_dups     # ignore duplicate commands
setopt share_history        # allow to acces to history of previous shells

HISTFILE=$HOME/.zhistory
HISTSIZE=10000              # maximum history size in terminal's memory
SAVEHIST=10000              # maximum size of history file


# ------------------------------------------------------------------------------
# START-UP ACTIONS

# Define logos:
printlogo() {
	case $1 in
		debian)
			printf "\e[31m                             \n"
			printf       "          .xd§PVkbxc.        \n"
			printf       "         xP*'      'Vb.      \n"
			printf       "       'd'     .,.   V.'     \n"
			printf       "       (*    .'   .  ::      \e[0m `uname -s -r`\n"
			printf "\e[31m       #     #      ,7       \e[0m on `uname -n`\n"
			printf "\e[31m       V,     *-__ -'        \n"
			printf       "       'qb                   \n"
			printf       "         *:,                 \n"
			printf       "           '-.               \n"
			printf       "               '             \n"
			printf  "\e[0m                             \n"
			;;
		arch)
			printf "\e[34m                             \n"
			printf       "              /\             \n"
			printf       "             /AA\            \n"
			printf       "            .'YAA\           \n"
			printf       "           /AAAAAA\          \e[0m `uname -s -r`\n"
			printf "\e[34m          /AAAAAAAA\         \e[0m on `uname -n`\n"
			printf "\e[34m         /AAA/  \AAA\        \n"
			printf       "        /AAA|    |AAP\       \n"
			printf       "       /AAAY\    /YAAa_      \n"
			printf       "      />*'          '*<\     \n"
			printf       "     ^                  ^    \n"
			printf  "\e[0m                             \n"
			;;
		darwin)
			printf "\e[32m                  .          \n"
			printf       "               .dA'          \n"
			printf       "               AP'           \n"
			printf       "        .dAAbx.,dAAAb.       \n"
			printf "\e[33m       dAAAAAAAAAAAAP        \e[0m `uname -s -r`\n"
			printf "\e[31m      :AAAAAAAAAAAAA         \e[0m on `uname -n`\n"
			printf "\e[31m      'AAAAAAAAAAAAA.        \n"
			printf "\e[35m       YAAAAAAAAAAAAAx.      \n"
			printf "\e[34m        \AAAAAAAAAAAAP       \n"
			printf "\e[36m         '<AV*''*\AP'        \n"
			printf       "                             \n"
			printf "\e[0m                              \n"
			;;
		gentoo)
			printf "\e[36m           __                \n"
			printf       "       .-d§§§§§bc,           \n"
			printf       "      /§§§§§*\"*Y§§§c.       \n"
			printf       "     (§§§§§§.   )§§§§b,      \n"
			printf       "     '(§§§§§§bxxI§§§§§§b     \e[0m `uname -s -r`\n"
			printf "\e[36m       \`\">§§§§§§§§§§§§§§)    \e[0m on `uname -n`\n"
			printf "\e[36m       .?§§§§§§§§§§§§§P\`    \n"
			printf       "     .A§§§§§§§§§§§§§*'       \n"
			printf       "     §§§§§§§§§§§\$*\`        \n"
			printf       "     V§§§§§§§*'\`            \n"
			printf       "       \`\"\`\`              \n"
			printf  "\e[0m                             \n"
			;;
	esac
}

# Delete the 'Desktop' folder if not on OS X:
[ $arch != 'darwin' ] && rmdir $HOME/Desktop 2> /dev/null

# Hosteurope fuckery: force loading correct locale:
[ $HOSTNAME = 'rowland' ] && export LANG=en_GB.UTF-8

# Print system logo:
printlogo $arch

# Display the todo file in the home directory:
[ -e $HOME/TODO ] && { echo; cat $HOME/TODO; echo; }

