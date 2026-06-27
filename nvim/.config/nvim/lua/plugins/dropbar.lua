return {
  {
    "Bekaboo/dropbar.nvim",
    event = { "BufReadPost", "BufNewFile" },

    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },

    opts = {},

    config = function(_, opts)
      require("dropbar").setup(opts)

      local api = require("dropbar.api")

      vim.keymap.set("n", "<leader>;", api.pick)
      vim.keymap.set("n", "[;", api.goto_context_start)
      vim.keymap.set("n", "];", api.select_next_context)
    end,
  },
}
