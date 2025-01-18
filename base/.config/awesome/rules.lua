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
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    },

    -- Floating clients
    {
        rule_any = {
            instance = {
                "pinentry",
            },
            class = {
                "Arandr",
                "Blueman-manager",
            },
            name = {
                "Event Tester",  -- xev.
            }
        },
        properties = { floating = true }
    },

    {
        rule = {
            class = "Nwg-bar"
        },
        properties = {
            fullscreen = true
        }
    },

    {
        rule_any = {
            class = { "Dragon-drop", "Xdragon" }
        },
        properties = {
            sticky = true
        }
    },

    {
        rule = {
            class = "Nwg-drawer"
        },
        properties = { fullscreen = true }
    },

    -- {
    --     rule = {
    --         class = "Evince"
    --     },
    --     callback = function(c)
    --         awful.layout.set(awful.layout.suit.max, c.first_tag)
    --     end
    -- },

    {
        rule = {
            class = "zoom",
            name = "zoom"
        },
        properties = { floating = true }
    },

    -- Add titlebars to dialogs
    {
        rule_any = {
            type = { "dialog" }
        },
        properties = { titlebars_enabled = true }
    },

}

