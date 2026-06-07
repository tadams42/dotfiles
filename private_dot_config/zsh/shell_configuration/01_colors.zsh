#!/usr/bin/zsh

################################################################################
# Setup LS_COLORS env variable
if (( $+commands[vivid] )); then
    export LS_COLORS="$(vivid generate tokyonight-night)"
elif (( $+commands[dircolors] )); then
    [[ -f "$HOME/.dircolors" ]] \
      && source <(dircolors -b "$HOME/.dircolors") \
      || source <(dircolors -b)
fi

# Loads and initializes a set of associative arrays that map color names to ANSI escape
# codes
autoload -U colors && colors
