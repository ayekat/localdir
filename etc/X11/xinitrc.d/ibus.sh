if which ibus-daemon >/dev/null 2>&1; then
	export GTK_IM_MODULE=ibus
	export QT_IM_MODULE=ibus
	export XMODIFIERS='@im=ibus'
	ibus-daemon -drx
fi
