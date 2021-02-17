# Configure ThinkPad (and related) pointers:
# * Swap left and right mouse button;
# * Make sure that the touchpad is disabled.

if command -v xinput >/dev/null; then
(
	tpps_x230='TPPS/2 IBM TrackPoint'
	tpps_x390='Elan TrackPoint'
	tpad_x390='Elan Touchpad'
	tpusb='pointer:Lenovo ThinkPad Compact USB Keyboard with TrackPoint'

	reverse_button_mapping() {
		xinput --set-button-map $1 3 2 1 $(seq -s ' ' 4 $2)
	}

	if tpps_id=$(xinput list --id-only "$tpps_x230" 2>/dev/null); then
		reverse_button_mapping $tpps_id 10
		# XXX: libinput>=1.13.3
		xinput --set-prop $tpps_id 'libinput Accel Speed' '1.0'
	fi
	if tpps_id=$(xinput list --id-only "$tpps_x390" 2>/dev/null); then
		reverse_button_mapping $tpps_id 7
		xinput --set-prop $tpps_id 'libinput Accel Speed' '-0.3'
		if tpad_id=$(xinput list --id-only "$tpad_x390" 2>/dev/null); then
			# XXX: disabling touchpad in firmware has not effect:
			xinput --set-prop $tpad_id 'Device Enabled' 0
		fi
	fi
	if tpusb_id=$(xinput list --id-only "$tpusb" 2>/dev/null); then
		reverse_button_mapping $tpusb_id 22
	fi
)
fi
