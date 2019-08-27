# Swap left and right mouse buttons if using a ThinkPad keyboard.

if have xinput; then
	tpps_x230='TPPS/2 IBM TrackPoint'
	tpps_x390='Elan TrackPoint'
	tpusb='pointer:Lenovo ThinkPad Compact USB Keyboard with TrackPoint'

	reverse_button_mapping() {
		xinput --set-button-map $1 3 2 1 $(seq -s ' ' 4 $2)
	}

	if tpps_id=$(xinput list --id-only "$tpps_x230" 2>/dev/null); then
		reverse_button_mapping $tpps_id 10
		xinput --set-prop $tpps_id 'libinput Accel Speed' '1.0' # libinput>=1.13.3
	fi
	if tpps_id=$(xinput list --id-only "$tpps_x390" 2>/dev/null); then
		reverse_button_mapping $tpps_id 10
		xinput --set-prop $tpps_id 'libinput Accel Speed' '-0.5'
	fi
	if tpusb_id=$(xinput list --id-only "$tpusb" 2>/dev/null); then
		reverse_button_mapping $tpusb_id 22
	fi

	unset tpps_x230 tpps_x390 tpusb
	unset -f reverse_button_mapping
fi
