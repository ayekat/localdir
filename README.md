dotfiles
========

This is my collection of user/application settings ("dotfiles") and personal
scripts. They are mostly adapted to my personal needs, and some scripts make a
few [assumptions](#assumptions) about the environment that may not necessarily
be considered "standard", so it is **not recommended** to just copy-paste them
as-is.

Nevertheless, I try to keep them as clean and non-WTF as possible, and people
are invited to take a look at them, get ideas for their own dotfiles, and drop
comments, suggestions, questions and bug reports if something seems odd.


XDG/FHS
-------

My goal is to keep the top-level user home directory as clean as possible by
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
| `XDG_RUNTIME_DIR` | `~/.local/run`       |
| `XDG_LIB_HOME`    | `~/.local/lib`       |
| `XDG_LOG_HOME`    | `~/.local/var/log`   |

> ### Notes
> * `XDG_LIB_HOME` and `XDG_LOG_HOME` are non-standard, but they are
>   nevertheless necessary for representing the FHS locally.
> * `~/.local/var` and `~/.local/run` are technically not supposed to be on this
>   level (as this is a variant of `/usr/local`), but for simplicity's sake, I
>   keep them there as well.
> * `~/.local/run` **must** be a symbolic link to `/run/user/<uid>`.
> * Some applications unfortunately do not honour the XDG base directory
>   specifications, so I additionally [set environment
>   variables](pam_environment) or [write wrapper scripts](bin)&mdash;or simply
>   weep (see also [issue #7](https://github.com/ayekat/dotfiles/issues/7)). The
>   [*XDG Base Directory
>   support*](https://wiki.archlinux.org/index.php/XDG_Base_Directory_support)
>   article in the Arch Linux wiki contains a list of applications that honour
>   the specs (or can be made to do so).

Furthermore, the `$PATH` variable is expanded to contain the following
locations (assuming that this repository has been cloned into
`~/.local/lib/dotfiles`):

| Location                    | Description |
| --------------------------- | --- |
| `~/.local/bin`              | User-specific executables (not tracked) |
| `~/.local/lib/dotfiles/bin` | User-specific executables provided by this repository |
| `~/.local/lib/utils/bin`    | User-specific executables provided by the [utils](https://github.co/ayekat/utils) repository |
| `~/.local/opt/altera/...`   | Various paths containing [Altera Quartus II](https://en.wikipedia.org/wiki/Altera_Quartus)-specific executables |


Usage
-----

For using the dotfiles, I clone this repository into `~/.local/lib/dotfiles`,
and then symlink each file/directory to their respective locations:

* `~/.pam_environment` → `~/.local/lib/dotfiles/pam_environment`
* `~/.local/etc` → `~/.local/lib/dotfiles/etc`
* `~/.local/lib/argyll` → `~/.local/lib/dotfiles/lib/argyll`
* `~/.local/lib/python` → `~/.local/lib/dotfiles/lib/python`
* `~/.local/lib/urxvt` → `~/.local/lib/dotfiles/lib/urxvt`
* `~/.local/run` → `/run/user/{uid}`

For Arch Linux systems, there is a [PKGBUILD](archlinux/PKGBUILD) that creates a
meta-package to pull in the required packages.


Assumptions
-----------

The dotfiles have primarily been used on Arch Linux (and for limited use-cases
on Debian, too, although there are minor issues with tmux and [major issues with
PAM](https://github.com/ayekat/dotfiles/issues/8), both related to Debian
shipping antique versions of software).

* For setting the [XDG basedir variables](#xdgfhs) I use `~/.pam_environment`,
  which is read by [PAM](https://wiki.archlinux.org/index.php/PAM). If other
  authentication frameworks are used, these dotfiles will not work as-is (but
  with some additional fiddling in the shell initialisation, it should still be
  doable).

* `/usr/sbin`, `/sbin` and `/bin` are generally assumed to have
  [merged](https://www.archlinux.org/news/binaries-move-to-usrbin-requiring-update-intervention/)
  into `/usr/bin`, so all absolute paths to system-widely available software
  point into `/usr/bin` by default (note that this is a more extreme case of the
  [`/usr`
  merge](https://www.freedesktop.org/wiki/Software/systemd/TheCaseForTheUsrMerge/)).
  Nevertheless, I strive for compatibility with non-Arch Linux systems (even if
  I consider the distinction of those paths to be absolutely unnecessary), so
  please let me know when a path should point somewhere else.

* Lots of configuration files will attempt to run scripts and binaries in
  `~/.local/lib/utils/bin`, provided by the [utils
  repository](https://github.com/ayekat/utils). The missing of latter should be
  non-fatal, though.


Policies
--------

* Application history generally goes into `XDG_DATA_HOME` (see commit f1147a9
  for the reasoning). The only things that go into `XDG_LOG_HOME` are "real"
  logs, i.e. data that is no longer read and used by the application itself. The
  only things that go into `XDG_CACHE_HOME` are files that are non-essential and
  can quickly be regenerated by the application, if needed (which is both not
  the case for history files).

* Applications whose configuration is mixed up with other data (or generally not
  supposed to be manually edited) is put into `XDG_DATA_HOME`, reason being that
  I would like to track `XDG_CONFIG_HOME` with git as much as possible. This of
  course only works for applications that allow configuring the location of
  "config" files.

* Shell-agnostic configuration should happen in `XDG_CONFIG_HOME/sh`. This
  allows other, non-zsh shells to work correctly, too, without having to
  duplicate all the shell configuration. The shell-agnostic configuration is
  stored in `environment`, `login` and `config` as well as `profile` and the
  `profile.d` directory for application-specific profile snippets, while only
  shell-specific configuration (prompts, input, history, etc.) should happen in
  zsh's config.

* Although shell aliases are generally more lightweight than wrapper scripts,
  wrapper scripts allow being used also from a non-shell environment (or with
  `sudo`). So it mostly depends on the application whether we create aliases or
  wrapper scripts for them.


Miscellaneous
-------------

As noted above, these dotfiles represent my personal setup&mdash;nevertheless, I
encourage people to take a look at it, mainly for learning how applications can
be made to (somewhat) conform to the XDG base directory specifications (and thus
have a clean home directory).

There are other, similar "experiments" out there:

* https://github.com/Earnestly/dotfiles
