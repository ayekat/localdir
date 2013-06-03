#!/usr/bin/sh
# bash configuration file
# Written by ayekat on a rainy day in 2009.


# ------------------------------------------------------------------------------
# START {{{

# Check if this is an interactive session:
test -z "$PS1" && return

# }}}
# ------------------------------------------------------------------------------
# SYSTEM {{{

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
		[ -e /usr/bin/screen ] && [ $TERM != 'screen-bce' ] && \
				TERM=xterm-256color screen -U -x && exit
	else
		[ -e /usr/bin/tmux ] && [ $TERM != 'screen-256color' ] && tmx 0 && exit
	fi
fi

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
			[ $TERM = 'linux' ] && PS1+="\[\e[1m\]"
			for c in 32 33 31 35 34 36; do
				PS1+="\[\e[${c}m\]:"  # rainbow!!!
			done
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
export PROMPT_COMMAND='ayeprompt_assemble'

# }}}
# ------------------------------------------------------------------------------
# FEEL {{{

# Enable tab completion with sudo:
complete -cf sudo

# Enable Vi/ViM-like behaviour (default: emacs):
#set -o vi

# }}}
# ------------------------------------------------------------------------------
# ALIASES {{{
alias cp='cp -i'
alias grep='grep --color=auto'
alias la='ls -a'
alias lah='ls -lah'
alias laht='ls -laht'
alias ll='ls -lh'
alias mv='mv -i'
alias sudo='sudo -p "[sudo]"\ password:\ '
# BSD vs GNU:
[ $arch = 'darwin' ] && alias ls='ls -G' || alias ls='ls --color=auto'

# Server only aliases (mostly additional security):
[ ! $IS_DESKTOP ] && alias rm='rm -i'

# Application specific aliases:
[ -e /usr/bin/thunar ] && alias open='thunar'
[ -e /usr/bin/valgrind ] && alias valgrind='valgrind --log-file=valgrind.log'

# Arch specific aliases:
if [ $arch = 'arch' ]; then
	alias cal='cal -m -3'
	[ $IS_DESKTOP ] && [ $TERM = 'linux' ] &&
			alias x='startx -- -nolisten tcp & exit'
fi

# }}}
# ------------------------------------------------------------------------------
# HISTORY {{{

export HISTIGNORE='&:[bf]g:exit'
export HISTSIZE=10000

# }}}
# ------------------------------------------------------------------------------
# START-UP ACTIONS {{{

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

# Delete the 'Desktop' folder if on an Arch installation:
[ $arch = 'arch' ] && rmdir $HOME/Desktop 2> /dev/null

# Hosteurope fuckery: force loading correct locale:
[ $HOSTNAME = 'rowland' ] && export LANG=en_GB.UTF-8

# Print system logo:
printlogo $arch

# Display the todo file in the home directory:
[ -e $HOME/TODO ] && { echo; cat $HOME/TODO; echo; }

# }}}

