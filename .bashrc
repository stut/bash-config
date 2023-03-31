#!/bin/bash

# bring in system bashrc
test -r /etc/bashrc &&
      . /etc/bashrc

# git completion
test -r /usr/share/git-core/contrib/completion/git-prompt.sh &&
      . /usr/share/git-core/contrib/completion/git-prompt.sh
test -r /usr/share/git-core/contrib/completion/git-prompt.sh ||
      . ~/.git-prompt.sh

# notify of bg job completion immediately
set -o notify

# shell opts. see bash(1) for details
shopt -s cdspell >/dev/null 2>&1
shopt -s extglob >/dev/null 2>&1
shopt -s histappend >/dev/null 2>&1
shopt -s hostcomplete >/dev/null 2>&1
shopt -s interactive_comments >/dev/null 2>&1
shopt -u mailwarn >/dev/null 2>&1
shopt -s no_empty_cmd_completion >/dev/null 2>&1

# don't care about local mail
unset MAILCHECK

# disable core dumps
ulimit -S -c 0

# default umask
umask 0022

# we want the various sbins on the path along with /usr/local/bin
PATH="$PATH:/usr/local/bin:/usr/local/sbin:/usr/sbin:/sbin"

# put ~/.bin on PATH if you have it
test -d "$HOME/.bin" &&
  PATH="$HOME/.bin:$PATH"

# detect interactive shell
case "$-" in
    *i*) INTERACTIVE=yes ;;
    *)   unset INTERACTIVE ;;
esac

# detect login shell
case "$0" in
    -*) LOGIN=yes ;;
    *)  unset LOGIN ;;
esac

# enable en_GB locale w/ utf-8 encodings if not already configured
: ${LANG:="en_GB.UTF-8"}
: ${LANGUAGE:="en"}
: ${LC_CTYPE:="en_GB.UTF-8"}
: ${LC_ALL:="en_GB.UTF-8"}
export LANG LANGUAGE LC_CTYPE LC_ALL

# ignore backups, CVS directories, python bytecode, vim swap files
FIGNORE="~:CVS:#:.pyc:.swp:.swa"

# history stuff
HISTCONTROL=ignoreboth
HISTFILESIZE=10000
HISTSIZE=10000

export EDITOR="nvim"

# disk usage with human sizes and minimal depth
alias du1='du -h --max-depth=1'
alias fn='find . -name'

test -z "$BASH_COMPLETION" && {
    bash=${BASH_VERSION%.*}; bmajor=${bash%.*}; bminor=${bash#*.}
    test -n "$PS1" && test $bmajor -gt 1 && {
        # search for a bash_completion file to source
        for f in /usr/local/etc/bash_completion \
                 /usr/pkg/etc/bash_completion \
                 /opt/local/etc/bash_completion \
                 /etc/bash_completion
        do
            test -f $f && {
                . $f
                break
            }
        done
    }
    unset bash bmajor bminor
}

# Usage: puniq [<path>]
# Remove duplicate entries from a PATH style value while retaining
# the original order. Use PATH if no <path> is given.
#
# Example:
#   $ puniq /usr/bin:/usr/local/bin:/usr/bin
#   /usr/bin:/usr/local/bin
puniq () {
    echo "$1" |tr : '\n' |nl |sort -u -k 2,2 |sort -n |
    cut -f 2- |tr '\n' : |sed -e 's/:$//' -e 's/^://'
}

alias ls=exa
alias ll="ls -lh"
alias l.="ll -d .*"
alias l='ll -Gl'
alias la="ll -a"
alias lg='ll | grep'
alias df='df -hk'
alias dl='df -hk |grep /dev/'
alias du='du -hk'
alias ping='ping -c 4'
alias g='grep'
alias pg='ps wwaux | grep -v grep | grep'
alias ssha='eval `ssh-agent` && ssh-add'
alias e=vim
alias se='sudo vim'
hash nvim 2>/dev/null && alias vim=nvim
hash batcat 2>/dev/null && alias bat=batcat
hash bat 2>/dev/null && alias less=bat
hash bat 2>/dev/null && alias cat=bat
alias tmux="TERM=xterm-256color tmux"
alias play="cvlc --play-and-exit"

# bring in local bashrc
test -r ~/.bashrc_local &&
      . ~/.bashrc_local

test -r /usr/local/go/bin/go && export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/code/go
export GOBIN=$GOPATH/bin
export PATH=$GOBIN:$PATH

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

export EDITOR="nvim"

# condense PATH entries
MANPATH=$(puniq $MANPATH)

test -n "$INTERACTIVE" -a -n "$LOGIN" && {
    uname -npsr
    uptime
}

PS1='\n\[\033[0;36m\]\u\[\033[0;31m\]@\[\033[0;34m\]\h\[\033[0;34m\]\[\033[0;33m\]\[$(__git_ps1)\]\[\033[0;32m\] \[\033[0;31m\]\w\[\033[0;32m\]\n\[\033[0;34m\]\[\033[0;37m\]$ \[\033[0m\]'

function ip_from_mac {
    nmap -sP 192.168.1.0/24 >/dev/null && arp -an | grep -i $1 | awk '{print $2}' | sed 's/[()]//g'
}

function gf {
  find . -name "$1" | xargs grep -i "$2"
}

alias slack="slack -s"

[ -f $HOME/.cargo/env ] && source "$HOME/.cargo/env"

# Hashicorp Autocompletes
for i in consul nomad terraform vault packer waypoint boundary
do
  complete -C /bin/${i} ${i}
done

alias wsleft="i3-msg move workspace to output left"
alias wsright="i3-msg move workspace to output right"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

export PATH=$(puniq $PATH)

source ~/.git-prompt.sh

