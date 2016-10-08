mutt
====

My mutt mail configuration is a little unusual; it is due to me being too dumb
to configure mutt's account/folder hooks correctly (i.e. in a way that switching
accounts/directory isn't a major PITA).

As such, `mutt` must be launched with `-F /path/to/config.muttrc` (you probably
want to script that or write an alias). The disadvantage is that you cannot
reply to mails in one mailbox from another account. I get occasionally annoyed
by that setup and will likely change this soon.


Passwords
---------

All account's configuration files execute/source the `password.sh` script with
an argument; depending on the argument, the script should set the three mutt
variables `my_user`, `my_address` and `my_password`.

An example `password.sh`, using [pass](https://www.passworstore.org/), would be:

```sh
#!/usr/bin/env sh

case "$1" in
	google)
		address='ayekat@gmail.com'
		user='ayekat'
		;;
	company)
		address='ayekat@company.com'
		user='mrayekat'
		;;
	*)
		printf "unknown account: %s\n" "$1" >&2
		exit 1
		;;
esac
test -n "$user" || user="$address"

printf "set my_user = '%s'\n" "$user"
printf "set my_address = '%s'\n" "$address"
printf "set my_password = '%s'\n" "$(pass show mail/"$address" | head -n 1)"
```
