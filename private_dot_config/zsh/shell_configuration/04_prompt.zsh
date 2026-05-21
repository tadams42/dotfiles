#!/usr/bin/zsh

################################################################################
# setup starfish.rs prompt
if (( $+commands[starship] )); then
    eval "$(starship init zsh)"
else
   autoload -Uz promptinit
   promptinit
   prompt adam1
fi
