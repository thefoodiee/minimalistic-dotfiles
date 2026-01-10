require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "ts_ls", "emmet_language_server" }

-- read :h vim.lsp.config for changing options of lsp servers 
--

vim.lsp.config("emmet_language_server", {
  filetypes = {
    "html",
    "css",
    "scss",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
})

vim.lsp.config("ts_ls", {
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact"
  }
})

vim.lsp.enable(servers)
