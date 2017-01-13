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
| `XDG_RUNTIME_DIR` | `~/.local/run`       |
| `XDG_LIB_HOME`    | `~/.local/lib`       |
| `XDG_LOG_HOME`    | `~/.local/var/log`   |

> ### Notes
> * `XDG_LIB_HOME` and `XDG_LOG_HOME` are non-standard, but they are
>   nevertheless necessary for representing the FHS locally.
> * `~/.local/run` **must** be a symbolic link to `/run/user/<uid>`.

Furthermore, user-specific applications and scripts are expected to be placed in
`~/.local/bin`.

Unfortunately, some application do not honour the XDG basedir specification, and
setting above variables is often not enough. Various approaches are taken to
achieve the goal:

* For applications using their own environment variables, a simple entry in
  `~/.pam_environment` is usually enough.
* For applications accepting command line arguments, there are local "fake"
  (wrapper) scripts in `.local/bin` that call the real application with the
  right arguments.
* For applications where neither of these apply, I weep.

See [XDG Base Directory
support](https://wiki.archlinux.org/index.php/XDG_Base_Directory_support) in the
Arch Linux wiki for more details about which applications honour the specs.

There is [`inotifywatchdog`](.local/bin/inotifywatchdog), a script that notifies
you of any changes in a watched directory (ideally you might want to [watch
`HOME`](.local/etc/inotifywatchdog/config)) &mdash; there is also a
corresponding systemd user service file.


Assumptions
-----------

This dotfiles repository assumes the following:

* For setting the [XDG basedir variables](#xdgfhs) I use `~/.pam_environment`,
  which is read by [PAM](https://wiki.archlinux.org/index.php/PAM). If other
  authentication frameworks are used, this repository will not work as-is.

* The dotfiles have primarily been used on Arch Linux (and for limited use-cases
  on Debian, too, although the tmux config has a slight, non-fatal
  incompatibility with the antique version of tmux shipped with Debian), so a
  few Arch Linux specific quirks apply (which is not a lot, since most software
  there is shipped vanilla):

  * `/usr/sbin`, `/sbin` and `/bin` are assumed to have been
    [merged](https://www.archlinux.org/news/binaries-move-to-usrbin-requiring-update-intervention/)
    into `/usr/bin`, so all absolute paths to system-widely available software
    point into `/usr/bin` (note that this is a more extreme case of the [`/usr`
    merge](https://www.freedesktop.org/wiki/Software/systemd/TheCaseForTheUsrMerge/)).


Policies
--------

* Logs generally go into `XDG_LOG_HOME`, even if they may technically count as
  "cache" (e.g. shell history), reason being that `XDG_CACHE_HOME` should only
  contain data that I would not be sad about losing (whereas I have very strong
  feelings about my shell history). This of course only works for applications
  that allow configuring the location of log files.

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
