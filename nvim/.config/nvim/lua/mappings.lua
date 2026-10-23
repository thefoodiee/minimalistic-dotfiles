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


-- Height
vim.keymap.set("n", "<A-K>", ":resize +2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-J>", ":resize -2<CR>", { noremap = true, silent = true })

-- Width
vim.keymap.set("n", "<A-L>", ":vertical resize +2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-H>", ":vertical resize -2<CR>", { noremap = true, silent = true })

map("n", "<leader>bc", ":%bd|e#|bd#<CR>", { desc = "Buffer close all except current" })

map("n", "<leader>p", ":put ='' | put<CR>", { desc = "Paste after one line break" })

map("n", "<leader>ru", function()
  local file = vim.fn.expand("%:p")
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
  vim.defer_fn(function()
    local chans = vim.api.nvim_list_chans()
    for _, chan in ipairs(chans) do
      if chan.mode == "terminal" and chan.argv and chan.argv[1] then
        vim.api.nvim_chan_send(chan.id, "run " .. vim.fn.shellescape(file) .. "\n")
        break
      end
    end
  end, 200)
end, { desc = "Run Current File" })
