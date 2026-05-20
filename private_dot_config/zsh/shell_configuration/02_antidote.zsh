#!/usr/bin/zsh

################################################################################
# Antidote
if [[ ! -f ${ZDOTDIR:-~}/.antidote/antidote.zsh ]]; then
    echo "WARNING: antidote not found, skipping plugin loading"
    return
fi
# ... configure antidote itself
zstyle ':antidote:bundle' use-friendly-names on
# ... and now load antidote and plugins
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load
