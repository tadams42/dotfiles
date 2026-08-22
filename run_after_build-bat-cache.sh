#!/bin/sh
if command -v bat >/dev/null 2>&1; then
    # order matters: error messages still print to your terminal while normal output is
    # silenced.
    bat cache --build 2>&1 >/dev/null
fi
