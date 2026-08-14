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
            -- Custom formatter rather than format = "file": the built-in one
            -- hardcodes a single space between filename and path (see
            -- snacks/picker/format.lua, `resolved[#resolved + 1] = { " " }`) with
            -- no option to widen it. Padding the filename to a fixed width puts
            -- every path at the same column, so the list scans as two clean
            -- columns instead of a ragged edge. Names longer than the pad simply
            -- push their path right rather than being truncated -- being able to
            -- read the filename matters more than perfect alignment.
            format = function(item, picker)
              local base = vim.fn.fnamemodify(item.file, ":t")
              local icon, icon_hl = Snacks.util.icon(base, "file")
              local dir = vim.fn.fnamemodify(item.file, ":h")
              dir = vim.fs.relpath(picker:cwd(), dir) or dir
              -- Not Snacks.picker.util.align here: it returns the text with no
              -- padding at all once it exceeds the width, so a long filename
              -- (ExamBuilderQuestionAttemptResponsesController.cs) ended up flush
              -- against its path with no separator. Pad to the shared column when
              -- the name fits, and guarantee two spaces when it overflows.
              local pad = math.max(2, 30 - vim.api.nvim_strwidth(base))
              return {
                { Snacks.picker.util.align(icon, 2), icon_hl, virtual = true },
                { base .. string.rep(" ", pad), "SnacksPickerFile", field = "file" },
                { dir == "." and "" or dir, "SnacksPickerDir", field = "file" },
              }
            end,
            -- The "select" preset declares hidden = { "preview" }, so this drops
            -- the preview pane and gives a compact centred list instead of the
            -- default half-screen split.
            layout = { preset = "select" },
            -- No `formatters` block: those options only affect the built-in "file"
            -- formatter, which the custom `format` above replaces. The path is
            -- still kept (dimmed) rather than dropped, because it is load bearing
            -- here -- 11 .cs basenames in this solution are duplicated across
            -- projects, ClassesController.cs among them, so showing filenames
            -- alone would make pinned entries indistinguishable.
            actions = {
              harpoon_remove = function(picker, item)
                harpoon:list():remove({ value = item.file })
                -- picker:refresh(), not picker:find({ refresh = true }): refresh
                -- stashes the current cursor row as a target that the list
                -- restores once the finder has re-run. Calling find directly
                -- rebuilds the list with no target, so the cursor drops to row 1
                -- and you lose your place after every removal.
                picker:refresh()
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
