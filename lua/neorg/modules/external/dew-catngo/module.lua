local neorg = require "neorg.core"
local modules = neorg.modules

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
      args = 0,
      name = "dew-catngo.open",
    },
  }
end

module.config.public = {
  exclude_cat_prefix = ""
}

module.private = {
  cat_picker = function(callback)
    local categories = {}

    nq.all_categories(function(results)
      categories = vim.tbl_filter(function(cat)
        return not vim.startswith(cat, module.config.public.exclude_cat_prefix)
      end, results)
      table.sort(categories)

      require("neorg.core.modules").get_module("external.neorg-dew").telescope_picker("Categories", categories, {
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

      require("neorg.core.modules")
        .get_module("external.neorg-dew")
        .telescope_picker("Notes from " .. category.value, items, {
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
  if event.split_type[2] == "dew-catngo.open" then
    module.private.cat_picker(module.private.note_picker_from_cat)
  end
end

module.events.subscribed = {
  ["core.neorgcmd"] = {
    ["dew-catngo.open"] = true,
  },
}

return module
