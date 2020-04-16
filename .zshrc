# vim: set foldmethod=marker foldlevel=1:
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="ohle"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(gitfast colorize vi-mode zsh-syntax-highlighting bgnotify catimg nvr taskwarrior zsh-autosuggestions jpk-help history-substring-search)

# User configuration

export GOPATH="$HOME/gocode"
export PATH="/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games"
export PATH="$PATH:$HOME/anaconda3/bin"
export PATH="$HOME/.pyenv/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"
export PATH="$HOME/local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/snap/bin:$PATH"
export PATH="/home/ohle/pebble-dev/pebble-sdk-4.5-linux64/bin/:$PATH"
export PATH="$PATH:/usr/lib/go-1.12/bin"

export MVN_HOME="$HOME/Apps/maven/"
# export MANPATH="/usr/local/man:$MANPATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_COMPLETION_TRIGGER=''
bindkey -M viins '^T' fzf-completion

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias ack="ack-grep"

export EDITOR="$HOME/local/bin/nvr-edit"
export MANPAGER="nvim -c 'set ft=man' -"
eval $(dircolors $HOME/dircolors-solarized/dircolors.ansi-dark)

export DEBFULLNAME="JPK Instruments AG (maintainer)"
export DEBEMAIL="maintainer@jpk.com"
export GIT_AUTHOR_NAME="Ohle Claussen"

export BROWSER="/usr/bin/firefox"

# Mostly for dockerized-build-host

[ -n "$TMUX" ] && export TERM=screen-256color

# Workaround for buggy gnome-terminal
export NVIM_TUI_ENABLE_CURSOR_SHAPE=0

# Enable 256 color support
case "$TERM" in
    'xterm') TERM=xterm-256color;;
    'screen') TERM=xterm-256color;;
esac
export TERM

# Workaround for neovim cursor shape issuse
# See https://github.com/neovim/neovim/wiki/FAQ#how-can-i-change-the-cursor-shape-in-the-terminal
export VTE_VERSION="100"

GPG_TTY=$(tty)
export GPG_TTY

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ];
then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# export PYENV_ROOT="$HOME/.pyenv"
# eval "$(pyenv init -)"

# Use bash completion functions
autoload -U +X bashcompinit && bashcompinit
[ -e /usr/share/bash-completion/completions/spm ] && source /usr/share/bash-completion/completions/spm

# Borg backup
export BORG_REPO=/media/timecapsule/borg-backups/
export BORG_PASSCOMMAND="pass show backup"

local JPK_GIT_KEY=/platter/ohle/trusty-chroot/home/ohle/.vcsconfig/ssh/jpk-git-key
# eval $(keychain --quiet --agents gpg,ssh --eval id_rsa "$JPK_GIT_KEY")
source $HOME/.vim/bundle/vmux/plugin/setup_vmux.sh

export PEBBLE_PHONE=192.168.0.10

function c() {
    cd ${XCWD}
}

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/claussen/.sdkman"
[[ -s "/home/claussen/.sdkman/bin/sdkman-init.sh" ]] && source "/home/claussen/.sdkman/bin/sdkman-init.sh"

source $GOPATH/src/github.com/sachaos/todoist/todoist_functions_fzf.sh
#source /home/claussen/third-party/forgit/forgit.plugin.zsh
eval $(starship init zsh)

[ -s "/home/claussen/.scm_breeze/scm_breeze.sh" ] && source "/home/claussen/.scm_breeze/scm_breeze.sh"

source /home/claussen/.config/broot/launcher/bash/br

bindkey -M viins "^[^M" self-insert-unmeta # alt-enter for multiline linebreak instead of execute 
bindkey -M viins "^q" push-line-or-edit
bindkey -M vicmd "q" push-line-or-edit
bindkey -M viins "^A" accept-and-hold
bindkey -M viins "^H" run-help
