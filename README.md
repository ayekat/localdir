dotfiles
========

This is my collection of user/application settings ("dotfiles") and personal
scripts. They are mostly adapted to my personal needs, and some scripts may make
[unfortunate assumptions about the environment](#assumptions) (most likely not
considered "standard"). Nevertheless, I try to keep them as clean and non-WTF as
possible, and people are invited to take a look at them, get ideas for their own
dotfiles, and drop comments if something seems odd.

For using the dotfiles, I place them in some location (e.g.
`~/.local/lib/dotfiles`), then symlink each file/directory to their respective
locations.


XDG/FHS
-------

I try to keep the top-level user home directory as clean as possible by
honouring the [XDG base directory
specification](https://specifications.freedesktop.org/basedir-spec/latest/index.html),
adapted to recreate the [Linux file system
hierarchy](http://linux.die.net/man/7/hier) (FHS) under `~/.local`. In detail,
this means that the following environment variables are set:

| Variable          | Location             |
| ----------------- | -------------------- |
| `XDG_CACHE_HOME`  | `~/.local/var/cache` |
| `XDG_CONFIG_HOME` | `~/.local/etc`       |
| `XDG_DATA_HOME`   | `~/.local/var/lib`   |
| `XDG_LIB_HOME`    | `~/.local/lib`       |
| `XDG_LOG_HOME`    | `~/.local/var/log`   |
| `XDG_RUNTIME_DIR` | `~/.local/run`       |
| `XDG_TMP_HOME`    | `~/.local/tmp`       |

> ### Notes
> * `XDG_LIB_HOME`, `XDG_LOG_HOME` and `XDG_TMP_HOME` are non-standard, but they
>   are nevertheless necessary for representing the FHS locally.
> * `~/.local/run` **must** be a symbolic link to `/run/user/<uid>`.

Unfortunately, some application do not honour the XDG basedir specification, and
setting above variables is often not enough. Various approaches are taken to
achieve the goal:

* For applications using their own environment variables, a simple entry in
  `~/.pam_environment` is usually enough.
* For applications accepting command line arguments, we create local "fake"
  (wrapper) scripts in `~/.local/bin` that call the real application with the
  right arguments.
* For applications where neither of these apply, we weep (or maybe set `$HOME`
  read-only?)

There is [`inotifywatchdog`](.local/bin/inotifywatchdog), a script that notifies
you of any changes in a watched directory (ideally you might want to [watch
`$HOME`](.local/etc/inotifywatchdog/config)).


Assumptions
-----------

This dotfiles repository assumes the following:

* For setting the [XDG basedir variables](#xdgfhs) I use `~/.pam_environment`,
  which is read by [PAM](https://wiki.archlinux.org/index.php/PAM). If other
  authentication frameworks are used, this repository will not work as-is.
  Earlier versions used to set those variables in `~/.local/etc/sh/environment`,
  but this did not work for systemd user services.


Shells
------

Currently this repository contains configuration files for both bash and zsh. To
reduce redundancy, most shell configuration happens in a shell-agnostic
environment, namely `~/.local/etc/sh`; the shell-specific configuration files
then source the generic `environment`, `login` and `config` files, and only
configure the shell-specific behaviour (e.g. prompts, input, history) on their
own.


Arbitrary?
----------

Sometimes it is not obvious whether something needs to go into `XDG_CACHE_HOME`
or `XDG_LOG_HOME` (e.g. shell (and generally CLI application commands) history
&mdash; technically a cache, but practically treated like a history/log). The
same applies to the separation of `XDG_CONFIG_HOME` and `XDG_DATA_HOME` for
applications that change their configuration (files) at runtime (e.g. gimp).

Most decisions are made arbitrarily in those cases. If you have an argument for
or against a decision, feel free to leave a comment. I'm open for all kinds of
ideas, may they be profoundly researched or crazy.
