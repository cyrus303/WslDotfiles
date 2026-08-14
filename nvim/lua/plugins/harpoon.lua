-- Snacks picker for harpoon files via <leader>h. No preview: the list is a
-- handful of files you already chose, so a preview pane adds nothing to jump to
-- one and just takes up the screen.
return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    opts = {
      settings = {
        sync_on_ui_close = true, -- persist list to disk when closing the menu
      },
    },
    keys = {
      {
        "<leader>H",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Harpoon Add File",
      },
      {
        "<leader>h",
        function()
          local harpoon = require("harpoon")
          local function build_items()
            local items = {}
            local list = harpoon:list()
            for i = 1, list:length() do
              local h_item = list.items[i]
              if h_item then
                table.insert(items, {
                  text = h_item.value,
                  file = h_item.value,
                })
              end
            end
            return items
          end

          Snacks.picker.pick({
            title = "Harpoon",
            finder = build_items,
            format = "file",
            -- The "select" preset declares hidden = { "preview" }, so this drops
            -- the preview pane and gives a compact centred list instead of the
            -- default half-screen split.
            layout = { preset = "select" },
            -- Filename first so it always starts at the same column and the eye
            -- scans one position instead of a ragged right edge. The path stays
            -- (dimmed) because it is load bearing here: 11 basenames in this
            -- solution are duplicated across projects, ClassesController.cs among
            -- them, so filename_only would make pinned entries indistinguishable.
            -- truncate = "left" trims the constant "Projects/" head rather than
            -- gouging the middle, if a path ever outgrows the box.
            formatters = { file = { filename_first = true, truncate = "left" } },
            actions = {
              harpoon_remove = function(picker, item)
                harpoon:list():remove({ value = item.file })
                picker:find({ refresh = true })
              end,
            },
            win = {
              input = {
                keys = {
                  ["<C-h>"] = { "harpoon_remove", mode = { "i", "n" } },
                  ["<C-j>"] = { "list_down", mode = { "i", "n" } },
                  ["<C-k>"] = { "list_up", mode = { "i", "n" } },
                },
              },
            },
          })
        end,
        desc = "Harpoon Picker",
      },
    },
  },
}
