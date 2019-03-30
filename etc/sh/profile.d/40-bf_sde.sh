# Barefoot SDE for P4 (Tolino)

dir_sde="$HOME/sde"
if [ -d "$dir_sde" ]; then
	export SDE="$dir_sde"
	export SDE_INSTALL="$SDE/install"
fi

path append "$SDE"
path append "$SDE/install/bin"
path append "$HOME/tools"
