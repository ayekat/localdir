# Load private profile snippets

if [ -d "$XDG_LIB_HOME"/private/sh/profile.d ]; then
	for profile in "$XDG_LIB_HOME"/private/sh/profile.d/*.sh; do
		if [ -r "$profile" ]; then
			# shellcheck disable=SC1090
			. "$profile"
		fi
	done
	unset profile
fi
