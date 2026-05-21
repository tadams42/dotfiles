#!/usr/bin/zsh

[[ -z "$HISTFILE" ]] && export HISTFILE="${XDG_DATA_HOME}/zsh/history"
export HISTSIZE=50000
export SAVEHIST=10000

# If this is set, zsh sessions will append their history list to the history file,
# rather than replace it. Thus, multiple parallel zsh sessions will all have the new
# entries from their history lists added to the history file, in the order that they
# exit. The file will still be periodically re-written to trim it when the number of
# lines grows 20% beyond the value specified by $SAVEHIST
# setopt APPEND_HISTORY
#
# This option works like APPEND_HISTORY except that new history lines are added to the
# $HISTFILE incrementally (as soon as they are entered), rather than waiting until the
# shell exits. The file will still be periodically re-written to trim it when the number
# of lines grows 20% beyond the value specified by $SAVEHIST
#
# Options INC_APPEND_HISTORY, INC_APPEND_HISTORY_TIME and SHARE_HISTORY are mutually
# exclusive
setopt INC_APPEND_HISTORY
setopt NO_INC_APPEND_HISTORY_TIME
setopt NO_SHARE_HISTORY

# Save each command’s beginning timestamp (in seconds since the epoch) and the duration
# (in seconds) to the history file.
setopt EXTENDED_HISTORY

# If the internal history needs to be trimmed to add the current command line, setting
# this option will cause the oldest history event that has a duplicate to be lost before
# losing a unique event from the list. You should be sure to set the value of HISTSIZE
# to a larger number than SAVEHIST in order to give you some room for the duplicated
# events, otherwise this option will behave just like HIST_IGNORE_ALL_DUPS once the
# history fills up with unique events.
setopt HIST_EXPIRE_DUPS_FIRST

# When searching for history entries in the line editor, do not display duplicates of a
# line previously found, even if the duplicates are not contiguous.
setopt HIST_FIND_NO_DUPS

# Do not enter command lines into the history list if they are duplicates of the
# previous event.
setopt HIST_IGNORE_DUPS

# If a new command line being added to the history list duplicates an older one, the
# older command is removed from the list (even if it is not the previous event).
setopt HIST_IGNORE_ALL_DUPS

# Remove command lines from the history list when the first character on the line is a
# space
setopt HIST_IGNORE_SPACE

# Remove superfluous blanks from each command line being added to the history list.
setopt HIST_REDUCE_BLANKS

# When writing out the history file, older commands that duplicate newer ones are
# omitted.
setopt HIST_SAVE_NO_DUPS

# When writing out the history file, by default zsh uses ad-hoc file locking to avoid
# known problems with locking on some operating systems. With this option locking is
# done by means of the system’s fcntl call, where this method is available. On recent
# operating systems this may provide better performance
#
# Also, HIST_SAVE_BY_COPY which is ON by default:
#
# When the history file is re-written, we normally write out a copy of the file named
# $HISTFILE.new and then rename it over the old one. However, if this option is unset,
# we instead truncate the old history file and write out the new version in-place.
# Disable this only if you have special needs.
setopt HIST_FCNTL_LOCK

# Whenever the user enters a line with history expansion, don’t execute the line
# directly; instead, perform history expansion and reload the line into the editing
# buffer.
setopt HIST_VERIFY

# In ZSH, `history` is shell builtin command equivalent to call of another shell builtin
# command `fc -l` (`help history` showa all the docs for `fc`).
#
# When used like that, it shows only last 16 entries. To see more:
#
# history 1             # Show all history from entry 1
# history -100          # Show last 100 entries
# history 1 -1          # Explicit: from first to last
#
# Following alias is for the times when you want to browse a lot of history in `$PAGER`.
#
# history | less
# history | tac | less
#
# For everything else, it is better to type `CTRL+R` and let `fzf` do it's magic.
alias history='history -500'

################################################################################
# setup fzf integration
(( $+commands[fzf] )) || return

# ZSH arrays:
#   - space separated stuff becomes array items
#   - `(j:,:)` - joins array items with `,`
FZF_COLORS_ARRAY=(
  --color=dark fg:-1 bg:-1 hl:#c678dd fg+:#ffffff bg+:#4b5263 hl+:#d858fe info:#98c379
  prompt:#61afef pointer:#be5046 marker:#e5c07b spinner:#61afef header:#61afef
)
FZF_COLORS="${(j:,:)FZF_COLORS_ARRAY}"
# see `ENVIRONMENT VARIABLES` in `man fzf`
if [[ ! -v FZF_DEFAULT_OPTS && ! -v FZF_DEFAULT_OPTS_FILE ]]; then
    # If there are no external fzf configs, we use our own color theme
    export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} ${FZF_COLORS}"
fi
unset FZF_COLORS
unset FZF_COLORS_ARRAY

# initialize `fzf` to handle command history via CTRL+R / ArrowUP keys
source <(fzf --zsh)
