#!/usr/bin/zsh

########################################################################################
# Configuration for jeffreytse/zsh-vi-mode

########################################################################################
# Enable/disable system clipboard (requires `wl-copy` and `wl-paste` on Wayland)
# Pretty much useless in `ssh` session?
#
# Keybindings:
#
# - Normal: `gp` paste clipboard after cursor, `gP` before cursor
# - Visual: `gp`/`gP` replace selection with clipboard
# - Note: `p`/`P` keep using ZLE's `CUTBUFFER`; `gp`/`gP` use the system clipboard.
#
# Behavior:
# When enabled, yanks/deletes/changes that set `CUTBUFFER` also copy to the system
# clipboard.
# export ZVM_SYSTEM_CLIPBOARD_ENABLED=true

########################################################################################
# In Normal mode, you can use `gx` to open the URL or file path under the cursor.
#
# - If the word under the cursor is a URL (starting with http://, https://, ftp://, file://), it will open in your default web browser.
# - If the word under the cursor is a valid file or directory path, it will open with your system's default application for that file type.

########################################################################################
# Command Line Initial Mode
#
# Default is `insert`
#
# ZVM_MODE_LAST : Starting with last mode (Default).
# ZVM_MODE_INSERT : Starting with insert mode.
# ZVM_MODE_NORMAL : Starting with normal mode.
# export ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
