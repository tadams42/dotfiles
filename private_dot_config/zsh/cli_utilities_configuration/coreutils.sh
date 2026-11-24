#!/usr/bin/zsh

(( $+commands[eza] )) || return

# Use `eza` instead of `ls`
alias ls='eza --group-directories-first --color=auto --icons=never --binary'
alias l='eza --long --git --header -F --group-directories-first --color=auto --icons=never --binary'
alias ll='eza --long --git --header --group-directories-first --color=auto --icons=never'
alias la='eza --long --all --header --group-directories-first --color=auto --icons=never'
alias l.='eza -ld .* --icons=auto'                                      # Only hidden files/dirs in current dir

# lt — Tree view with customizable depth
# Example:
#     lt 3 ./private_dot_config/
lt() {
  local level=2
  if [[ "$1" =~ ^[0-9]+$ ]]; then
    level="$1"
    shift
  fi
  eza --tree --level="$level" --icons=auto --group-directories-first "$@"
}

# always output human readable `df`
alias df='df -h'

# ...
# alias dus="du -ah --max-depth=1 | sort -h"

# check disk usage for hidden files
alias dua='du -hs .[^.]* *'

# don't use shell expansion on globs in `find` arguments - let `find expand them on it's
# own`
alias find='noglob find'
