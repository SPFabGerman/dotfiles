local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

beautiful.wallpaper = gears.filesystem.get_xdg_cache_home() .. "background"

local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

awful.screen.connect_for_each_screen(set_wallpaper)
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

client.connect_signal("focus",   function(c) c.border_color = beautiful.border_focus  end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Rounded corners
local rounded_corners_func = function(cr, w, h)
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
