return {
  {
    "d7omdev/nuget.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = { "NuGetInstall", "NuGetRemove", "NuGetClearCache" },
    keys = {
      { "<leader>dpi", "<cmd>NuGetInstall<cr>", desc = "NuGet install" },
      { "<leader>dpr", "<cmd>NuGetRemove<cr>", desc = "NuGet remove" },
      { "<leader>dpc", "<cmd>NuGetClearCache<cr>", desc = "NuGet clear cache" },
    },
    opts = {
      keys = {
        install = { "n", "<leader>dpi" },
        remove = { "n", "<leader>dpr" },
        clear_cache = { "n", "<leader>dpc" },
      },
    },
    config = function(_, opts)
      require("nuget").setup(opts)

      -- Temporarily wrap pickers.new so the next picker whose title contains
      -- `title_pattern` gets <C-l> to confirm and optionally <C-h> to go back.
      local function inject_nav_keys(title_pattern, back_fn)
        local tel_pickers = require("telescope.pickers")
        local orig_new = tel_pickers.new
        tel_pickers.new = function(p_opts, p_config)
          tel_pickers.new = orig_new
          if p_config and type(p_config.prompt_title) == "string"
              and p_config.prompt_title:find(title_pattern, 1, true) then
            local orig_attach = p_config.attach_mappings
            p_config.attach_mappings = function(prompt_bufnr, map)
              local actions = require("telescope.actions")
              if back_fn then
                map("i", "<C-h>", function()
                  actions.close(prompt_bufnr)
                  vim.schedule(back_fn)
                end)
                map("n", "<C-h>", function()
                  actions.close(prompt_bufnr)
                  vim.schedule(back_fn)
                end)
              end
              map("i", "<C-l>", actions.select_default)
              map("n", "<C-l>", actions.select_default)
              if orig_attach then return orig_attach(prompt_bufnr, map) end
              return true
            end
          end
          return orig_new(p_opts, p_config)
        end
      end

      -- .csproj flow: "NuGet Search" picker
      local nuget_m = require("nuget.pickers.nuget")
      if not nuget_m._nav_patched then
        nuget_m._nav_patched = true
        local orig_search = nuget_m.search
        nuget_m.search = function(targets, installed, search_opts)
          inject_nav_keys("NuGet Search", function()
            require("nuget.install")(search_opts)
          end)
          orig_search(targets, installed, search_opts)
        end

        -- version picker has no meaningful back, just add <C-l> to confirm
        local orig_install = nuget_m.install
        nuget_m.install = function(targets, package, install_opts)
          inject_nav_keys("Select Version", nil)
          orig_install(targets, package, install_opts)
        end
      end

      -- .sln flow: "Solution Packages | ..." picker
      local sln_m = require("nuget.pickers.sln")
      if not sln_m._nav_patched then
        sln_m._nav_patched = true
        local orig_upgrades = sln_m.upgrades
        sln_m.upgrades = function(sln_path, installed, sln_opts)
          inject_nav_keys("Solution Packages", function()
            require("nuget.install")(sln_opts)
          end)
          orig_upgrades(sln_path, installed, sln_opts)
        end
      end

      -- remove flow: "NuGet Packages | ..." picker
      local csproj_m = require("nuget.pickers.csproj")
      if not csproj_m._nav_patched then
        csproj_m._nav_patched = true
        local orig_remove = csproj_m.remove
        csproj_m.remove = function(csproj_path, installed, remove_opts)
          inject_nav_keys("NuGet Packages", function()
            require("nuget.remove")(remove_opts)
          end)
          orig_remove(csproj_path, installed, remove_opts)
        end
      end
    end,
  },
}
