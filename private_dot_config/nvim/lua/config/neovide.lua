if vim.g.neovide then
    local F_CASKAYDIA = "CaskaydiaCove Nerd Font Mono"
    local F_CODE_NEW_ROMAN = "CodeNewRoman Nerd Font Mono"
    local F_FIRACODE = "FiraCode Nerd Font Mono"
    local F_HACK = "Hack Nerd Font Mono"
    local F_INCONSOLATA = "Inconsolata Nerd Font Mono"
    local F_JETBRAINS = "JetBrainsMono Nerd Font Mono"

    local PRIMARY_FONT = F_HACK
    local PRIMARY_FONT_SIZE = 10.0

    vim.o.guifont = PRIMARY_FONT .. ":#e-subpixelantialias:h" .. tostring(PRIMARY_FONT_SIZE)

    vim.g.neovide_cursor_animation_length = 0
end
