#!/usr/bin/zsh

################################################################################
# Setup LS_COLORS env variable
# Use our own `~/.dircolors` theme if it exists or default one from `/usr/bin/dircolors`
if (( $+commands[dircolors] )); then
    [[ -f "$HOME/.dircolors" ]] \
      && source <(dircolors -b "$HOME/.dircolors") \
      || source <(dircolors -b)
fi

# Loads and initializes a set of associative arrays that map color names to ANSI escape
# codes
autoload -U colors && colors
