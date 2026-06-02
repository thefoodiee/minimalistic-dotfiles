return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "javascript",
        "javascriptreact",
        "typescriptreact",
        "python",
      },
    },
    indent = { enable = true },
  },

  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
    config = function()
      -- Create an autocommand group to avoid duplicate registrations
      local group = vim.api.nvim_create_augroup("LazyGitNvimTreeRefresh", { clear = true })

      vim.api.nvim_create_autocmd("BufLeave", {
        group = group,
        pattern = "*",
        callback = function()
          -- Check if the buffer we are leaving belongs to lazygit
          if vim.bo.filetype == "lazygit" then
            -- Sync disk modifications with open buffers
            if vim.o.buftype ~= "nofile" then
              vim.cmd "checktime"
            end

            -- Safely look for nvim-tree API and trigger a reload
            local status_ok, nvim_tree_api = pcall(require, "nvim-tree.api")
            if status_ok then
              nvim_tree_api.tree.reload()
            end
          end
        end,
      })
    end,
  },
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- optional for vim.ui.select
    },
    config = true,
  },
}
