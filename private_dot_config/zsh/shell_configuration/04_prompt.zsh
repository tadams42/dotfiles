#!/usr/bin/zsh

################################################################################
# setup starfish.rs prompt
if (( $+commands[starship] )); then
    eval "$(starship init zsh)"
else
    echo "WARNING: starship not found, using fallback prompt"
    PS1='%n@%m %~%# '
fi
