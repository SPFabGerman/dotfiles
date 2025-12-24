local awful = require("awful")
local beautiful = require("beautiful")

awful.rules.rules = {
    -- Default rule: all clients will match this rule.
    {
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen,
            size_hints_honor = false,
        }
    },

    -- Add titlebars to dialogs
    -- This is reliant on a "requests:titlebars" signal handler. (Which is currently disabled.)
    {
        rule = { type = "dialog" },
        properties = { titlebars_enabled = true }
    },

    -- Extra floating clients
    {
        rule_any = {
            instance = { "pinentry" },
            class = { "Arandr", "Blueman-manager" },
            name = { "Event Tester" } -- xev
        },
        properties = { floating = true }
    },

    -- Extra fullscreen clients
    {
        rule_any = {
            class = { "Nwg-bar", "Nwg-drawer" }
        },
        properties = { fullscreen = true }
    },

    -- Extra sticky clients
    {
        rule_any = {
            class = { "Xdragon" }
        },
        properties = { sticky = true }
    },

}

