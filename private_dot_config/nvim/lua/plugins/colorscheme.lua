return {
  { "tanvirtin/monokai.nvim",    lazy = true, name = "monokai" },

  { "cpea2506/one_monokai.nvim", lazy = true, name = "one_monokai" },

  -- `style` picks a palette file: storm | moon | night | day. Not the scheme name.
  { "folke/tokyonight.nvim",     lazy = true, name = "tokyonight", opts = { style = "night" } },

  {
    -- `:CatppuccinCompile` then restart or `rm -rf ~/.cache/nvim/catppuccin`
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      -- set either flavour or background, not both
      -- flavour = "mocha",
      background = { light = "latte", dark = "mocha" },
      -- transparent_background = true,
      -- float = { transparent = false, solid = false },
      -- term_colors = true,
      -- no_italic = false,
      -- dim_inactive = { enabled = false, shade = "dark", percentage = 0.15 },
      -- styles = {
      --   comments = { "italic" },
      --   conditionals = { "italic" },
      --   keywords = {},
      -- },
    },
  },

  {
    "ntk148v/habamax.nvim",
    lazy = true,
    name = "habamax",
    dependencies = { "rktjmp/lush.nvim" },
  },

  -- Configure LazyVim to load scheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
