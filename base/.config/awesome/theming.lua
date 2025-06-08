local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")


local theme = gears.filesystem.get_configuration_dir() .. "wal_theme.lua"
local wallpaper = gears.filesystem.get_xdg_cache_home() .. "wal/wallpaper"


-- Helper function to reload the theme.
-- This is mainly intended to be used by `awesome-client`.
-- It also emits a global signal, that other parts can connect to.
function reload_theme ()
    if not beautiful.init(theme) then
        naughty.notify({ title = "Awesome WM: Could not load theme", text = "Falling back to default." })
        beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
    end

    awesome.emit_signal("theme_refreshed")
end


-- Initialize beautiful and load theme
reload_theme()

-- Set wallpaper on all screens (even new ones) and when a screen's geometry changes (e.g. different resolution)
local function set_wallpaper(s) gears.wallpaper.maximized(wallpaper, s, true) end
awful.screen.connect_for_each_screen(set_wallpaper)
screen.connect_signal("property::geometry", set_wallpaper)

-- Change border color of active client
client.connect_signal("focus",   function(c) c.border_color = beautiful.border_focus  end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
awesome.connect_signal("theme_refreshed", function ()
    if client.focus then client.focus.border_color = beautiful.border_focus end
end)

-- Rounded corners
local function rounded_corners_func (cr, w, h)
    gears.shape.rounded_rect(cr, w, h, 8)
end
client.connect_signal("manage", function(c) c.shape = rounded_corners_func end)
client.connect_signal("property::fullscreen", function(c)
    if c.fullscreen then
        c.shape = nil
    else
        c.shape = rounded_corners_func
    end
end)
