# Screen colour calibration:

if ! have dispwin; then
	return
fi

HOSTNAME=${HOSTNAME:-$(uname -n)}
XDG_LIB_HOME="${XDG_LIB_HOME:-$HOME/.local/lib}"

case "$HOSTNAME" in
	(chirschi) icc_profile='lenovo_thinkpad_x230' ;;
	(kiwi)     icc_profile='asus_vh232t' ;;
	(*)        icc_profile='';;
esac
if [ -z "$icc_profile" ]; then
	echo "no colour profile defined for $HOSTNAME" >&2
	return
fi

i=1
for p in $icc_profile; do
	icc_path=$XDG_LIB_HOME/argyll/$p.icc
	if [ ! -f "$icc_path" ]; then
		echo "file not found: $icc_path" >&2
		continue
	fi
	dispwin -d $i "$icc_path"
	i=$((i + 1))
done
