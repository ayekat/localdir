# Altera (Quartus, ModelSim)
# * User is recommended to be in 'plugdev' group, for USB devices
# * quartus starts Quartus, vsim starts ModelSim

dir_altera="$HOME/.local/opt/altera"
if [ -d "$dir_altera" ]; then
	for p in "$dir_altera/nios2eds/bin/gnu/H-x86_64-pc-linux-gnu/bin" \
	         "$dir_altera/nios2eds/sdk2/bin" \
	         "$dir_altera/nios2eds/bin" \
	         "$dir_altera/quartus/bin" \
	         "$dir_altera/quartus/sopc_builder/bin" \
	         "$dir_altera/modelsim_ase/bin"
	do
		export PATH="$PATH:$p"
	done
	export QUARTUS_ROOTDIR="$dir_altera/quartus"
	export SOPC_KIT_NIOS2="$dir_altera/nios2eds"
	export QUARTUS_64BIT=1
fi
unset dir_altera
