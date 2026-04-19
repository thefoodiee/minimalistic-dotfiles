require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")


-- Select All (Ctrl+a)
vim.keymap.set({'n', 'i'}, '<C-a>', '<Esc>ggVG', { desc = 'Select all text' })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
--
vim.keymap.set("n", "<leader>fr", ":FlutterRun<CR>")
vim.keymap.set("n", "<leader>fq", ":FlutterQuit<CR>")
vim.keymap.set("n", "<leader>fR", ":FlutterRestart<CR>")
vim.keymap.set("n", "<leader>fd", ":FlutterDevices<CR>")
vim.keymap.set("n", "<leader>fe", ":FlutterEmulators<CR>")
vim.keymap.set("n", "<leader>fo", ":FlutterOutlineToggle<CR>")
vim.keymap.set("n", "<leader>fc", function()
  require("telescope").extensions.flutter.commands()
end)


-- Increase/Decrease Split Height
vim.keymap.set('n', '<A-k>', ':resize +2<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<A-j>', ':resize -2<CR>', { noremap = true, silent = true })

-- Increase/Decrease Split Width
vim.keymap.set('n', '<A-l>', ':vertical resize +2<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<A-h>', ':vertical resize -2<CR>', { noremap = true, silent = true })
