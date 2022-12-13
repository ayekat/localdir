# Set initial environment from environment.d files

for _envg in /usr/lib/systemd/user-environment-generators/*; do
	test -x "$_envg" || continue
	if _envd=$("$_envg"); then
		while read -r _envl; do
			eval "export $_envl"
		done <<- EOF
		$_envd
		EOF
		unset _envl
	else
		printf 'ERROR: Could not run user environment generator %s\n' \
		       "$_envg" >&2
	fi
	unset _envd
done
unset _envg
