# Interactive shell prompt (extension for git)

# Colours:
pc_git_detached="$(printf '\033[1m')"
pc_git_status_mod="$(printf '\033[31m')"
pc_git_status_stg="$(printf '\033[33m')"
pc_git_status_cln="$(printf '\033[32m')"
pc_git_remote_ahd="$(printf '\033[0;36m')"
pc_git_remote_bhd="$(printf '\033[0;34m')"
pc_git_remote_div="$(printf '\033[0;35m')"
pc_git_state="$(printf '\033[0m')"
pc_git_bracket="$(printf '\033[0;34m')"

# Query git repository information:
# (sets variables; to be called with the path to the git repository)
git_update()
{
	git_path=''
	git_branch=''
	git_state=''
	git_remote=''
	git_status=''
	git_detached=''

	# Git:
	command -v git >/dev/null || return 1
	git_path="$(git -C "$1" rev-parse --show-toplevel 2>/dev/null)" || return 1
	git_dir="$(git -C "$git_path" rev-parse --absolute-git-dir 2>/dev/null)" || return 1
	git_bare=''
	git_status_full=''
	case "$1" in
		("$git_dir"*) git_bare=1 ;;
		(*) git_status_full="$(git -C "$git_path" status --porcelain -b)" ;;
	esac

	# Branch and state:
	if [ -d "$git_dir"/rebase-merge ]; then
		git_branch="$(<"$git_dir"/rebase-merge/head-name)"
		git_branch="${git_branch#refs/heads/}"
		if [ -f "$git_dir"/rebase-merge/interactive ]; then
			git_state='rebase-interactive'
		else
			git_state='rebase-merge'
		fi
	else
		if git_branch="$(git -C "$git_path" symbolic-ref HEAD 2>/dev/null)"; then
			git_branch="${git_branch#refs/heads/}"
		else
			git_detached=y
			git_branch="$(git -C "$git_path" rev-parse --short HEAD 2>/dev/null ||
			              echo 'unknown')"
		fi
		if [ -f "$git_dir"/rebase-apply/rebasing ]; then
			git_state='rebase'
		elif [ -f "$git_dir"/rebase-apply/applying ]; then
			git_state='amend'
		elif [ -d "$git_dir"/rebase-apply ]; then
			git_state='amend/rebase'
		elif [ -f "$git_dir"/MERGE_HEAD ]; then
			git_state='merge'
		elif [ -f "$git_dir"/CHERRY_PICK_HEAD ]; then
			git_state='cherrypick'
		elif [ -f "$git_dir"/BISECT_LOG ]; then
			git_state='bisect'
		fi
	fi
	unset git_dir

	# Remote (TODO: what if weird remote?):
	if [ -n "$git_bare" ]; then
		git_remote='bare'
	else
		git_status_head="$(echo "$git_status_full" | head -n 1)"
		if echo "$git_status_head" | grep ' \[ahead [0-9]\+\]$' >/dev/null; then
			git_remote='ahead'
		elif echo "$git_status_head" | grep ' \[behind [0-9]\+\]$' >/dev/null; then
			git_remote='behind'
		elif echo "$git_status_head" | \
		     grep ' \[ahead [0-9]\+, behind [0-9]\+\]$' >/dev/null; then
			git_remote='diverged'
		fi
		unset git_status_head
	fi

	# Status:
	if [ -z "$git_bare" ]; then
		git_status_body="$(echo "$git_status_full" | tail -n +2 | cut -c 1-2)"
		if echo "$git_status_body" | grep '^.[M?ADRU]' >/dev/null; then
			git_status='modified'
		elif echo "$git_status_body" | grep '^[MADR]' >/dev/null; then
			git_status='staged'
		fi
		unset git_status_body
	fi

	unset git_bare
	unset git_status_full
}
