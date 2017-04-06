# This shell snippet sets the `EPATH` variable to the next location of the
# executable that has the same name as the currently running executable.
# Handy for using in "wrapper" scripts.

EPATH="$(PATH="$(echo ":$PATH:" | sed -e "s|:\\($(dirname "$0"):\\)\\+|:|g;s|^:||;s|:\$||")" which "$(basename "$0")")"
