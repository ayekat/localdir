#!/bin/sh
# bash configuration file
# Written by ayekat on a rainy day in 2009.


# ------------------------------------------------------------------------------
# START

# Check if this is an interactive session:
test -z "$PS1" && return


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

# If not, we are on a server, so start or reattach to screen session:
if [ ! $IS_DESKTOP ]; then
	[ -e /usr/bin/screen ] && [ $TERM != 'screen' ] && screen -x && exit
fi


# ------------------------------------------------------------------------------
# LOOK

# Configure Prompt:
if [ $IS_DESKTOP ]; then
	PS1="\[\e[33m\]\h \[\e[32m\]\w\[\e[0m\] "
else
	PS1="\[\e[35m\]\h \[\e[32m\]\w\[\e[0m\] "
fi


# ------------------------------------------------------------------------------
# FEEL

# Enable tab completion with sudo:
complete -cf sudo

# Enable Vi/ViM-like behaviour (default: emacs):
#set -o vi


# ------------------------------------------------------------------------------
# ALIASES
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
[ -e /usr/bin/tmux ] && alias tmux=ltmux

# Arch specific aliases:
if [ $arch = 'arch' ]; then
	alias cal='cal -m -3'
	[ $IS_DESKTOP ] && [ $TERM = 'linux' ] &&
			alias x='startx -- -nolisten tcp & exit'
fi


# ------------------------------------------------------------------------------
# HISTORY

export HISTIGNORE='&:[bf]g:exit'
export HISTSIZE=10000


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

# TODO: ugly fix for my Debian server that doesn't correctly load locale:
[ $arch = 'debian' ] && export LANG=en_GB.UTF-8

# Print system logo:
printlogo $arch

# Display the todo file in the home directory:
[ -e $HOME/TODO ] && { echo; cat $HOME/TODO; echo; }

