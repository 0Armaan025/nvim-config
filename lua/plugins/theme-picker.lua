-- lua/config/theme-picker.lua
--
-- A small persistent theme picker. Pick a colorscheme with a live preview,
-- and it's remembered the next time you open Neovim — no editing config
-- files required.

local M = {}

local data_file = vim.fn.stdpath("data") .. "/theme.txt"

--- Save the chosen colorscheme name to disk.
function M.save(name)
  local f = io.open(data_file, "w")
  if f then
    f:write(name)
    f:close()
  end
end

--- Read the last-saved colorscheme name, or nil if none saved yet.
function M.load()
  local f = io.open(data_file, "r")
  if not f then
    return nil
  end
  local name = f:read("*l")
  f:close()
  if name == "" then
    return nil
  end
  return name
end

--- Apply the saved colorscheme, if any. Safe to call even if the saved
--- scheme's plugin somehow isn't installed (falls back silently).
function M.apply_saved()
  local name = M.load()
  if not name then
    return
  end
  local ok = pcall(vim.cmd.colorscheme, name)
  if not ok then
    vim.notify("theme-picker: couldn't load saved colorscheme '" .. name .. "'", vim.log.levels.WARN)
  end
end

--- Open a Telescope picker with live preview. Confirming applies the theme
--- immediately and saves it for future sessions.
function M.pick()
  local ok_telescope, builtin = pcall(require, "telescope.builtin")
  if not ok_telescope then
    vim.notify("theme-picker: telescope.nvim is required", vim.log.levels.ERROR)
    return
  end

  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local dropdown = require("telescope.themes").get_dropdown({
    winblend = 10,
    width = 0.4,
    previewer = false, -- dropdown is a compact list; live preview still applies the theme as you move
    prompt_title = "Pick a Theme",
  })

  builtin.colorscheme(vim.tbl_deep_extend("force", dropdown, {
    enable_preview = true,
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if selection then
          vim.cmd.colorscheme(selection.value)
          M.save(selection.value)
          vim.notify("Theme set to " .. selection.value, vim.log.levels.INFO)
        end
      end)
      return true
    end,
  }))
end

--- Cycle to the next installed colorscheme without opening the picker.
--- Handy for quickly flipping through options.
function M.cycle()
  local all = vim.fn.getcompletion("", "color")
  if #all == 0 then
    return
  end
  local current = vim.g.colors_name or ""
  local idx = 1
  for i, name in ipairs(all) do
    if name == current then
      idx = i
      break
    end
  end
  local next_name = all[(idx % #all) + 1]
  vim.cmd.colorscheme(next_name)
  M.save(next_name)
  vim.notify("Theme set to " .. next_name, vim.log.levels.INFO)
end

return M
