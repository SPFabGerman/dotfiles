local awful = require("awful")
local gears = require("gears")

local charitable = require("charitable")

-- Default modkey.
local modkey = "Mod4"

globalkeys = gears.table.join(
    -- Client focus and movement
    awful.key({ modkey }, "Down", function () awful.client.focus.byidx( 1) end),
    awful.key({ modkey }, "Up",   function () awful.client.focus.byidx(-1) end),
    awful.key({ modkey, "Shift" }, "Down", function () awful.client.swap.byidx(  1) end),
    awful.key({ modkey, "Shift" }, "Up",   function () awful.client.swap.byidx( -1) end),
    -- awful.key({ modkey }, "u",    awful.client.urgent.jumpto), -- Currently done automatically

    awful.key({ modkey, "Control" }, "n", function ()
        local c = awful.client.restore()
        if c then c:jump_to() end
    end),

    -- Tag focus
    awful.key({ modkey }, "Left",  awful.tag.viewprev),
    awful.key({ modkey }, "Right", awful.tag.viewnext),
    awful.key({ modkey }, "Tab",   awful.tag.history.restore),

    -- Screen focus
    awful.key({ modkey, "Control" }, "Left",  function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey, "Control" }, "Right", function () awful.screen.focus_relative( 1) end),

    -- Layouts
    awful.key({ modkey, "Shift" }, "t", function () awful.layout.set(awful.layout.suit.tile) end),
    awful.key({ modkey, "Shift" }, "m", function () awful.layout.set(awful.layout.suit.max) end)
    -- awful.key({ modkey, "Shift", "Control" }, "f", function () awful.layout.set(awful.layout.suit.floating) end)
)

-- Bind all key numbers to tags. (Assume maximum of 9 tags.)
for i = 1, #charitable.tags do
    globalkeys = gears.table.join(globalkeys,
        awful.key({ modkey }, tostring(i), function ()
            charitable.select_tag(charitable.tags[i], awful.screen.focused())
        end),
        awful.key({ modkey, "Control" }, tostring(i), function ()
            charitable.toggle_tag(charitable.tags[i], awful.screen.focused())
        end),
        awful.key({ modkey, "Shift" }, tostring(i), function ()
            if client.focus then client.focus:move_to_tag(charitable.tags[i]) end
        end),
        awful.key({ modkey, "Control", "Shift" }, tostring(i), function ()
            if client.focus then client.focus:toggle_tag(charitable.tags[i]) end
        end)
    )
end

-- Set keys
root.keys(globalkeys)



-- These keys are later added to all clients via a default rule in rules.lua
clientkeys = gears.table.join(
    awful.key({ modkey }, "c",      function (c) c:kill() end),

    awful.key({ modkey, "Shift" }, "f", awful.client.floating.toggle),
    awful.key({ modkey }, "n", function (c)
        c.minimized = true
    end),
    awful.key({ modkey }, "m", function (c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end)

    -- awful.key({ modkey }, "Return", function (c) c:swap(awful.client.getmaster()) end),
)

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)
