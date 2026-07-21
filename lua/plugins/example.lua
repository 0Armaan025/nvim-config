-- lua/plugins/user.lua
--
-- This file IS loaded by lazy.nvim (every spec file under "plugins" is
-- loaded automatically), so everything returned below is active.
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enable LazyVim plugins
-- * override the configuration of LazyVim plugins

return {

  -- add catppuccin
  { "catppuccin/nvim", opts = { flavour = "mocha" } },

  -- Configure LazyVim to load catppuccin (used as the fallback default;
  -- the theme-picker below overrides this with your saved choice, if any)
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
    init = function()
      -- apply the saved theme (if any) once everything else has loaded
      vim.api.nvim_create_autocmd("VeryLazy", {
        once = true,
        callback = function()
          require("config.theme-picker").apply_saved()
        end,
      })
    end,
  },

  -- change trouble config
  {
    "folke/trouble.nvim",
    -- opts will be merged with the parent spec
    opts = { use_diagnostic_signs = true },
  },

  -- override nvim-cmp and add cmp-emoji
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },

  -- change some telescope options and add a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- stylua: ignore
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
      {
        "<leader>uT",
        function()
          require("config.theme-picker").pick()
        end,
        desc = "Pick Theme (persists)",
      },
      {
        "<leader>uc",
        function()
          require("config.theme-picker").cycle()
        end,
        desc = "Cycle Theme",
      },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },

  -- extra colorschemes to choose from with the theme picker (<leader>uT)
  -- these are lazy-loaded automatically the moment you call :colorscheme
  { "folke/tokyonight.nvim", lazy = true },
  { "ellisonleao/gruvbox.nvim", lazy = true },
  { "rebelot/kanagawa.nvim", lazy = true },
  { "rose-pine/neovim", name = "rose-pine", lazy = true },
  { "EdenEast/nightfox.nvim", lazy = true },
  { "navarasu/onedark.nvim", lazy = true },
  { "Mofiqul/dracula.nvim", lazy = true },
  { "sainnhe/everforest", lazy = true },
  { "shaunsingh/nord.nvim", lazy = true },
  { "projekt0n/github-nvim-theme", lazy = true },
  { "sainnhe/sonokai", lazy = true },
  { "sainnhe/edge", lazy = true },
  { "sainnhe/gruvbox-material", lazy = true },
  { "marko-cerovac/material.nvim", lazy = true },
  { "Mofiqul/vscode.nvim", lazy = true },
  { "olimorris/onedarkpro.nvim", lazy = true },
  { "rmehri01/onenord.nvim", lazy = true },
  { "AlexvZyl/nordic.nvim", lazy = true },
  { "bluz71/vim-nightfly-colors", lazy = true },
  { "bluz71/vim-moonfly-colors", lazy = true },
  { "tanvirtin/monokai.nvim", lazy = true },
  { "savq/melange-nvim", lazy = true },
  { "maxmx03/solarized.nvim", lazy = true },
  { "NLKNguyen/papercolor-theme", lazy = true },
  { "srcery-colors/srcery-vim", lazy = true },
  { "rafamadriz/neon", lazy = true },
  { "loctvl842/monokai-pro.nvim", lazy = true },
  { "Shatur/neovim-ayu", lazy = true },
  { "wtfox/jellybeans.nvim", lazy = true },
  { "junegunn/seoul256.vim", lazy = true },
  { "kepano/flexoki-neovim", name = "flexoki", lazy = true },

  -- register a :Themes command as another way to open the picker
  {
    "nvim-telescope/telescope.nvim",
    init = function()
      vim.api.nvim_create_user_command("Themes", function()
        require("config.theme-picker").pick()
      end, { desc = "Open theme picker" })
    end,
  },

  -- add pyright to lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        pyright = {},
      },
    },
  },

  -- NOTE: the lazyvim.plugins.extras.* imports (typescript, json, mini-starter)
  -- have been moved to lua/config/lazy.lua's `spec` list, after
  -- `lazyvim.plugins` and before `{ import = "plugins" }`, to satisfy
  -- LazyVim's import-order check (vim.g.lazyvim_check_order).

  -- add more treesitter parsers (merged into the defaults, not overwriting them)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      })
    end,
  },

  -- customize lualine
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, {
        function()
          return "😄"
        end,
      })
    end,
  },

  -- ============================================================
  -- Newly added plugins
  -- ============================================================

  -- oil.nvim: edit your filesystem like a normal Neovim buffer
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
      },
    },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
  },

  -- gitsigns.nvim: git decorations in the sign column + hunk actions
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "┆" },
      },
    },
  },

  -- conform.nvim: formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        desc = "Format buffer",
      },
    },
    opts = {
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        sh = { "shfmt" },
      },
    },
  },

  -- nvim-lint: async linting
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      linters_by_ft = {
        python = { "flake8" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        sh = { "shellcheck" },
      },
    },
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = opts.linters_by_ft

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },

  -- todo-comments.nvim: highlight & search TODO/FIXME/HACK/NOTE comments
  -- (ships with LazyVim by default — this just customizes it)
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    opts = {
      signs = true,
      keywords = {
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
      },
    },
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous todo comment",
      },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo (Telescope)" },
    },
  },

  -- flash.nvim: jump to any word/char on screen in a couple keystrokes
  -- (ships with LazyVim by default — this just customizes it)
  {
    "folke/flash.nvim",
    opts = {
      modes = {
        char = {
          jump_labels = true,
        },
      },
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
    },
  },

  -- noice.nvim + nvim-notify: fancy cmdline, messages, and popup notifications
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
    keys = {
      {
        "<S-Enter>",
        function()
          require("noice").redirect(vim.fn.getcmdline())
        end,
        mode = "c",
        desc = "Redirect Cmdline",
      },
      {
        "<leader>snl",
        function()
          require("noice").cmd("last")
        end,
        desc = "Noice Last Message",
      },
      {
        "<leader>snh",
        function()
          require("noice").cmd("history")
        end,
        desc = "Noice History",
      },
      {
        "<leader>sna",
        function()
          require("noice").cmd("all")
        end,
        desc = "Noice All",
      },
      {
        "<leader>snd",
        function()
          require("noice").cmd("dismiss")
        end,
        desc = "Dismiss All",
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      render = "wrapped-compact",
      stages = "fade_in_slide_out",
    },
  },

  -- bufferline.nvim: tabs across the top for open buffers
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle pin" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete non-pinned buffers" },
    },
    opts = {
      options = {
        mode = "buffers",
        separator_style = "thin",
        show_buffer_close_icons = true,
        show_close_icon = false,
        diagnostics = "nvim_lsp",
      },
    },
  },

  -- vim-illuminate: highlight other occurrences of the word under the cursor
  {
    "RRethy/vim-illuminate",
    event = "BufReadPost",
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
    keys = {
      {
        "]]",
        function()
          require("illuminate").goto_next_reference(false)
        end,
        desc = "Next reference",
      },
      {
        "[[",
        function()
          require("illuminate").goto_prev_reference(false)
        end,
        desc = "Prev reference",
      },
    },
  },

  -- nvim-colorizer: show hex/rgb/css colors inline
  {
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      "*",
      css = { rgb_fn = true },
      html = { names = false },
    },
    config = function(_, opts)
      require("colorizer").setup(opts)
    end,
  },

  -- add any mason tools you want installed
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
        "black",
        "prettierd",
        "eslint_d",
      },
    },
  },
}
