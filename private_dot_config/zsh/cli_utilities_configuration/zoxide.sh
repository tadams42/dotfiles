#!/usr/bin/zsh

(( $+commands[zoxide] )) || return

################################################################################
# setup zoxide integration
#
# This must be run AFTER `compinit` is called.
# When first installed, you may have to rebuild your completions cache.
# Just remove it and let ZSH do the work:
#
#     rm -r ~/.cache/zsh/zcompcache/ ~/.cache/zsh/zcompdump
eval "$(zoxide init zsh)"
