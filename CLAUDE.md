# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common commands

```sh
# Apply dotfiles to the current machine
chezmoi apply

# Pull latest from remote and apply
chezmoi update

# Preview what would change before applying
chezmoi diff

# Edit a managed file (opens in $EDITOR, then apply manually)
chezmoi edit ~/.config/zsh/.zshrc

# Re-clone external dependencies (antidote plugin manager)
chezmoi apply --refresh-externals
```

## Architecture

This is a [chezmoi](https://www.chezmoi.io/) dotfiles repository targeting ZSH configuration. It deploys to two distinct environments controlled by template variables.

### Template variables

Defined in `.chezmoi.toml.tmpl` and available in all `*.tmpl` files:

| Variable | Meaning |
|---|---|
| `.isMainLaptop` | `true` only on hostname `angie-ubuntu` |
| `.isRemote` | `true` on any machine that is not the main laptop |
| `.isRoot` | `true` when running as UID 0 |

Most `cli_utilities_configuration/*.sh.tmpl` files gate their entire content behind `{{- if and (not .isRoot) .isMainLaptop }}` — those tools are only configured on the main laptop.

### Deployment scope: main laptop vs. remote

`.chezmoiignore` uses a **whitelist strategy for remote machines**: when `.isRemote` is true, it ignores everything (`*`) then explicitly un-ignores only what remote machines need. This means adding a new file that should deploy to remote machines requires adding an `!path` entry to the ignore file.

Remote machines receive: `.zshenv`, the full `~/.config/zsh/` directory (all ZSH config), `starship.toml`, `ripgrep.rc`, and empty `.keep` files to create the required `~/.local/share/zsh/` and `~/.cache/zsh/` directory structure.

### ZSH initialization order

`~/.zshenv` (via symlink → `.config/zsh/.zshenv`) sets `ZDOTDIR=$HOME/.config/zsh`, redirecting all subsequent ZSH startup file lookups into `~/.config/zsh/`. The load order is:

1. `.zshenv` — XDG vars, PATH, ZSH options, `ZDOTDIR`; sourced for all shells including non-interactive
2. `.zprofile` — login shells only; currently a stub
3. `.zshrc` — interactive shells; sources everything below in order:
   - `shell_configuration/01_colors.zsh` — `LS_COLORS` via `dircolors` or `vivid`
   - `shell_configuration/02_antidote.zsh` — plugin manager + plugins from `dot_zsh_plugins.txt`
   - `shell_configuration/03_history.zsh` — history options + `fzf` key bindings
   - `shell_configuration/04_prompt.zsh` — starship prompt
   - `cli_utilities_configuration/*.sh` — one file per tool (bat, eza, fnm, ripgrep, etc.)
   - `shell_configuration/05_completion.zsh` — `compinit` and all `zstyle` completion config; must run last

### Antidote (plugin manager)

Antidote is managed as a `git-repo` external in `.chezmoiexternal.toml` — chezmoi clones it to `~/.config/zsh/.antidote/`. Plugins are listed in `dot_zsh_plugins.txt`.

### Guard pattern for missing utilities

Every file that calls an external tool uses an existence guard before executing it, so a missing tool produces a warning rather than a broken shell:

```zsh
# For commands:
(( $+commands[tool] )) && do_thing || echo "WARNING: tool not found, ..."

# For sourced files:
[[ -f /path/to/file ]] || { echo "WARNING: ..."; return }
```

Files that only set env vars or define aliases (no `eval`/`source` of external output) are safe without guards — missing aliases simply won't work when invoked, which is acceptable.
