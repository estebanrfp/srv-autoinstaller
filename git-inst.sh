#!/bin/bash

# GIT
apt-get install -y git

# CONFIGURACIÓN
git config --global user.name "estebanrfp"
git config --global user.email estebanrfp@gmail.com
git config --global alias.nicelog 'log --oneline --graph --all'

cat > ~/.bash_profile << "EOF"
parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\u@\h \W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "
EOF
source ~/.bash_profile

cat ~/.bash_profile > ~ubuntu/.bash_profile
chown ubuntu:ubuntu ~ubuntu/.bash_profile