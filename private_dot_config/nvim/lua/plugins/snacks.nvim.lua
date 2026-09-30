return {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
        explorer = {
            auto_close = false,
        },
        picker = {
            sources = {
                explorer = {
                    layout = { layout = { position = "right" } }
                }
            }
        }
    }
}
