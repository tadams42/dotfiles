#!/usr/bin/zsh

# Make all python calls cache into ~/.cache
export PYTHONPYCACHEPREFIX=${XDG_CACHE_HOME}/pyc

export PYTHONBREAKPOINT="IPython.embed"
# export PYTHONPROFILEIMPORTTIME=1
# export PYTHONMALLOCSTATS=1

export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"

alias py.spec='py.test -p no:sugar --spec'

alias py.envclean='fd -H -I -t d --prune "^(__pycache__|\.pytest_cache|\.venv|\.tox|dist|_build)$|\.egg-info$" -X rm -rf; fd -H -I -t f -e pyc -X rm'

# paddlex and paddlepaddle download their data into ~/.paddlex unless this variable is set
export PADDLE_PDX_CACHE_HOME="$HOME/.cache/paddlex"
