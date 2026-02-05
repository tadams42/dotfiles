#!/usr/bin/zsh

EXC_FOLDERS="{.bzr,CVS,.git,.hg,.svn,.idea,.tox,.venv,venv}"
GREP_OPTIONS="--color=auto --exclude-dir=$EXC_FOLDERS"

alias grep="grep $GREP_OPTIONS"

# Do we really need these? At least on Ubuntu they exist in `/usr/bin`.
# alias egrep="grep -E"
# alias fgrep="grep -F"

unset GREP_OPTIONS EXC_FOLDERS
