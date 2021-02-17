# Some Java applications refuse to work correctly if run in a non-reparenting WM
# they don't know. We set the WM name to a value known to Java to fix that:
if command -v wmname >/dev/null; then
	wmname LG3D
fi
