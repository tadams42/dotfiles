# neovim plugin language providers

## Python language provider for plugins

⚠️ Don't install LSPs/formatters/... into Python venv for Neovim. `Mason` will take care
of that automatically.

⚠️ You probably don't need to in install `pynvim` either, and disable Python integration instead.

> Using `pynvim 0.6.0+` installed via `uv` or `pipx`, `Nvim` will automatically detect
> `pynvim` even if other `Python` virtual environments are activated
> ...
> For older `pynvim` (or older `Neovim`), where detection involved finding the first
> `Python` interpreter and checking if it could import `pynvim`, automatic detection
> would fail when another virtual environment is active. Upgrading to the latest
> `pynvim` is the recommended solution to this; but if that's not an option, then you
> can set the variable `g:python3_host_prog`

`vim.g.python3_host_prog` serves a specific purpose, but its role depends on what you
expect it to do versus what tools like `uv` or `mason.nvim` handle.

`vim.g.python3_host_prog` points Neovim to a Python interpreter that has `pynvim`
installed.

This is only used for:

- Legacy Remote Plugins written in Python that interact with Neovim via the RPC channel
  (`pynvim`).
- Evaluating `:python3` or `:py3` Vim script commands inside Neovim.

It does not:

- Control which Python virtual environment your LSP (`pyright`, `basedpyright`, `pylsp`)
  or linters/formatters (`ruff`, `black`) run against for your actual coding projects

With all that said, we can configure separate Python virtual environment for `Neovim`
if needed.

```sh
cd ~/.local/share
mkdir nvim_venv
uv init --name nvim_venv --package --lib --python 3.14 .
uv add pynvim
uv lock
uv sync --active
```

and in `~/.config/nvim/lua/config/options.lua` part of `LazyVim`:

```lua
vim.g.python3_host_prog = "/home/tomislav/.local/share/nvim_venv/.venv/bin/python"
```

Even this is overkill because of `uv`:

```sh
pipx install pynvim
# or:
uv tool install --upgrade pynvim
```

## Javascript (NodeJS) language provider for nvim plugins

TL;DR Just install `nodejs` and `tree-sitter-cli` and don't configure any special things in `Neovim` config.

⚠️ DON'T INSTALL `tree-sitter-cli` into isolated `NodeJS` environment! Use system package
instead.

`tree-sitter-cli` is Rust binary that is downloaded via NodeJS wrapper script. It may be
linked to who knows what version of `Glibc` and may not work.

⚠️ DON'T install `prettier` into isolated `NodeJS` environment! Let `meson` manage that.

If you are using old `vim` plugins, install `neovim` plugin host. Most of modern plugins
are written in `Lua`, so all this is probably completely unnecessary.

⚠️ If you don't use old plugins, don't install nor configure `neovim` package for `NodeJS`.

Also, in contrast to `Python` support in `neovim` that detects and properly uses
`pynvim` in it's own isolated environment, no matter what project env is activated;
`NodeJS` stuff doesn't work like that. Installing `npm install -g neovim ` in `fnm`
managed environment doesn't guarantee that `neovim` will use it as intended.

All that said, following snippets are kept for reference only and probably should not be
deployed:

```sh
fnm install 26.7.0
fnm default 26.7.0
corepack enable
npm install -g neovim
```

and in `~/.config/nvim/lua/config/options.lua` part of `LazyVim`:

```lua
vim.g.node_host_prog = "/home/tomislav/.local/share/fnm/aliases/default/bin/neovim-node-host"
```

While `Neovim` doesn't need `NodeJS` internally, `Mason` (`LazyVim`'s language tool manager) downloads language servers, linters, and formatters that are distributed via NPM.

You need `node` / `npm` present on your $PATH if you work with or install:

- `TypeScript` / `JavaScript` LSPs: `vtsls`, `ts_ls`, `eslint-lsp`
- Tailwind CSS: `tailwindcss-language-server`
- JSON / HTML / CSS: `vscode-langservers` (managed by `Mason`, packaged via `NPM`)
- Prettier: `prettier` (if installed via Mason/NPM instead of system/Cargo alternatives)
- ...

If you do zero `Node/JS` work You can remove `fnm` completely. If `Mason` ever needs
`node` for a tool like CSS/JSON LSPs, you can just install the system nodejs package via
your Linux package manager (e.g., apt, pacman, or dnf).

If you occasionally need Mason Node-based LSPs keep node on your system path (either
system Node or fnm). Mason handles downloading and running the LSPs inside
`~/.local/share/nvim/mason/` automatically—you don't need to manually run `npm install
-g` for them.
