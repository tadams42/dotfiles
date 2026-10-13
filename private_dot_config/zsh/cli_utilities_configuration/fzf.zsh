#!/usr/bin/zsh

(( $+commands[fzf] )) || return

# see `ENVIRONMENT VARIABLES` in `man fzf`
# copy theme from https://junegunn.github.io/fzf/color-themes
export FZF_DEFAULT_OPTS_FILE=~/.config/fzf/fzfrc

# initialize `fzf` key bindings and completion. Despite living in this file, this binds
# rather more than just history:
#
#   CTRL+R    fuzzy-search command history
#   CTRL+T    fuzzy-search files/dirs below $PWD, paste selection onto the line
#   ALT+C     fuzzy-search dirs below $PWD, `cd` into the selection
#   TAB       fuzzy completion (only for `**` triggers, normal completion otherwise)
#
# Note that ArrowUP is *not* fzf - that is `up-line-or-beginning-search`, bound by
# `ohmyzsh path:lib/key-bindings.zsh` from `.zsh_plugins.txt`.
source <(fzf --zsh)
