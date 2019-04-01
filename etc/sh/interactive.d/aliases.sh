# Interactive shell aliases

# Clear aliases set by distro maintainers:
unalias -a

# Generic aliases:
alias cp='cp -i'
alias grep='grep --color=auto'
alias ll='ls -lh --time-style=long-iso'
alias ls='ls -A --color=auto --quoting-style=literal'
alias lt='ll -t'
alias mv='mv -i'

# Expand aliases for some commands as well:
alias sudo='sudo '
alias watch='watch '

# Server only aliases (mostly additional safety):
if [ -n "$SSH_CONNECTION" ]; then
	alias rm='rm -i'
fi

# Random other aliases:
alias cc='gcc -std=c11 -pedantic -Wall -Wextra -Wbad-function-cast -Wcast-align -Wcast-qual -Wconversion -Wfloat-equal -Wformat=2 -Wlogical-op -Wmissing-declarations -Wmissing-prototypes -Wpointer-arith -Wshadow -Wstrict-prototypes -Wwrite-strings'
alias gnusik='ssh -t rainbowdash ncmpcpp -h mpd.gnugen.ch'
alias mpv='mpv --x11-netwm=yes'
alias todo='grep -n -R "TODO\|FIXME\|XXX" .'
alias wat='head -n 20 ~/rl/dates'
