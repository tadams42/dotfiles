# dotfiles

[chezmoi](https://www.chezmoi.io/) managed dotfiles.

## Install on new machine

1. Install `chezmoi` binary into `/usr/local/bin/`:

   ```sh
   sh -c "$(curl -fsLS get.chezmoi.io)" -b /usr/local/bin
   ```

2, Install dotfiles from remote repository:

   ```sh
   chezmoi init --apply https://github.com/tadams42/dotfiles
   ```

## Update already managed machine

To pull the latest changes from your dotfiles repo and apply them, run:

```sh
chezmoi update
```

## Edit on main machine

```sh
chezmoi edit
```

or, use `VS Code` to edit `$HOME/.local/share/chezmoi/` and then:

```sh
chezmoi apply
```

## Notes

### Deploying on local machine vs. any other host

Deploying this `dotfiles` on my main machine (laptop) is differs substantially to from
deploying it on any other host.

Most of the `dotfiles` from this repo **IS NOT** copied to remote machines via `chezmoi
apply` or other `chezmoi` commands.

This is intentional and is controlled by:

- hardcoded `hostname` in `chezmoi.toml.tmpl` used to calculate value of `isLaptop` variable
- parts of `.chezmoiignore`

Why this behavior?

In my day to day work, there are many internal, remote `VM`s that I use on which I have
account shared with other people. Modifying `zsh` configuration for this shared account
is kind-of-sort-of OK. Modifying other configs often is not, so I don't do it.

Why hardcoded `hostname` to select wanted behavior?

Still haven't found better way to do it. 🫣

### `WezTerm` and it's `terminfo` on remote hosts

If using any terminal emulator besides `WezTerm`: everything will just work.

If using `WezTerm` and all the machines you are accessing (both, local and remote) have these `dotfiles` installed: everything will just work.

If using `WezTerm` on a machine that has these dotfiles installed to access (`ssh`) machine that doesn't: expect problems. This is the scenario:

1. `WezTerm` configured by these `dotfiles` sets `TERM=wezterm`
2. `ssh` passes `TERM` to remote machine when establishing connection
3. remote `zsh` line editor (`zle`) can't find `terminfo` named `wezterm` and defaults to something else
4. sequences that `zle` generates in this scenario are incorrectly interpreted by receiving `WezTerm`

To avoid all this either install these dotfiles on remote hosts or specify different, usually system-wide available, `terminfo` with `ssh`:

```sh
TERM=xterm-256color ssh …
```
