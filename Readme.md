# Dot file management

## Usage
Use a bare repository `$HOME/.myconf` to track dotfiles. Useful alias:

```sh
alias config='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME
```

### Hiding untracked files from status
```sh
config config status.showUntrackedFiles no
```

### Cloning
```sh
git clone --separate-git-dir=$HOME/.myconf/ repo $HOME/myconf-tmp
rm -r $HOME/myconf-tmp/
alias config='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME
```
