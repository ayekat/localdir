#if command -v ibus-daemon >/dev/null; then
#	export GTK_IM_MODULE=ibus
#	export QT_IM_MODULE=ibus
#	export XMODIFIERS='@im=ibus'
#	ibus-daemon -drx
#fi
