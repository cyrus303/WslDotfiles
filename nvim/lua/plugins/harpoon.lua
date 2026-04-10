-- Add Snacks picker for harpoon files (with preview) via <leader>h
return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    keys = {
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
            preview = "file",
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
