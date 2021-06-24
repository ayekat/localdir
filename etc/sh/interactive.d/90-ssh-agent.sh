if command -v ssh-add >/dev/null; then
	case "$(uname -n)" in
		(gurke) _ssh_id=id_rsa ;;
		(chirschi) _ssh_id=id_ed25519 ;;
	esac
	if [ -z "${_ssh_id:-}" ]; then
		return 0
	fi
	_ssh_add_retval=0
	_ssh_add_list=$(ssh-add -l) || _ssh_add_retval=$?
	case $_ssh_add_retval in
		(0) ;;
		(1) ssh-add ~/.ssh/"$_ssh_id" ;;
		(2) printf '%s\n' "$_ssh_add_list" ;;
		(*) printf 'Unknown exit code %d for ssh-add -l\n' $_ssh_add_retval ;;
	esac
	unset _ssh_id _ssh_add_retval _ssh_add_list
fi
