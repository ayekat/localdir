# Set initial environment from environment.d files

for _envfile in "$XDG_CONFIG_HOME/environment.d/"*.conf; do
	_envlineno=0
	while read -r _envline; do
		_envlineno=$((_envlineno + 1))
		# Ignore empty or commented line:
		case "$_envline" in ('#'*|'')
			continue
		esac

		# Expect KEY=VALUE:
		case "$_envline" in (*=*) ;; (*)
			printf '%s:%d: Ignoring incorrectly formatted line: %s\n' \
			       "$_envfile" $_envlineno "$_envline"
			continue
		esac

		# Expect KEY to follow the recommendations described in
		# https://pubs.opengroup.org/onlinepubs/9699919799/:
		case "${_envline%%=*}" in ([!A-Z_]*|*[!A-Z0-9_]*)
			printf '%s:%d: Ignoring invalid variable name: %s\n' \
			       "$_envfile" $_envlineno "${_envline%%=*}"
			continue
		esac

		# Process line as a shell variable declaration command:
		eval "export $_envline"
	done <"$_envfile"
	unset _envline
done
unset _envfile
