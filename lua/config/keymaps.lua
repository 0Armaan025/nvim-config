-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

-- Open terminal in a horizontal split below
vim.keymap.set("n", "<C-\\>", function()
  require("lazyvim.util").terminal()
end, { desc = "Toggle terminal" })
