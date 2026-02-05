#!/usr/bin/zsh

# Use `eza` instead of `ls`
alias ls='eza --color=auto --icons=never --binary'
alias l='eza --color=auto --icons=never --binary -lah'
alias ll='eza --color=auto --icons=never --binary -lh'
alias la='eza --color=auto --icons=never --binary -lah'
alias lsd='eza --color=auto --icons=never --binary --group-directories-first'
alias lst='eza --tree --color=auto --icons=never --binary'

# always output human readable `df`
alias df='df -h'

# ...
# alias dus="du -ah --max-depth=1 | sort -h"

# check disk usage for hidden files
alias dua='du -hs .[^.]* *'

# don't use shell expansion on globs in `find` arguments - let `find expand them on it's
# own`
alias find='noglob find'
