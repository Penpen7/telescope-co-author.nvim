local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local conf = require("telescope.config").values
local lookup_keys = {
  display = 1,
  ordinal = 1,
  value = 1,
}

local handle_entry_index = function(opts, t, k)
  local override = ((opts or {}).entry_index or {})[k]
  if not override then
    return
  end

  local val, save = override(t, opts)
  if save then
    rawset(t, k, val)
  end
  return val
end


local entry_maker = function(opts)
  local is_inserted = {}
  local mt_string_entry = {
    __index = function(t, k)
      local override = handle_entry_index(opts, t, k)
      if override then
        return override
      end

      return rawget(t, rawget(lookup_keys, k))
    end,
  }

  return function(line)
    local trimmed_line = line:sub(2, -2)
    if is_inserted[trimmed_line] then
      return nil
    end

    is_inserted[trimmed_line] = true
    return setmetatable({
      trimmed_line,
    }, mt_string_entry)
  end
end

local action = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local selections = picker:get_multi_selection()

  actions.close(prompt_bufnr)

  if #selections == 0 then
    local selection = action_state.get_selected_entry()
    selections = { { selection.value } }
  end

  for _, selection in pairs(selections) do
    local put_line = "Co-authored-by: " .. selection[1]
    vim.api.nvim_put({ put_line }, "l", false, true)
  end
end

local co_author = function(opts)
  opts = opts or {}
  local cmd = { "git", "-c", "log.showSignature=false", "log", "--format='%aN <%aE>'" }
  opts.entry_maker = entry_maker(opts)
  pickers.new(opts, {
    prompt_title = "co-authors",
    finder = finders.new_oneshot_job(cmd, opts),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(_, _)
      actions.select_default:replace(action)
      return true
    end,
  }):find()
end

return {
  co_author = co_author,
}
