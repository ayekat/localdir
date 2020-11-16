if have urxvt tmux; then
	{ sleep 2 && urxvt -e "$XDG_LIB_HOME"/tmux/tmux-view SCRATCHPAD; } &
fi
