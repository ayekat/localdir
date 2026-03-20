# Set wallpaper on X root window

if command -v feh >/dev/null; then
	if [ -e "$XDG_CONFIG_HOME"/wallpaper/default ]; then
		feh --no-fehbg --bg-fill "$XDG_CONFIG_HOME"/wallpaper/default
	fi
fi
