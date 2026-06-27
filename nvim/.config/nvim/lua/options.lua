require "nvchad.options"

-- add yours here!

vim.opt.number = true
vim.opt.relativenumber = true
-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
--
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
-- vim.o.winbar = "%{%v:lua.require'dropbar'.get_dropbar_str()%}"
