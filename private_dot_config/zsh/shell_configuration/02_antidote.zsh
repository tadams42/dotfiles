#!/usr/bin/zsh

################################################################################
# Antidote
# ... configure antidote itself
zstyle ':antidote:bundle' use-friendly-names on
# ... and now load antidote and plugins
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load
