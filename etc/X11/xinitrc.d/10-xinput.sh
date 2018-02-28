# Swap left and right mouse buttons if using a ThinkPad keyboard.

if have xinput; then
	tpps='TPPS/2 IBM TrackPoint'
	tpusb='pointer:Lenovo ThinkPad Compact USB Keyboard with TrackPoint'
	mapbuttons() { xmodmap -e "pointer = 3 2 1 $(seq -s ' ' 4 $1)"; }

	case "$(xinput list --name-only | grep "$tpps\\|$tpusb")" in
		($tpps) mapbuttons 10 ;;
		($tpusb) mapbuttons 22 ;;
	esac

	unset tpps tpusb
	unset -f mapbuttons
fi
