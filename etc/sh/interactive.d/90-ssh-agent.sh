if command -v ssh-add >/dev/null; then
	# If no agent is running, we don't do anything:
	if [ -z "${SSH_AUTH_SOCK:-}" ] || [ -z "${SSH_AGENT_PID:-}" ]; then
		return
	fi

	# Check if there's a key:
	if [ ! -f ~/.ssh/id_ed25519 ]; then
		return
	fi

	# Check the current state of loaded keys:
	_ssh_add_retval=0
	_ssh_add_list=$(ssh-add -l 2>&1) || _ssh_add_retval=$?
	case $_ssh_add_retval in
		(0) # at least one key is present, nothing to do
			;;
		(1) # no key present in the agent, add defined key
			ssh-add ~/.ssh/id_ed25519 ;;
		(2) # could not communicate with the agent, print error
			printf '%s\n' "$_ssh_add_list" ;;
		(*) # undocumented (should not happen), print error
			printf 'Unknown exit code %d for ssh-add -l\n%s\n' \
			       $_ssh_add_retval "$_ssh_add_list" ;;
	esac
	unset _ssh_add_retval _ssh_add_list
fi
