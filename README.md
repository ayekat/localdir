dotfiles
========

This repository contains my personal user setup, with scripts and application
configuration, called "dotfiles" for mostly historical reasons.

As I have some very specific requirements for what my work environment should
behave like, the setup here mostly likely differs quite significantly from what
you might expect in a "normal" environment. It is **not recommended** to just
copy-paste files from in here as-is.

Readers are, however, invited to take a look at it, get ideas for their own
setup, and drop comments, suggestions, questions and bug reports if something
feels odd&mdash;beyond the intended base oddity level, of course.


XDG/FHS
-------

My goal is to keep the top-level user home directory as clean as possible by
honouring the [XDG base directory specification][fdo:xdgspec], adapted to
recreate the [Linux file system hierarchy][man:hier] (FHS) under `~/.local`.
This is achieved by setting the environment variables as follows:

| Variable          | Location             |
| ----------------- | -------------------- |
| `XDG_CACHE_HOME`  | `~/.local/var/cache` |
| `XDG_CONFIG_HOME` | `~/.local/etc`       |
| `XDG_DATA_HOME`   | `~/.local/share`     |
| `XDG_STATE_HOME`  | `~/.local/var/lib`   |
| `XDG_LIB_HOME`    | `~/.local/lib`       |
| `XDG_LOG_HOME`    | `~/.local/var/log`   |

> ### Notes
> * `XDG_LIB_HOME` and `XDG_LOG_HOME` are non-standard, but they are
>   nevertheless necessary for representing the FHS locally.
> * `~/.local/var` is technically not supposed to be on this level (`~/.local`
>   is the user version of `/usr/local`), but for keeping it compact, I put it
>   here anyway.
> * Some applications unfortunately do not honour the XDG basedir spec, so I
>   additionally [set environment variables][file:pam_environment] or [write
>   wrapper scripts][dir:wrappers]. Unfortunately, there are still some [open
>   issues][issue:7]). See the [*XDG Base Directory*][aw:xdg] article in the
>   Arch Linux wiki for more information on this.

Furthermore, the `$PATH` variable is expanded to contain the following
locations:

| Location                         | Description                               |
| -------------------------------- | ----------------------------------------- |
| `~/.local/bin`                   | User-specific executables                 |
| `~/.local/lib/dotfiles/wrappers` | User-specific wrappers                    |


Requirements
------------

A POSIX-compatible shell must be available and configured to source the
configuration files in `~/.local/etc/sh` as follows:

 * `profile` › `interactive` › `login` if it's an interactive login
   shell;
 * `interactive` if it's a regular interactive shell;

This repository provides configuration for **ZSH** that does it already. Other
shells must be configured separately. See [Appendix B](#appendix-b-zsh) if ZSH
is desired but not available.

### Assumptions

`/usr/sbin`, `/sbin` and `/bin` are assumed to have [merged][an:usrmerge] into
`/usr/bin` (note that this is a more extreme case of the [`/usr`
merge][fdo:usrmerge]).

Many private configuration files (e.g. mail configuration) reside in my external
localdir repository, cloned to `$XDG_LIB_HOME/private` (if missing, there will
be some dangling symlinks in `$XDG_CONFIG_HOME`, and the corresponding
applications might not work properly).


Installation
------------

Depending on what is provided by the system, the setup procedure might look a
little different.

### Method 1: With `~/.pam_environment`

If PAM is configured to load `pam_env.so` with `user_readenv=1`, the following
will work:

1. `git clone https://github.com/ayekat/dotfiles ~/.local`;
2. `ln -s .local/lib/dotfiles/pam_environment ~/.pam_environment`;
3. Re-login;
4. Profit!

**Warning: `user_readenv` support is deprecated and will likely disappear in a
future version. See [this issue][issue:32] for more details.**

### Method 2: Without `~/.pam_environment`, with ZSH

1. `git clone https://github.com/ayekat/dotfiles ~/.local`;
2. `ln -s .local/lib/dotfiles/config ~/.config`;
3. `ln -s .local/etc/zsh/.zshenv ~/.zshenv`;
4. Re-login;
5. Profit!


Appendix A: Rules
-----------------

 * If an application does not respect the XDG base directory specification at
   all, we try to fix it either via environment variable in
   `$XDG_CONFIG_HOME/environment.d/xdg.conf` (if possible), or through a wrapper
   script. If such an application mixes configuration and state information, we
   cannot reasonably track the configuration in Git anyway, so we make it drop
   its data into `XDG_STATE_HOME`.

 * Commandline history files go into `XDG_STATE_HOME`, and not elsewhere.
   `XDG_LOG_HOME` only contains files that are not read back by the application,
   and `XDG_CACHE_HOME` only contains files that can be easily regenerated; both
   do not apply to history files.

 * Shell-agnostic configuration should happen in `XDG_CONFIG_HOME/sh`. This
   allows other, non-zsh shells to work correctly, too, without having to
   duplicate all the shell configuration. The shell-agnostic configuration is
   stored in `sh/config`, `sh/profile`, `sh/interactive` and `sh/login` (plus
   the respective `.d` subdirectories), while only shell-specific configuration
   should happen in their respective shell's configuration.

 * Although shell aliases are generally more lightweight than wrapper scripts,
   wrapper scripts allow being used from any environment (not just interactive
   shells). So it mostly depends on the application and usecase whether we
   create an aliase or a wrapper script for something.


Appendix B: ZSH
---------------

This section addresses some cases where ZSH is not available as a login shell
(or not available at all), and you lack the necessary permissions on the system
to fix that properly.

### Not available as login shell

If ZSH is installed, but for some reason `chsh -s /usr/bin/zsh` does not work,
the following should fix that (assuming Bash is the login shell):

```
# ~/.bash_login
ZDOTDIR=~/.local/etc/zsh zsh -l && exit
```

It is not recommended to use `exec zsh`, as any issue with the ZSH invocation
might lead to you getting locked out.

### Not available at all

If ZSH isn't installed on the system, do not despair! ZSH can be built and
installed into your home directory.

To do so, ensure that the necessary build tools are available (`make` and `gcc`,
and the ncurses development headers if packaged separately).

> If building on the target system is not an option, just ensure that your build
> environment provides ncurses and glibc installations that are ABI-compatible
> with what is installed on the target system, and the paths (home directory
> location) are the same. The easiest way is probably by building a local VM
> that resembles the target system.

1. Get the ZSH source and `cd` into the project directory;
2. `./configure --prefix="$HOME/.local/opt/foobar"` (replace `foobar` by
   something more suitable);
3. `make`
4. `make install`

If all went well, ZSH is now installed in `~/.local/opt/foobar`. Copy that
directory to the target system at the same location. You may now invoke
`~/.local/opt/foobar/bin/zsh`.

To set it as a "login shell", the following should work (again, assuming Bash as
the login shell):

```
# ~/.bash_login
export PATH=~/.local/opt/foobar/bin:$PATH
ZDOTDIR=~/.local/etc/zsh zsh -l && exit
```

Note that you can also just invoke `~/.local/opt/foobar/bin/zsh` directly
without extending `$PATH` like that, but that will look a bit ugly in the
process list.


Links
-----

 * [XDG Base Directory - ArchWiki][aw:xdg]
 * https://github.com/Earnestly/dotfiles (inspired by Plan9's filesystem layout;
   see also [The `~/.local` Convention][localconv]).
 * https://github.com/roosemberth/dotfiles (semi-fork of this repo, adapted for
   NixOS).


[an:usrmerge]: https://www.archlinux.org/news/binaries-move-to-usrbin-requiring-update-intervention/
[aw:pam]: https://wiki.archlinux.org/index.php/PAM
[aw:xdg]: https://wiki.archlinux.org/index.php/XDG_Base_Directory
[dir:wrappers]: lib/dotfiles/bin
[fdo:xdgspec]: https://specifications.freedesktop.org/basedir-spec/latest/index.html
[fdo:usrmerge]: https://www.freedesktop.org/wiki/Software/systemd/TheCaseForTheUsrMerge/
[file:pam_environment]: pam_environment
[file:pkgbuild]: archlinux/PKGBUILD
[issue:7]: https://github.com/ayekat/dotfiles/issues/7
[issue:8]: https://github.com/ayekat/dotfiles/issues/8
[issue:12]: https://github.com/ayekat/dotfiles/issues/12
[issue:32]: https://github.com/ayekat/dotfiles/issues/32
[localconv]: https://gist.github.com/Earnestly/84cf9670b7e11ae2eac6f753910efebe
[man:hier]: http://linux.die.net/man/7/hier
