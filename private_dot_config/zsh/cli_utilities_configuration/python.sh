#!/usr/bin/zsh

# Make all python calls cache into ~/.cache
export PYTHONPYCACHEPREFIX=${XDG_CACHE_HOME}/pyc

export PYTHONBREAKPOINT="IPython.embed"
# export PYTHONPROFILEIMPORTTIME=1
# export PYTHONMALLOCSTATS=1

export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"

alias py.spec='py.test -p no:sugar --spec'

alias tar_py='tar --exclude="*/__pycache__" --exclude="*.pyc" --exclude="*/.venv" --exclude="*/.tox" --exclude="*/.vagrant"'
alias tar_py_src='tar --verbose --create --exclude="*/_build" --exclude="*/build" --exclude="*.pyc" --exclude="*/__pycache__" --exclude="*/.venv" --exclude="*/.external_pip_packages" --exclude="*/log/*" --exclude="*/.cache" --exclude="*/.vagrant" --exclude="*/.benchmarks" --exclude="*/dist"'

alias py.clean="find ./ \( -type d -and -name __pycache__ -or -name '.pytest_cache' \) -or \( -type f -name '*.pyc' \) | xargs rm -rf"
alias py.distclean="find ./ \( -type d -wholename '*/src/*.egg-info' -or -name dist -or -wholename '*/docs/_build' \) | xargs rm -rf; py.clean"
alias py_envclean="find ./ \( -type d -name .venv -or -name .tox \) | xargs rm -rf; py.distclean"

# alias py.cloc='cloc --exclude-dir=_build,.venv,.venv2,.venv3,.tox,.vscode,log,build,dist .'
