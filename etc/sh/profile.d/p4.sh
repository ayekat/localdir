# P4 (Tolino) SDE

dir_sde="$HOME/epfl/bf-sde-8.4.0"
if [ -d "$dir_sde" ]; then
	export SDE="$dir_sde"
	export SDE_INSTALL="$SDE/install"
fi
