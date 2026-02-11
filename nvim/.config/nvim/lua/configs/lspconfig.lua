require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "ts_ls", "emmet_ls", "tailwindcss" }
vim.lsp.enable(servers)

vim.lsp.config("emmet_ls", {
  filetypes = {
    "html",
    "css",
    "scss",
    "javascriptreact",
    "typescriptreact",
  },
})

vim.lsp.config("tailwindcss", {
  filetypes = {
    "html",
    "javascriptreact",
    "typescriptreact",
  },
})

-- read :h vim.lsp.config for changing options of lsp servers 
