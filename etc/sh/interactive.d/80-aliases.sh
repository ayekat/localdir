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
alias cc='gcc -std=c11 -pedantic -Wall -Wextra -Wbad-function-cast -Wcast-align -Wcast-qual -Wconversion -Wfloat-equal -Wformat=2 -Wlogical-op -Wmissing-declarations -Wmissing-prototypes -Wpointer-arith -Wshadow -Wstrict-prototypes -Wwrite-strings'
alias fixinput='sh $XDG_CONFIG_HOME/karuiwm/profile.d/10-xinput.sh && sh $XDG_CONFIG_HOME/X11/xprofile.d/10-setxkbmap.sh'
alias fixtgshit='git -C ~/.local checkout etc/mimeapps.list && rm $XDG_DATA_HOME/applications/userapp-Telegram*.desktop'
alias mpv='mpv --x11-netwm=yes'
alias todo='grep -n -R "TODO\|FIXME\|XXX" .'
