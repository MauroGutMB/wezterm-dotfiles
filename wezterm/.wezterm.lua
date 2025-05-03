--envia para a api do wezterm e segura as configurações básicas
local wezterm = require("wezterm")
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

--configurações
config.audible_bell = "Disabled"
config.window_decorations = "RESIZE"
config.default_prog = {  'wsl.exe', '-d', 'Arch', 'zsh'}
config.enable_wayland = false


local home = "C:/Users/*User"


config.launch_menu = {
    {
      label = "Windows PWSH",
      args = { "pwsh.exe"},
      cwd =  home,
    },
  }


config.inactive_pane_hsb = {
  hue = 0.9,
  saturation = 1.7,
  brightness = 0.06,
}
config.window_background_opacity = 1
config.font_size = 12.0
--
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
config.tab_bar_at_bottom = false


wezterm.on("format-tab-title", function(tab)
  local cwd_uri = tab.active_pane.current_working_dir
  local cwd = cwd_uri and cwd_uri.file_path or "?"

  local dir_name = string.match(cwd, "[^/\\]+$") or cwd
  return {
    { Text = "  " .. dir_name .. " " },
  }
end)



wezterm.on("update-status", function(window, pane)
  -- Workspace name

  local basename = function(s)
    -- Nothing a little regex can't fix
    return string.gsub(s, "(.*[/\\])(.*)", "%2")
  end

  -- Current working directory
  local cwd = pane:get_current_working_dir()
  if cwd then
    cwd = basename(cwd.file_path)  --> URL object introduced in 20240127-113634-bbcac864 (type(cwd) == "userdata")
    -- cwd = basename(cwd) --> 20230712-072601-f4abf8fd or earlier version
  else
    cwd = ""
  end

  -- Current command
  local cmd = pane:get_foreground_process_name()
  -- CWD and CMD could be nil (e.g. viewing log using Ctrl-Alt-l)
  cmd = cmd and basename(cmd) or ""
  if cmd == "wslhost.exe" then
    cmd = "WSL"
  else
    cmd = "WINDOWS"
  end

 -- Right status
 local time = wezterm.strftime("%H:%M:%S")
 local date = wezterm.strftime("%a %d %b %Y")
 -- local info = wezterm.battery_info()
 -- local battery = info[1]
 -- local charge = battery.state_of_charge * 100
 -- local charge = string.format("%.0f%%", charge)
 window:set_right_status(wezterm.format({
    -- Wezterm has a built-in nerd fonts
    -- https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html
    { Text = wezterm.nerdfonts.dev_terminal .. "  WezTerm" },
    { Text = " | " },
    { Foreground = { Color = "#00ff88" } },
    { Text = wezterm.nerdfonts.fa_code .. "  " .. cmd },
    { Text = " | " },
    { Text = wezterm.nerdfonts.md_clock .. "  " .. time },
    { Text = " | " },
    { Text = wezterm.nerdfonts.fa_calendar .. "  " .. date },
    { Text = "  " },
  }))
end)


-- mostrar barra superior

local show_bar = false

wezterm.on("toggle-tab-bar", function(window)
  show_bar = not show_bar
  window:set_config_overrides({
    enable_tab_bar = show_bar,
    window_decorations = show_bar and "TITLE | RESIZE" or "RESIZE",
  })
end)





-- padding



config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}





--#89b4fa
--#1e1e2e


-- background

config.color_scheme = "deep"
config.colors = {
	foreground = "#ffff00",
  tab_bar = {
    background = "#00004e",
    active_tab = {
      bg_color = "#00b4fa",
      fg_color = "#00002e",
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = "#313244",
      fg_color = "#a6adc8",
    },
    inactive_tab_hover = {
      bg_color = "#45475a",
      fg_color = "#cdd6f4",
    },
    new_tab = {
      bg_color = "#002222",
      fg_color = "#89b4fa",
    },
    new_tab_hover = {
      bg_color = "#006666",
      fg_color = "#1e1e2e",
      italic = true,
    }
  },
}



-- math.randomseed(os.time())
-- local bgs = {
--   "arkn",
--   "arkn1",
--   "arkn2",
--   "arkn3",
--   "arkn4",
--   "arkn5",
--   "arkn6",
--   "arkn7",
--   "arkn8",
--   "arkn9",
--   "arkn10",
--   "arkn11",
--   "arkn12",
--   "arkn13",
--   "arkn14",
--   "arkn15",
--   "arkn16",
--   "arkn17",
--   "arkn18",
--   "arkn19",
--   "arkn20",
--   "arkn21",
--   "arkn22",
--   "arkn23",
--   "arkn24",
--   "arkn25",
-- }
--
-- local rnd_bg = bgs[math.random(#bgs)]
--
--
-- config.window_background_image = "C:\\Users\\*User\\wezterm\\wezarkbg\\" .. rnd_bg .. ".jpg"
-- config.window_background_image_hsb = {
-- 	brightness = 0.04,
-- 	hue = 1.0,
-- 	saturation = 0.9,
-- }
--
--keybidings



config.keys = {

  {

    key = "p",
    mods = "CTRL|ALT",
    action = wezterm.action.SpawnCommandInNewTab { cwd = home, args = {"pwsh.exe"}, },

  },
  {

    key = "|",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SplitHorizontal({domain = "CurrentPaneDomain"}),

  },
  {

    key = "Z",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SplitVertical({domain = "CurrentPaneDomain"}),

  },
  {

    key = "X",
    mods = "CTRL|SHIFT",
    action = wezterm.action.CloseCurrentPane({confirm = false}),

  },
  {

    key = "LeftArrow",
    mods = "ALT",
    action = wezterm.action.AdjustPaneSize({"Left", 5}),

  },
  {

    key = "RightArrow",
    mods = "ALT",
    action = wezterm.action.AdjustPaneSize({"Right", 5}),

  },
  {

    key = "UpArrow",
    mods = "ALT",
    action = wezterm.action.AdjustPaneSize({"Up", 5}),

  },
  {

    key = "DownArrow",
    mods = "ALT",
    action = wezterm.action.AdjustPaneSize({"Down", 5}),

  },
  {
    key = "b",
    mods = "ALT",
    action = wezterm.action.EmitEvent("toggle-tab-bar"),
  },

}



-- retorna a config
return config


