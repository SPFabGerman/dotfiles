-- If LuaRocks is installed, make sure that packages installed through it are found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local awful = require("awful")
local naughty = require("naughty")
require("awful.autofocus") -- Ensures that clients are properly focused on some events (like tag switching). Will be obsolete and can be removed in future awesome version (after v4.3).


-- Allow connection via `awesome-client` command
require("awful.remote")

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

-- load extra configs
require("theming")
require("tags")
require("keybindings")
require("client-focus")
require("rules")
-- require("titlebars")
require("statusbar")

