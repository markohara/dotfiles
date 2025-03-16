# dotfiles

To configure execute the platform of choice

```
./macos
```

To configure your git user run the following, then update it to reflect your current git user.

```
make init.local.gitconfig
```

### Sessionizer configuration
By default fresh installs include config and dotfiles, to add additional files to the search path set these vars in `.zprofile.local`

```
SESSIONIZER_DIRS="$SESSIONIZER_DIRS:"
SESSIONIZER_PROJECTS="$SESSIONIZER_PROJECTS:"
```