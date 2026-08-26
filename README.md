# dotfiles

[chezmoi](https://www.chezmoi.io/) managed dotfiles.

## Install on new machine

1. Install `chezmoi` into `~/bin/chezmoi`:

   ```sh
   sh -c "$(curl -fsLS get.chezmoi.io)"
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

## Note on remote machines

The whole repo is deployed only on one host - my laptop. And this is determined by
hardcoded `hostname`.

On any other host ("remote"), only smaller subset of files are deployed via `chezmoi apply`.

This is intentional. On some VMs where I deploy this, I work with other people and we
all share single user account on these machines. Modifying `zsh` on these hosts is
kind-of-sort-of OK. Modifying config for most of other tools is not. So I don't do it.

Still haven't found better way to enforce this behavior, besides hardcoded `hostname`.
