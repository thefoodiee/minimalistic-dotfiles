require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd

autocmd("BufWritePost", {
  desc = "Restart basedpyright LSP on save if active",
  pattern = "*.py", 
  callback = function()
    local clients = vim.lsp.get_clients({ name = "basedpyright" })
    
    if #clients > 0 then
      vim.schedule(function()
        vim.cmd("lsp restart basedpyright")
      end)
    end
  end,
})
