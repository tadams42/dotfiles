-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Remove global keymaps that open integrated terminal
-- Note that `:terminal` still stays - it is compiled into nvim itself
for _, lhs in ipairs({ "<leader>ft", "<leader>fT" }) do
    pcall(vim.keymap.del, "n", lhs)
end
for _, lhs in ipairs({ "<C-/>", "<C-_>" }) do
    pcall(vim.keymap.del, { "n", "t" }, lhs)
end

-- Remove keymaps that open `lazygit` inside of nvim
-- pcall(vim.keymap.del, "n", "<leader>gg")
-- pcall(vim.keymap.del, "n", "<leader>gG")
