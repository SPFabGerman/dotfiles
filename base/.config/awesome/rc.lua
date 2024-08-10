-- If LuaRocks is installed, make sure that packages installed through it are found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

local charitable = require("charitable")

require("awful.autofocus")
require("awful.remote")

function notify (title, text, priority)
    priority=priority or "normal"
    text=text or ""
    awful.spawn({ "notify-send", "-i", gears.filesystem.get_awesome_icon_dir().."awesome64.png", "-u", priority, title, text })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true
        notify("Awesome WM: Error occured", tostring(err), "critical")
        -- local f = io.open(gears.filesystem.get_cache_dir() .. "errors.txt", "a")
        -- f:write(tostring(err) .. "\n")
        -- f:close()
        in_error = false
    end)
end

-- Load theme and initialize beautiful
local theme = gears.filesystem.get_configuration_dir().."wal_theme.lua"
function update_theme ()
    if not beautiful.init(theme) then
        notify("Awesome WM: Could not load theme")
        return
    end

    if client.focus then client.focus.border_color = beautiful.border_focus end
    if update_bar_colors then update_bar_colors() end
end
update_theme()

-- Initialize Tags and Layouts for later use
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.corner.nw,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
    awful.layout.suit.floating,
}

-- awful.screen.connect_for_each_screen(function(s)
--     -- Each screen has its own tag table.
--     awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, awful.layout.layouts[1])
-- end)

charitable.tags = charitable.create_tags(
   { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
   {
      awful.layout.layouts[1],
      awful.layout.layouts[1],
      awful.layout.layouts[1],
      awful.layout.layouts[1],
      awful.layout.layouts[1],
      awful.layout.layouts[1],
      awful.layout.layouts[1],
      awful.layout.layouts[1],
      awful.layout.layouts[1],
   }
)

awful.screen.connect_for_each_screen(function(s)
    -- Show an unselected tag when a screen is connected
    for i = 1, #charitable.tags do
         if not charitable.tags[i].selected then
             charitable.tags[i].screen = s
             charitable.tags[i]:view_only()
             break
         end
    end
end)

-- ensure that removing screens doesn't kill tags
tag.connect_signal("request::screen", function(t)
    t.selected = false
    for s in screen do
        if s ~= t.screen then
            t.screen = s
            return
        end
    end
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

-- Auto focus urgent windows
client.connect_signal("property::urgent", function(c)
    if c.urgent then c:jump_to() end
end)

-- Reset Layout, if Tag is empty
tag.connect_signal("property::selected", function(t)
    if #t:clients() == 0 then t.layout = awful.layout.layouts[1] end
end)

-- load extra configs
require("aesthetics")
require("keybindings")
require("mouse_focus")
require("rules")
require("titlebars")
require("topbar")

