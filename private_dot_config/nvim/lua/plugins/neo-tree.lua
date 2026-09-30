if true then return {} end

return {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons', -- Optional, but highly recommended for icons
        'MunifTanjim/nui.nvim',        -- Required by neo-tree
    },
    lazy = false,                      -- neo-tree will lazily load itself
    ---@module 'neo-tree'
    ---@type neotree.Config
    opts = {
        close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
        enable_git_status = false,
        enable_diagnostics = true,
        open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' }, -- Don't replace these buffer types
        window = {
            position = 'right',                                            -- Position the tree on the left (default)
            width = 60,                                                    -- Set a comfortable width
            mapping_options = {
                noremap = true,
                nowait = true,
            },
        },
        file_size = {
            enabled = false,
        },

    },
    keys = {
        {
            "n",
            '<leader>e',
            "<Cmd>Neotree<CR>",
            desc = 'Toggle Neo-tree Explorer',
        },
    },
}
