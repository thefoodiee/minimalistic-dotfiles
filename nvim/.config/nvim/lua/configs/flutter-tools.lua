require("flutter-tools").setup({
  decorations = {
    statusline = {
      app_version = true,
      device = true,
    },
  },

  widget_guides = {
    enabled = true,
  },

  closing_tags = {
    enabled = true,
    prefix = "//",
    highlight = "Comment",
  },

  dev_tools = {
    autostart = true,
    auto_open_browser = true,
  },

  lsp = {
    color = {
      enabled = true,
      virtual_text = true,
    },
    settings = {
      showTodos = true,
      completeFunctionCalls = true,
    },
  },
})
