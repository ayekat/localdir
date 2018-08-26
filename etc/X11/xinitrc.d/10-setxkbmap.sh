# Set X keyboard layout.

if have setxkbmap; then
	case "$(uname -n)" in
		(kiwi)
			{
				sleep 2
				setxkbmap ayekat
				notify-send 'X keymap set' 'ayekat'
			} & ;;
		(*) setxkbmap ayekat ;;
	esac
fi
