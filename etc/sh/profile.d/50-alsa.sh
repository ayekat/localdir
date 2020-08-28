# Force ALSA to use internal speakers on gurke.
# (hacky workaround until we move to PulseAudio)

if [ "$(uname -n)" = 'gurke' ]; then
	export ALSA_CARD=PCH
	systemctl --user import-environment ALSA_CARD
fi
