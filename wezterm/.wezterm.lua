local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.default_domain = "WSL:archlinux"

-- WSL native domain (bypasses ConPTY, required for undercurl)
config.wsl_domains = {
	{
		name = "WSL:archlinux",
		distribution = "archlinux",
		default_cwd = "~",
	},
}

-- Launch menu entries (shown in the + tab dropdown)
config.launch_menu = {
	{
		label = "PowerShell",
		args = { "C:\\Program Files\\PowerShell\\7\\pwsh.exe", "-NoLogo" },
		domain = { DomainName = "local" },
	},
}

-- Appearance -------------------------------------------------
config.colors = {
	background = "#111019",
	foreground = "#e0def4",
	cursor_bg = "#e0def4",
	cursor_fg = "#111019",
	selection_bg = "#44415a",
	selection_fg = "#e0def4",
	ansi = {
		"#26233a", -- black (surface)
		"#eb6f92", -- red (love)
		"#9ccfd8", -- green (foam)
		"#f6c177", -- yellow (gold)
		"#31748f", -- blue (pine)
		"#c4a7e7", -- magenta (iris)
		"#ebbcba", -- cyan (rose)
		"#e0def4", -- white (text)
	},
	brights = {
		"#6e6a86", -- bright black (muted)
		"#f083a0", -- bright red (lighter love)
		"#b4e4ec", -- bright green (lighter foam)
		"#f8d094", -- bright yellow (lighter gold)
		"#3d8fa8", -- bright blue (lighter pine)
		"#d4baf0", -- bright magenta (lighter iris)
		"#f0ceca", -- bright cyan (lighter rose)
		"#f0eeff", -- bright white (lighter text)
	},
}

config.window_background_opacity = 1.0

-- Rendering --------------------------------------------------
config.front_end = "OpenGL"
config.max_fps = 60

-- Let tmux handle tabs; hide WezTerm tabs
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true

-- tmux handles scrollback inside tmux; WezTerm buffer used when outside tmux
config.scrollback_lines = 1000000

-- Fonts ------------------------------------------------------
config.font = wezterm.font("JetBrainsMono Nerd Font Propo")
config.font_size = 10.5

-- Window / padding -------------------------------------------
config.window_decorations = "RESIZE"
config.initial_cols = 120
config.initial_rows = 32
config.window_padding = {
	left = 6,
	right = 6,
	top = 6,
	bottom = 0,
}

-- Cursor style -----------------------------------------------
config.default_cursor_style = "SteadyUnderline"
config.cursor_thickness = "0.10cell"

config.term = "wezterm"
config.audible_bell = "Disabled"

-- Undercurl visibility
config.underline_thickness = "2px"
config.underline_position = "-4px"

-- Ctrl+V: bridge Windows clipboard image to WSL Wayland clipboard, then paste
config.keys = {
  {
    key = "S",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SendKey({ key = "S", mods = "CTRL|SHIFT" }),
  },
  {
    key = "v",
    mods = "CTRL",
    action = wezterm.action_callback(function(window, pane)
      local has_image, _, _ = wezterm.run_child_process({
        "powershell.exe", "-NoProfile", "-NonInteractive", "-Command",
        "Add-Type -Assembly System.Windows.Forms; if ([System.Windows.Forms.Clipboard]::ContainsImage()) { exit 0 } else { exit 1 }",
      })
      if has_image then
        wezterm.run_child_process({
          "powershell.exe", "-NoProfile", "-NonInteractive", "-Command",
          "Add-Type -Assembly System.Windows.Forms; [System.Windows.Forms.Clipboard]::GetImage().Save('C:\\Users\\Public\\clip.png')",
        })
        wezterm.run_child_process({
          "wsl.exe", "-e", "bash", "-c",
          "cp /mnt/c/Users/Public/clip.png /tmp/clip.png && wl-copy --type image/png < /tmp/clip.png",
        })
        pane:send_text("\x16")
      else
        pane:send_text("\x16")
      end
    end),
  },
}

return config
