if command -v xset xss-lock /usr/share/karuiwm/scrlock >/dev/null; then
	xset s 300
	xss-lock /usr/share/karuiwm/scrlock &
fi
