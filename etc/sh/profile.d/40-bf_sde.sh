# Barefoot SDE for P4 (Tolino)

dir_sde="$HOME/sde"

if [ -d "$dir_sde" ]; then
	export SDE="$dir_sde"
	export SDE_INSTALL="$SDE/install"

	path append "$SDE"
	path append "$SDE_INSTALL/bin"
	path append "$HOME/tools"
fi

unset dir_sde
