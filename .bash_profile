#!/bin/bash
# Actions taken at a login to bash.
# I'd rather have all configuration in one file, but modifying the $PATH
# variable in .bashrc is not really a good idea, so I put it here.

# Use colorgcc to colour the gcc output:
export PATH="/usr/lib/colorgcc/bin:$PATH"

# Add user specific local bin folder:
export PATH="$HOME/.local/bin:$PATH"

# Source the bash configuration:
. $HOME/.bashrc

