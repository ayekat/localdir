if command -v xset xss-lock "$XDG_LIB_HOME"/karuiwm/scripts/scrlock >/dev/null
then
	xset s 300
	# TODO: what happens with previous instances of xss-lock?
	xss-lock "$XDG_LIB_HOME"/karuiwm/scripts/scrlock &
fi
