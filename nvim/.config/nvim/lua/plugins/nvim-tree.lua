return {
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      view = {
        width = 35,
        side = "right",
        preserve_window_proportions = true,
        float = {
          enable = false,
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
      filters = {
        dotfiles = false,
        git_ignored = false,
      },
    },
  },
}
