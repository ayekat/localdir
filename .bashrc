#!/bin/bash
# bash configuration file
# Written by ayekat on a rainy day in 2009


# ------------------------------------------------------------------------------
# START-UP ACTION

# Check for an interactive session (= not executed as shell script interpreter):
test -z "$PS1" && return

# Enable tab completion with sudo:
complete -cf sudo

# Enable Vi/ViM-like behaviour (default: emacs):
#set -o vi

# Read operating system information (if available):
if [[ -e /etc/os-release ]]; then
	arch=$(grep ID /etc/os-release | cut -c 4-)
else
	if [[ $(uname) = "Darwin" ]]; then
		arch="darwin"
	else
		arch="WARNING >> missing file: /etc/os-release"
	fi
fi

# Determine if desktop (Xorg exists or OS X):
test -e /usr/bin/xinit -o $arch = "darwin"
IS_DESKTOP=$((! $?))

# Delete the 'Desktop' folder if not on OS X:
if [[ $arch != "darwin" ]]; then
	rmdir $HOME/Desktop 2> /dev/null
fi

# TODO: ugly fix for my Debian server that doesn't correctly load locale:
if [[ $arch = "debian" ]]; then
	export LANG=en_GB.UTF-8
fi

# If we are on a server, start or reattach to screen session automatically:
if [[ $IS_DESKTOP -eq 0 && -e /usr/bin/screen && $TERM != screen* ]]; then
	screen -x && exit
fi


# ------------------------------------------------------------------------------
# LOOK'N'FEEL

# Configure Prompt:
if [[ $IS_DESKTOP -eq 1 ]]; then
	PS1="\[\e[36m\][\t] \[\e[33m\]\h \[\e[32m\]\w\[\e[0m\] "
else
	PS1="\[\e[36m\][\t] \[\e[35m\]\h \[\e[32m\]\w\[\e[0m\] "
fi

# By the way: these are some common escape sequences:
#
#  30/40: black   (fg/bg)
#  31/41: red     (fg/bg)
#  32/42: green   (fg/bg)
#  33/43: yellow  (fg/bg)
#  34/44: blue    (fg/bg)
#  35/45: magenta (fg/bg)
#  36/46: cyan    (fg/bg)
#  37/47: white   (fg/bg)
#
#  1: bold
#  2: thin/weak
#  4: underlined
#  7: inverted
#  8: hidden
#  9: canceled


# ------------------------------------------------------------------------------
# ALIASES

alias cp="cp -i"
alias grep="grep --color=auto"
alias la="ls -a"
alias lah="ls -lah"
alias laht="ls -laht"
alias ll="ls -lh"
alias mv="mv -i"
alias sudo="sudo -p \"[sudo]\"\ password:\ "
if [[ $arch = "darwin" ]]; then
	alias ls="ls -G"           # BSD
else
	alias ls="ls --color=auto" # GNU
fi

# Server only aliases (mostly additional security):
if [[ $IS_DESKTOP -eq 0 ]]; then
	alias rm="rm -i"
fi

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
if [[ -e /usr/bin/thunar ]]; then
	alias open="thunar"; fi
if [[ -e /usr/bin/valgrind ]]; then
	alias valgrind="valgrind --log-file=valgrind.log"; fi

# Arch specific aliases:
if [[ $arch = "arch" ]]; then
	alias cal="cal -m -3"
	if [[ $IS_DESKTOP -eq 1 && $TERM = "linux" ]]; then
		alias x="startx -- -nolisten tcp & exit"
	fi
fi


# ------------------------------------------------------------------------------
# START-UP DISPLAY

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
		*)
			printf "unknown logo: '%s'\n" $1
			;;
	esac
}

# Print right logo:
printlogo $arch

# Display the todo file in the home directory:
if [[ -e $HOME/TODO ]]; then
	echo; cat $HOME/TODO; echo
fi

