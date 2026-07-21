-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
-- init.lua: minimal LSP setup (Neovim 0.11+)
vim.lsp.enable("lua_ls") -- enable lua-language-server
vim.lsp.enable("ts_ls") -- enable typescript-language-server

-- Override or extend a config with vim.lsp.config (replaces the old setup{})
vim.lsp.config("lua_ls", {
  settings = { Lua = { diagnostics = { globals = { "vim" } } } },
})

vim.opt.number = true -- line numbers
vim.opt.relativenumber = true -- relative line numbers
vim.opt.tabstop = 2 -- tab width
vim.opt.shiftwidth = 2 -- indent width
vim.opt.expandtab = true -- spaces instead of tabs
vim.opt.signcolumn = "yes" -- always show sign column
vim.opt.clipboard = "unnamedplus" -- use system clipboard
vim.opt.ignorecase = true -- case-insensitive search
vim.opt.smartcase = true -- unless uppercase is used

-- Leader key
vim.g.mapleader = " "

-- Keymaps
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>")
