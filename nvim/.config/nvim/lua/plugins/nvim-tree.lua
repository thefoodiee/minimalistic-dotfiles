return {
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      view = {
        width = 40,
        side = "right",
        preserve_window_proportions = true,
        float = {
          enable = true,
          open_win_config = {
            relative = "editor",
            border = "rounded",
            width = 40,
            height = 50,
            row = 1,
            col = vim.o.columns - 42,
          },
        },
      },
    },
  },
}
