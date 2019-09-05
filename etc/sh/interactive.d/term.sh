# Terminal-specific settings

# I can't find a way to get the rxvt-unicode-256color terminfo in CentOS:
if [ "$OS_NAME" = 'centos' ] && [ "$TERM" = 'rxvt-unicode-256color' ]; then
	export TERM=rxvt-unicode
fi
