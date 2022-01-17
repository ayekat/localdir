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
		xinput --set-button-map $(($1)) 3 2 1 $(seq -s ' ' 4 $(($2)))
	}

	# XXX Workaround for cases where a device appears multiple times. The
	# manipulation needs be done on all devices, but xinput itself refuses to
	# list multiple ID, so we have to do it ourselves.
	xinput_list_ids() (
		dname=$1
		dfound=false

		# Check if device type is specified:
		case "$dname" in
			(keyboard:*) dtype=keyboard; dname=${dname#keyboard:} ;;
			(pointer:*) dtype=pointer; dname=${dname#pointer:} ;;
			(*) dtype= ;;
		esac

		# Go through the available devices:
		id_list=$(xinput --list --id-only) || return
		for id in $id_list; do
			case "$id" in (*[!0-9]*)
				printf 'Non-numeric device ID: %s\n' "$id" >&2
				return 1
			esac
			id=$((id))
			name=$(xinput --list --name-only $id) || return
			test "$name" = "$dname" || continue
			if [ -n "$dtype" ]; then
				# Name matches, but check if device type is what we want:
				state=$(xinput --query-state $id) || return
				case "$dtype" in
					(keyboard) filter=KeyClass ;;
					(pointer) filter=ButtonClass ;;
				esac
				while read -r line; do
					case "$line" in ("$filter"|"$filter "*)
						dfound=true
						printf '%d\n' $id
						break
					esac
				done <<- EOF
				$state
				EOF
			else
				# Name matches, no device type specified, remember this one:
				dfound=true
				printf '%d\n' $id
			fi
		done

		# Return code (true==0 if found, false==1 if not found):
		$dfound
	)

	if tpps_ids=$(xinput_list_ids "$tpps_x230"); then
		for id in $tpps_ids; do
			reverse_button_mapping "$id" 10
			# XXX: libinput>=1.13.3
			xinput --set-prop "$id" 'libinput Accel Speed' '1.0'
		done
	fi
	if tpps_ids=$(xinput_list_ids "$tpps_x390"); then
		for id in $tpps_ids; do
			reverse_button_mapping "$id" 7
			xinput --set-prop "$id" 'libinput Accel Speed' '-0.3'
		done
	fi
	if tpad_ids=$(xinput_list_ids "$tpad_x390"); then
		for id in $tpad_ids; do
			# XXX: disabling touchpad in firmware has not effect:
			xinput --set-prop "$id" 'Device Enabled' 0
		done
	fi
	if tpusb_ids=$(xinput_list_ids "$tpusb"); then
		for id in $tpusb_ids; do
			reverse_button_mapping "$id" 22
		done
	fi
)
fi
