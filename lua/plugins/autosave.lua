return {
  "okuuva/auto-save.nvim",
  event = { "InsertLeave", "TextChanged" },
  opts = {
    enabled = true,
    debounce_delay = 2000, -- in ms
    condition = function(buf)
      local ft = vim.fn.getbufvar(buf, "&filetype")
      return vim.fn.getbufvar(buf, "&modifiable") == 1
        and vim.fn.getbufvar(buf, "&buftype") == ""
        and not vim.tbl_contains({ "TelescopePrompt", "help", "terminal" }, ft)
    end,
    execution_message = {
      message = function()
        return "💾 Saved at " .. vim.fn.strftime("%H:%M:%S")
      end,
      dim = 0.18,
      cleaning_interval = debounce_delay, -- auto-hide message
    },
    trigger_events = {
      defer_save = { "InsertLeave", "TextChanged" },
      immediate_save = { "BufLeave", "FocusLost" },
      cancel_deferred_save = { "InsertEnter" },
    },
    write_all_buffers = false,
  },
}
