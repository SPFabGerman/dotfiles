local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local vicious = require("vicious")
local wibox = require("wibox")

local charitable = require("charitable")

local volume_widget = require('awesome-wm-widgets.volume-widget.volume')

-- Create basic widgets
local clockwidget = wibox.widget.textclock()
local volumewidget = volume_widget()
local systray = wibox.widget.systray()

-- Setup button actions
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) charitable.select_tag(t, awful.screen.focused()) end),
    awful.button({ }, 3, function(t) charitable.toggle_tag(t, awful.screen.focused()) end)
)
local tasklist_buttons = gears.table.join(
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

-- Some Plugins require these two to be set
-- awful.util.taglist_buttons = taglist_buttons
-- awful.util.tasklist_buttons = tasklist_buttons


local wifiwidget = wibox.widget {
    image  = gears.filesystem.get_configuration_dir() .. "network-wireless.svg",
    resize = true,
    widget = wibox.widget.imagebox
}
local wifitooltip = awful.tooltip { }
wifitooltip:add_to_object(wifiwidget)
vicious.register(wifitooltip, vicious.widgets.wifiiw, function (widget, args)
    -- wifiwidget.visible = (args["{ssid}"] ~= "N/A")
    return args["{ssid}"]
end, 5, "wlo1")

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
vicious.register(batwidget, vicious.widgets.bat, "$2", 60, "BAT0")
vicious.register(batwidgettext, vicious.widgets.bat, "$2%", 60, "BAT0")

-- Create a launcher widget with a main menu to restart and quit awesome
-- This is only done once, because I use it so little, that I really don't care about the colors
local mainmenu = awful.menu({
    items = {
        { "restart", awesome.restart },
        { "quit", function() awesome.quit() end },
    }
})
local mainlauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mainmenu })

function get_master_of_tag(tag)
    local clients = client.get(tag.screen)
    for _, c in pairs(clients) do
        for _, t in pairs(c:tags()) do
            if t == tag then
                return c
            end
        end
    end
    return nil
end

local taglisticons  = { "󰎤", "󰎧", "󰎪", "󰎭", "󰎱", "󰎳", "󰎶", "󰎹", "󰎼" }
local taglisticons2 = { "󰎦", "󰎩", "󰎬", "󰎮", "󰎰", "󰎵", "󰎸", "󰎻", "󰎾" }
local taglisticons3 = { "󰼏", "󰼐", "󰼑", "󰼒", "󰼓", "󰼔", "󰼕", "󰼖", "󰼗" }
local taglisticons4 = { "󰎥", "󰎨", "󰎫", "󰎲", "󰎯", "󰎴", "󰎷", "󰎺", "󰎽" }

-- Widgets that are unique to each screen + Wibar creation
awful.screen.connect_for_each_screen(function (s)
    -- Create a Taglist widget
    local function update_taglist_widget(self, tag, index, objects)
        local displaytext = taglisticons2[index].."<span size=\"8pt\"> </span>"

        if tag.selected and tag.screen == s then
            self.fg = beautiful.fg_focus
            self.bg = beautiful.bg_focus
            displaytext = taglisticons[index].."<span size=\"8pt\"> </span>"
        else
            self.fg = nil
            self.bg = nil
        end

        local mc = get_master_of_tag(tag)
        self:get_children_by_id("client_icon_role")[1].client = mc
        if mc then displaytext = taglisticons3[index].."<span size=\"8pt\"> </span>" end
        if mc and mc.icon then
            self:get_children_by_id("client_icon_role")[1].visible = true
            self:get_children_by_id("my_text_role")[1].valign = "bottom"
            displaytext = "<span size=\"8pt\">"..tag.name.."</span>"
        else
            self:get_children_by_id("client_icon_role")[1].visible = false
            self:get_children_by_id("my_text_role")[1].valign = "center"
        end

        self:get_children_by_id("my_text_role")[1].markup = displaytext
    end

    s.mytaglist = awful.widget.taglist {
        screen  = s,
        source = function(screen, args) return charitable.tags end,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        style   = {
            squares_sel = "", -- We don't need extra markings when a tag is occupied, since we already have custom icons for that
            squares_unsel = "",
        },
        widget_template = {
            {
                {
                    {
                        {
                            id = "client_icon_role",
                            forced_width = 18,
                            widget = awful.widget.clienticon,
                        },
                        widget = wibox.container.place,
                    },
                    {
                        id = "my_text_role",
                        font = "MesloLGS Nerd Font Mono 18",
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left  = 8,
                right = 1,
                widget = wibox.container.margin
            },
            id     = "my_background_role", -- Use custom background, since we only want to mark tags on the current screen
            widget = wibox.container.background,
            create_callback = update_taglist_widget,
            update_callback = update_taglist_widget,
        }
    }

    -- Icon to show current layout
    s.mylayoutbox = awful.widget.layoutbox(s)
    -- s.mylayoutbox:buttons(gears.table.join(
    -- awful.button({ }, 1, function () awful.layout.inc( 1) end)))

    -- Create a Tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons =tasklist_buttons, 
        style = {
            font = "sans 10",
            font_focus = "sans 10 bold",
            font_minimized = "sans 10 italic"
        },
        widget_template = {
            {
                {
                    {
                        {
                            id     = "client_icon_role",
                            widget = awful.widget.clienticon, -- Use clienticon and update it manually, for higher resolution images
                        },
                        margins = 2,
                        widget  = wibox.container.margin,
                    },
                    {
                        id     = "text_role",
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                widget = wibox.container.place
            },
            id     = "background_role",
            widget = wibox.container.background,
            create_callback = function(self, c, index, objects)
                self:get_children_by_id("client_icon_role")[1].client = c
            end,
            update_callback = function(self, c, index, objects)
                self:get_children_by_id("client_icon_role")[1].client = c
            end,
        },
    }

    -- Create the wibar and add the widgets to it
    s.mywibar = awful.wibar({ position = "top", screen = s, opacity = 0.9, height = 26 })
    s.mywibar:setup {
        layout = wibox.layout.align.horizontal,
        {
            -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mainlauncher,
            s.mytaglist,
            s.mylayoutbox,
        },
        s.mytasklist, -- Middle widget
        {
            -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            systray,
            wifiwidget,
            volumewidget,
            batbox,
            clockwidget,
        },
    }
end)

-- Code to update the colors
function update_bar_colors()
    mainlauncher.image = beautiful.awesome_icon
    -- TODO: Figure out how to change the color of the menu widget

    for s in screen do
        s.mywibar.fg = beautiful.fg_normal
        s.mywibar.bg = beautiful.bg_normal
        s.selected_tag:emit_signal("property::selected") -- Emit a tag change signal, to force a color update
    end
end

-- Trigger update of Taglist, if clients are moved around
client.connect_signal("swapped", function(c) c.first_tag:emit_signal("property::icon") end)

