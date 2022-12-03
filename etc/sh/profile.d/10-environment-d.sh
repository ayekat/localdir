# Set initial environment from environment.d files

for _envg in /usr/lib/systemd/user-environment-generators/*; do
	test -x "$_envg" || continue
	if _envd=$("$_envg"); then
		eval export "$_envd"
	else
		printf 'ERROR: Could not run user environment generator %s\n' \
		       "$_envg" >&2
	fi
	unset _envd
done
unset _envg
