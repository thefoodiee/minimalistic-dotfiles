require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "ts_ls", "emmet_ls", "tailwindcss", "marksman", "basedpyright", "qmlls" }
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

vim.lsp.config("basedpyright", {
  analysis = {
    typeCheckingMode = "basic",
  }
})

vim.lsp.config("qmlls", {
  cmd = {"qmlls6"},
  filetypes = {
    "qml"
  }
})

-- read :h vim.lsp.config for changing options of lsp servers 
