#!/bin/bash
# Actions taken at a login to bash.

# Use colorgcc to colour the gcc output:
export PATH="/usr/lib/colorgcc/bin:$PATH"

# Add user specific local bin folder:
export PATH="$HOME/.local/bin:$PATH"

# Set vim as default text editor:
export EDITOR='vim'
export VISUAL='vim'

# Set less as default pager:
export PAGER='less'

# Source the bash configuration:
. $HOME/.bashrc

