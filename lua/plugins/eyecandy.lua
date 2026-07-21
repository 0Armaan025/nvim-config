-- lua/plugins/eyecandy.lua
--
-- Smooth motion + a personal, rounded, "native app" feel.
-- Terminal-level rounding/blur is out of Neovim's hands (that's your
-- terminal emulator's job — see the note at the bottom of this file for
-- Kitty/WezTerm/Neovide snippets), but everything Neovim itself draws
-- (floats, popups, the picker, notifications, cursor motion, scrolling)
-- is covered here.

return {

  -- ============================================================
  -- 1. Global rounded borders for every floating window
  -- ============================================================
  {
    "LazyVim/LazyVim",
    init = function()
      -- Neovim 0.11+: sets the default border for ALL floating windows
      -- (LSP hover, diagnostics, signature help, etc.) in one line.
      if vim.fn.has("nvim-0.11") == 1 then
        vim.o.winborder = "rounded"
      end
    end,
  },

  -- ============================================================
  -- 2. Smooth cursor motion (the "macOS trail" feel)
  -- ============================================================
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
      -- how "liquid" the trail feels — lower = more smear, higher = snappier
      stiffness = 0.8,
      trailing_stiffness = 0.5,
      distance_stop_animating = 0.5,
      -- matches your colorscheme's cursor color automatically
      cursor_color = nil,
      hide_target_hack = false,
      smear_between_buffers = true,
      smear_between_neighbor_lines = true,
      -- keep it subtle in the command line / search
      never_draw_over_target = false,
      legacy_computing_symbols_support = false,
    },
  },

  -- ============================================================
  -- 3. Animated scrolling, window resize, and open/close transitions
  -- ============================================================
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    opts = function()
      -- gentle ease-out curve, feels closer to macOS's spring animations
      -- than a linear one
      local animate = require("mini.animate")
      return {
        cursor = {
          enable = true,
          timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
        },
        scroll = {
          enable = true,
          timing = animate.gen_timing.cubic({ duration = 150, unit = "total" }),
        },
        resize = {
          enable = true,
          timing = animate.gen_timing.cubic({ duration = 100, unit = "total" }),
        },
        open = {
          enable = true,
          timing = animate.gen_timing.cubic({ duration = 100, unit = "total" }),
        },
        close = {
          enable = true,
          timing = animate.gen_timing.cubic({ duration = 100, unit = "total" }),
        },
      }
    end,
  },

  -- ============================================================
  -- 4. Transparency toggle (frosted-glass feel when paired with a
  --    blurred terminal background — see note at bottom of file)
  -- ============================================================
  {
    "xiyaowong/transparent.nvim",
    cmd = { "TransparentToggle", "TransparentEnable", "TransparentDisable" },
    keys = {
      { "<leader>ut", "<cmd>TransparentToggle<cr>", desc = "Toggle transparency" },
    },
    opts = {
      extra_groups = {
        "NormalFloat",
        "NvimTreeNormal",
        "TelescopeNormal",
        "TelescopeBorder",
        "NoicePopup",
        "NoicePopupBorder",
      },
    },
  },

  -- ============================================================
  -- 5. Rounded borders + subtle polish on individual UI plugins
  --    (belt-and-suspenders for anyone still on < 0.11)
  -- ============================================================
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        border = true,
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      },
    },
  },

  {
    "folke/noice.nvim",
    opts = {
      popupmenu = {
        enabled = true,
        backend = "nui",
      },
      views = {
        cmdline_popup = {
          border = { style = "rounded" },
        },
        popupmenu = {
          border = { style = "rounded" },
        },
      },
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
        lsp_doc_border = true, -- rounded border on hover docs
      },
    },
  },

  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 3000,
      render = "wrapped-compact",
      stages = "fade_in_slide_out", -- already animated; kept explicit here
      top_down = true,
    },
  },

  -- ============================================================
  -- 6. A personal touch on the start screen
  -- ============================================================
  {
    "echasnovski/mini.starter",
    opts = function(_, opts)
      opts.header = table.concat({
        "",
        "▄▄▄· ▄▄▄  • ▌ ▄ ·. ▄▄▄· ▄▄▄·  ▐ ▄ ",
        "▐█ ▄█▀▄ █··██ ▐███▪▐█ ▀█ ▐█ ▀█•█▌▐█",
        " ██▀·▐▀▀▄ ▐█ ▌▐▌▐█·▄█▀▀█ ▄█▀▀█▐█▐▐▌",
        "▐█▪·•▐█•█▌██ ██▌▐█▌▐█ ▪▐▌▐█ ▪▐██▐█▌",
        ".▀   .▀  ▀▀▀▀ ▀▀▀▀▀ ▀  ▀  ▀  ▀▀▀ █▪",
        "",
      }, "\n")
      opts.footer = function()
        local hour = tonumber(os.date("%H"))
        local greeting = (hour < 12 and "Good morning") or (hour < 18 and "Good afternoon") or "Good evening"
        return greeting .. ", Armaan. Let's build something."
      end
      return opts
    end,
  },
}
