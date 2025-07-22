local neorg = require "neorg.core"
local modules = neorg.modules
local neorg_dew = require("neorg.core.modules").get_module "external.neorg-dew"

local nq = require "neorg_query.api"

local module = modules.create "external.dew-catngo"

module.setup = function()
  return {
    requires = {
      "core.neorgcmd",
    },
  }
end

module.load = function()
  module.required["core.neorgcmd"].add_commands_from_table {
    dew_catngo = {
      args = 1,
      subcommands = {
        excluded = { args = 0, name = "dew-catngo.excluded" },
        full = { args = 0, name = "dew-catngo.full" },
      },
    },
  }
end

module.config.public = {
  exclude_cat_prefix = "",
}

module.private = {
  cat_picker = function(callback, exclusion)
    local categories = {}

    nq.all_categories(function(results)
      if exclusion then
        categories = vim.tbl_filter(function(cat)
          return not vim.startswith(cat, module.config.public.exclude_cat_prefix)
        end, results)
      else
        categories = results
      end

      table.sort(categories)

      neorg_dew.telescope_picker("Categories", categories, {
        entry_value = function(entry)
          return entry
        end,
        entry_display = function(entry)
          return entry
        end,
        entry_ordinal = function(entry)
          return entry
        end,
      }, function(map, action_state, actions)
        map("i", "<CR>", function(bufnr)
          local selection = action_state.get_selected_entry()
          actions.close(bufnr)
          callback(selection)
        end)
        return true
      end)
    end)
  end,

  note_picker_from_cat = function(category)
    nq.category_query({ category.value }, function(results)
      local items = {}

      for _, note in ipairs(results) do
        local title = note.title
        local path = note.path

        table.insert(items, {
          title = title,
          path = path,
        })
      end

      neorg_dew.telescope_picker("Notes from " .. category.value, items, {
        entry_value = function(entry)
          return entry.path
        end,
        entry_display = function(entry)
          return entry.title
        end,
        entry_ordinal = function(entry)
          return entry.title
        end,
      }, function(map, action_state, actions)
        map("i", "<CR>", function(bufnr)
          local selection = action_state.get_selected_entry()
          actions.close(bufnr)
          vim.cmd("edit " .. vim.fn.fnameescape(selection.value))
        end)
        return true
      end)
    end)
  end,
}

module.on_event = function(event)
  if event.split_type[2] == "dew-catngo.excluded" then
    module.private.cat_picker(module.private.note_picker_from_cat, true)
    vim.print "ex"
  elseif event.split_type[2] == "dew-catngo.full" then
    module.private.cat_picker(module.private.note_picker_from_cat)
    vim.print "full"
  end
end

module.events.subscribed = {
  ["core.neorgcmd"] = {
    ["dew-catngo.excluded"] = true,
    ["dew-catngo.full"] = true,
  },
}

return module
