if command -v xset xss-lock /usr/share/karuiwm/scrlock >/dev/null; then
	xset s 300
	# TODO: what happens with previous instances of xss-lock?
	xss-lock /usr/share/karuiwm/scrlock &
fi
