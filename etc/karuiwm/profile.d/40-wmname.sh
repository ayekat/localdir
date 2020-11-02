# Some Java applications refuse to work correctly if run in a non-reparenting WM
# they don't know. We set the WM name to a value known to Java to fix that:
if have wmname; then
	wmname LG3D
fi
