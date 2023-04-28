local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local vicious = require("vicious")
local wibox = require("wibox")

local volume_widget = require('awesome-wm-widgets.volume-widget.volume')

-- Create a launcher widget and a main menu
myawesomemenu = awful.menu({ items = {
    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end },
}
})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = myawesomemenu })

local mylayoutlist = awful.popup {
    preferred_anchors = 'middle',
    border_color      = beautiful.border_focus,
    border_width      = beautiful.border_width,
    shape             = gears.shape.infobubble,
    ontop = true,
    visible = false,
    hide_on_right_click = true,
    widget = wibox.widget {
        widget  = wibox.container.margin,
        margins = 4,
        top = 14,
        awful.widget.layoutlist {
            source      = awful.widget.layoutlist.source.default_layouts,
            screen      = 1,
            base_layout = wibox.widget {
                spacing         = 5,
                forced_num_cols = 3,
                layout          = wibox.layout.grid.vertical,
            },
            widget_template = {
                {
                    {
                        id            = 'icon_role',
                        forced_height = 22,
                        forced_width  = 22,
                        widget        = wibox.widget.imagebox,
                    },
                    margins = 4,
                    widget  = wibox.container.margin,
                },
                id              = 'background_role',
                forced_width    = 24,
                forced_height   = 24,
                shape           = gears.shape.rounded_rect,
                widget          = wibox.container.background,
            },
        },
    },
}
mylayoutlist:buttons(gears.table.join(
                    awful.button({ }, 1, function(t) mylayoutlist.visible = false end)))
-- click_to_hide.popup(mylayoutlist, nil, false) -- needs v4.4

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it

-- Setup Taglist button actions
awful.util.taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ }, 3, awful.tag.viewtoggle)
                )

-- Button actions for window title area
awful.util.tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                         c:emit_signal(
                         "request::activate",
                         "tasklist",
                         {raise = true}
                         )
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end))


local wifiwidget = wibox.widget {
    image  = gears.filesystem.get_configuration_dir() .. "network-wireless.svg",
    resize = true,
    widget = wibox.widget.imagebox
}
local wifitooltip = awful.tooltip { }
wifitooltip:add_to_object(wifiwidget)
vicious.register(wifitooltip, vicious.widgets.wifiiw, function (widget, args)
    wifiwidget.visible = (args["{ssid}"] ~= "N/A")
    return args["{ssid}"]
end, 5, "wlp3s0")

-- Create wibox with batwidget
local batwidget = wibox.widget.progressbar()
local batwidgettext = wibox.widget.textbox()
local batbox = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    {
        widget = wibox.container.margin,
        left = 3, right = 1,
        top = 3, bottom = 3,
        {
            layout = wibox.container.rotate,
            color = beautiful.fg_widget,
            forced_height = 10, forced_width = 10,
            direction = 'east',
            {
                max_value = 1,
                widget = batwidget,
                border_width = 0.5, border_color = "#000000",
                color = beautiful.fg_normal,
            },
        },
    },
    batwidgettext
}

-- Register battery widget
-- vicious.register(batwidget, vicious.widgets.bat, "$2", 60, "BAT1")
-- vicious.register(batwidgettext, vicious.widgets.bat, "$2%", 60, "BAT1")


awful.screen.connect_for_each_screen(function(s)
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end)))
    mylayoutlist:bind_to_widget(s.mylayoutbox, 3)
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = awful.util.taglist_buttons,
        style = {
            font = "sans 18"
        }
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = awful.util.tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mylayoutbox,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            wifiwidget,
            volume_widget(),
            batbox,
            mytextclock,
        },
    }
end)
