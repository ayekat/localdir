# Interactive shell aliases

# Clear aliases set by distro maintainers:
alias | while read -r alias; do
	unalias -- "${alias%%=*}"
done

# Generic aliases:
alias cp='cp -i'
alias grep='grep --color=auto'
alias ip='ip --color=auto'
alias ll='ls -lh --time-style=long-iso'
alias ls='ls -A --color=auto --quoting-style=literal'
alias lt='ll -t'
alias mv='mv -i'

# Expand aliases for some commands as well:
alias sudo='sudo '
alias watch='watch '

# Random other aliases:
alias checkupdates='checkupdates; diffrepo -b $CHECKUPDATES_DB -R -n base-devel -n makepkg zuepfe-repkg; diffrepo -b $CHECKUPDATES_DB -U zuepfe-updates'
alias cc='gcc -std=c11 -pedantic -Wall -Wextra -Wbad-function-cast -Wcast-align -Wcast-qual -Wconversion -Wfloat-equal -Wformat=2 -Wlogical-op -Wmissing-declarations -Wmissing-prototypes -Wpointer-arith -Wshadow -Wstrict-prototypes -Wwrite-strings'
alias fixtgshit='git -C ~/.local checkout etc/mimeapps.list'
alias mpv='mpv --x11-netwm=yes'
alias todo='grep -n -R "TODO\|FIXME\|XXX" .'
