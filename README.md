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
