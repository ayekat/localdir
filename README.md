dotfiles
========

This is my collection of user/application settings ("dotfiles") and personal
scripts. They are mostly adapted to my personal needs, and some scripts make
assumptions about the environment that are not necessarily considered
"standard". Nevertheless, I try to keep them as clean and non-WTF as possible,
and people are invited to take a look at them, get ideas for their own dotfiles,
and drop comments if something seems odd.

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

> ### Notes
> * `XDG_LIB_HOME` and `XDG_LOG_HOME` are non-standard, but they are
>   nevertheless necessary for representing the FHS locally.
> * `~/.local/run` **must** be a symbolic link to `/run/user/<uid>`.

Unfortunately, some application do not honour the XDG basedir specification, and
setting above variables is often not enough. Various approaches are taken to
achieve the goal:

* For applications using their own environment variables, a simple entry in
  `~/.local/etc/sh/environment` is usually enough.
* For applications accepting command line arguments, we create local "fake"
  (wrapper) scripts in `~/.local/bin` that call the real application with the
  right arguments.
* For applications where neither of these apply, we weep (or set `$HOME`
  read-only).

Some applications cannot honour the XDG basedir spec by design:


shells
------

Shells pose a bit of a hen-and-egg problem, given that they cannot respect the
XDG basedir specification in any sensible way (environment variables are defined
by the shell *itself*); in that case, we cannot prevent the creation/usage of
dotfiles directly in the top-level home directory.

> ### Note
> Of course, one could modify the configuration files under `/etc`, but the goal
> is to keep this repository user-only; both for simplicity, and to allow their
> usage in an environment where admin-rights are not available.

To reduce the amount of "noise" in `~`, we let the shell read its user
environment file, in which we define all the necessary variables, and the rest
should work as described above.

Concretely, this means that for **zsh** `.zshenv` is at the top-level. For
**bash**, it's a little less clean, since it does not have any mechanisms for
changing the location of its configuration files, so both `.bash_profile` and
`.bashrc` are at the top-level.

To reduce redundancy, most shell configuration happens in a shell-agnostic
environment, namely `~/.local/etc/sh`; the shell-specific configuration files
then source the generic `environment`, `login` and `config` files, and only
configure the shell-specific behaviour (e.g. prompts, input, history) on their
own.


arbitrary?
----------

Sometimes it is not obvious whether something needs to go into `XDG_CACHE_HOME`
or `XDG_LOG_HOME` (e.g. shell (and generally CLI application commands) history
&mdash; technically a cache, but practically treated like a history/log). The
same applies to the separation of `XDG_CONFIG_HOME` and `XDG_DATA_HOME` for
applications that change their configuration (files) at runtime (e.g. gimp).

Most decisions are made arbitrarily in those cases. If you have an argument for
or against a decision, feel free to leave a comment. I'm open for all kinds of
ideas, may they be profoundly researched or crazy.
