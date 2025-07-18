local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    awful.titlebar(c) : setup {
        -- Left
        awful.titlebar.widget.iconwidget(c),

        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = gears.table.join(
                -- Move window around by dragging
                awful.button({ }, 1, function()
                    c:emit_signal("request::activate", "titlebar", { raise = true })
                    awful.mouse.client.move(c)
                end)
            ),
            layout  = wibox.layout.flex.horizontal
        },

        { -- Right
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },

        layout = wibox.layout.align.horizontal
    }
end)
