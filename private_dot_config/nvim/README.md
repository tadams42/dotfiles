# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

⚠️ Don't edit files here! Edit dotfiles repo managed by `chezmoi` instead:

```sh
chezmoi cd
# usually in `~/.local/share/chezmoi`
nvim .
```

## System level requirements

```sh
sudo apt install luarocks wl-clipboard nodejs curl

sudo relget install --prefix=/usr/local \
    uv ripgrep fd fzf jq lazygit stylua eza yq tree-sitter-cli
```
