# Dotfiles

### New Machine?
```bash
/bin/bash -c "$(curl -fsSL setup.markohara.com)"
```

> **Note:** Run this command only when setting up a new development environment to install both config and dotfiles.

To configure execute the platform of choice

```bash
./macos
```

To configure your git user run the following, then update it to reflect your current git user.

```bash
make init.local.gitconfig
```

### Sessionizer configuration
By default fresh installs include config and dotfiles, to add additional files to the search path set these vars in `.zprofile.local`

```bash
SESSIONIZER_DIRS="$SESSIONIZER_DIRS:"
SESSIONIZER_PROJECTS="$SESSIONIZER_PROJECTS:"
```