# Start karuibar with a delay to keep it above karuiwm-legacy's status bar

if command -v karuibar >/dev/null; then
	{ sleep 1 && karuibar; } &
fi
