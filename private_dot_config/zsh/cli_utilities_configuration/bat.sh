#!/usr/bin/zsh

# When `bat` is installed from official Ubuntu package it is named `batcat` because of
# name conflict with other, older and unrelated package. So, we'd need following alias:
#
# alias bat=batcat
#
# Since we are installing `bat` directly from GH release into `/usr/local/bin` and are
# not using that other Ubuntu package - we don't need that alias.

################################################################
# Use bat as man pager
################################################################

# The -c option in the MANROFFOPT environment variable tells the man page formatter
# (typically groff or mandoc) to produce plain ASCII output without using SGR (Select
# Graphic Rendition) escape sequences for formatting.
#
# Most common SGR sequences emmitted by man are
#
# - Historically, to make text bold or underlined on physical teletype printers,
#   programs would send a character, a backspace (`\x08`), and then the same character
#   again (for bold) or an underscore (for underlining).
# - The ANSI Escape sequences for colors
#
# This option is used in following scenarios:
#
# - backward compatibility with (very) old terminals
# - man page post processing
#
# We will be configuring bat for post-processing, so it is best to actually use this
# option
#
# On older systems this might not be enough: `man` command may still output it's own
# SGR and break `bat` postprocessing
export MANROFFOPT='-c'

# If your man output still shows weird characters like ^H or similar:
#
# - underlying man formatter doesn't respect MANROFFOPT='-c'
# - (more likely) page source being fed into man formatter is dirty or broken
#
# Modern Linux and MacOS man pages are usually clean from this kind of mess.
#
# But, to protect even from this stuff, we can pre-process man formatter output
# ourselves and strip any backspace characters and/or ANSI color sequences. There are
# two ways to do that:
#
# 1. sed -e 's/\x1B\[[0-9;]*m//g; s/.\x08//g'
# 2. col -bx
#
# `col` is modern utility that does exactly what we want: removes backspace and ANSI
# color sequences from input.
#
# In this case, our overengineered MANPAGER would look like one of following:
#
# export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat --language=man --plain'"
export MANPAGER="sh -c 'col -bx | bat --language=man --plain'"

# ... but we are brave, and have modern (<10 years old) system and don't care about
# ocasional broken man page
# export MANPAGER='bat --language=man --plain'
