# Start karuibar with a delay to keep it above karuiwm-legacy's status bar

if have karuibar; then
	{ sleep 1 && karuibar; } &
fi
