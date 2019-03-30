# Standard locations for searching for executables

# Work around distributions that still keep separate sbin directories:
path append "$(readlink -f /usr/local/sbin)"
path append "$(readlink -f /usr/sbin)"
path append "$(readlink -f /sbin)"

# Add user path:
path prepend "$(readlink -f "$HOME/.local/bin")"

# Add path to wrapper scripts:
path prepend "$XDG_LIB_HOME/dotfiles/bin"
