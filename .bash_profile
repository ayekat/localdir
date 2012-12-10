. $HOME/.bashrc


# VARIABLES --------------------------------------------------------------------

# Set vim as default text editor:
export EDITOR="/usr/bin/vim"

# Use colorgcc to colour the gcc output:
export PATH="/usr/lib/colorgcc/bin:$PATH"

# Add user specific local bin folder:
export PATH="$HOME/.local/bin:$PATH"

# Configure bash history:
export HISTIGNORE="&:[bf]g:exit"
export HISTSIZE=10000

