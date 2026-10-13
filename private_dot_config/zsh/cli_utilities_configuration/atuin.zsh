#!/usr/bin/zsh

(( $+commands[atuin] )) || return

# Must be sourced after `cli_utilities_configuration/fzf.zsh`: both fzf and atuin bind
# CTRL+R, and whichever is initialized last wins.
#
# ArrowUP stays `up-line-or-beginning-search` (see `fzf.zsh`) and `?` stays a
# plain character instead of opening Atuin AI.
eval "$(atuin init zsh --disable-up-arrow --disable-ai)"
