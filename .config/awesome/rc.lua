-- If LuaRocks is installed, make sure that packages installed through it are found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local naughty = require("naughty")

-- local click_to_hide = require("click_to_hide") -- need v4.4

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Awesome WM: Error occured",
                         text = tostring(err) })
        in_error = false
    end)
end

-- Load theme and initialize beautiful
local theme = gears.filesystem.get_themes_dir() .. "xresources/theme.lua"
if not beautiful.init(theme) then
    naughty.notify {title="Awesome WM: Could not load theme."}
end

-- Initialize Tags and Layouts for later use
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.corner.nw,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
    awful.layout.suit.floating,
}

awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    awful.tag({ "󰎤", "󰎧", "󰎪", "󰎭", "󰎱", "󰎳", "󰎶", "󰎹" }, s, awful.layout.layouts[1])
end)

client.connect_signal("manage", function (c)
    c.size_hints_honor = false
    -- Prevent clients from being unreachable after screen count changes.
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)

-- load extra configs
require("aesthetics")
require("keybindings")
require("mouse_focus")
require("rules")
require("titlebars")
require("topbar")

