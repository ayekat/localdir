# less

# Friendlier colours, for manpages:
LESS_TERMCAP_me="$(printf '\033[0m')"
LESS_TERMCAP_se="$(printf '\033[0m')"
LESS_TERMCAP_so="$(printf '\033[30;43m')"
LESS_TERMCAP_ue="$(printf '\033[0m')"
LESS_TERMCAP_us="$(printf '\033[32m')"
LESS_TERMCAP_mb="$(printf '\033[34m')"
LESS_TERMCAP_md="$(printf '\033[31m')"
export LESS_TERMCAP_mb LESS_TERMCAP_md LESS_TERMCAP_me LESS_TERMCAP_se \
       LESS_TERMCAP_so LESS_TERMCAP_ue LESS_TERMCAP_us
