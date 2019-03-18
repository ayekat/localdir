# Exclude checks for shellcheck

# SC1090 (Can't follow non-constant source)
# We use it all the time. It's not a crime.
SHELLCHECK_OPTS='-e SC1090'

# SC2016 (Expressions don't expand in single quotes, use double quotes for that)
# We use it for styling, and we never use backticks for expressions anyway.
SHELLCHECK_OPTS="$SHELLCHECK_OPTS -e SC2016"

# SC2059 (Don't use variables in the printf format string)
# When using wrappers around printfs, we extract the format string and pass it
# as the first argument. In such a case, we don't want this warning.
SHELLCHECK_OPTS="$SHELLCHECK_OPTS -e SC2059"

# SC2086 (Double quote to prevent globbing and word splitting)
# We usually know when we want to split and when not.
SHELLCHECK_OPTS="$SHELLCHECK_OPTS -e SC2086"

# SC2094 (Make sure not to read and write the same file in the same pipeline)
# Erroneously pops up when just *using* the file name within a pipeline that
# reads from that file.
SHELLCHECK_OPTS="$SHELLCHECK_OPTS -e SC2094"

# SC2119 (Use foo "$@" if function's $1 should mean script's $1)
# SC2120 (foo references arguments, but none are ever passed)
# We occasionally write code that takes either an argument or reads from stdin
# (typically message printing wrappers).
SHELLCHECK_OPTS="$SHELLCHECK_OPTS -e SC2119 -e SC2120"

export SHELLCHECK_OPTS
