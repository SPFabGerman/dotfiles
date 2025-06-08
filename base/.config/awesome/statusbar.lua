local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local charitable = require("charitable")

local awesome_battery = require("awesome-wm-widgets.battery-widget.battery")
local awesome_volume = require('awesome-wm-widgets.pactl-widget.volume')

-- Widgets that are shared between all instances of a statusbar are created statically and reused for every bar.
-- Widgets that are unique per statusbar are created dynamically as needed.


-- Main Menu
-- This is only done once, because I use it so little, that I really don't care about the colors
local mainlauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = awful.menu({
        items = {
            { "restart", awesome.restart },
            { "quit", function() awesome.quit() end },
        }
    })
})


-- Basic Widgets
local clock_widget = wibox.widget.textclock()
local system_tray = wibox.widget.systray()
local volume_widget = awesome_volume()
local battery_widget = awesome_battery({
    font = "sans 10",
    path_to_icons = "/home/fabian/.nix-profile/share/icons/Papirus-Dark/32x32/symbolic/status/",
    show_current_level = true,
    display_notification = true,
    enable_battery_warning = false,
})


-- Taglist

-- This function returns the first client on every tag (the master) or nil
-- It is used to display the icon in the taglist
local function get_tag_master(tag)
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


local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) charitable.select_tag(t, awful.screen.focused()) end),
    awful.button({ }, 3, function(t) charitable.toggle_tag(t, awful.screen.focused()) end)
)

local taglist_icons_filled = { "󰎤", "󰎧", "󰎪", "󰎭", "󰎱", "󰎳", "󰎶", "󰎹", "󰎼" }
local taglist_icons_empty  = { "󰎦", "󰎩", "󰎬", "󰎮", "󰎰", "󰎵", "󰎸", "󰎻", "󰎾" }
local taglist_icons_stacked_filled = { "󰼏", "󰼐", "󰼑", "󰼒", "󰼓", "󰼔", "󰼕", "󰼖", "󰼗" }
local taglist_icons_stacked_empty  = { "󰎥", "󰎨", "󰎫", "󰎲", "󰎯", "󰎴", "󰎷", "󰎺", "󰎽" }

local function create_taglist(s)
    local function update_taglist_callback(self, tag, index, objects)
        local displaytext = taglist_icons_empty[index].."<span size=\"8pt\"> </span>"

        if tag.selected and tag.screen == s then
            self.fg = beautiful.fg_focus
            self.bg = beautiful.bg_focus
            displaytext = taglist_icons_filled[index].."<span size=\"8pt\"> </span>"
        else
            self.fg = nil
            self.bg = nil
        end

        local mc = get_tag_master(tag)
        self:get_children_by_id("client_icon_role")[1].client = mc
        if mc then displaytext = taglist_icons_stacked_filled[index].."<span size=\"8pt\"> </span>" end
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

    local taglist = awful.widget.taglist {
        screen  = s,
        source = function(screen, args) return charitable.tags end, -- Always show all tags in a consistent order
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        style   = {
            squares_sel = "", -- Disable awesome markings when a tag is occupied, since we already have custom icons for that
            squares_unsel = "",
        },
        widget_template = {
            id     = "my_background_role", -- Use custom background, since we only want to mark tags on the current screen
            widget = wibox.container.background,
            create_callback = update_taglist_callback,
            update_callback = update_taglist_callback,
            {
                widget = wibox.container.margin,
                left  = 8,
                right = 1,
                {
                    layout = wibox.layout.fixed.horizontal,
                    {
                        widget = wibox.container.place,
                        {
                            id = "client_icon_role",
                            widget = awful.widget.clienticon,
                            forced_width = 18,
                        },
                    },
                    {
                        id = "my_text_role",
                        widget = wibox.widget.textbox,
                        font = "MesloLGS Nerd Font Mono 18",
                    }
                }
            }
        }
    }

    return taglist
end


-- Tasklist

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c) c:jump_to() end),
    awful.button({ }, 3, function() awful.menu.client_list({ theme = { width = 500 } }) end)
)

local function create_tasklist(s)
    local function update_tasklist_callback(self, c, index, objects)
        self:get_children_by_id("client_icon_role")[1].client = c
    end

    local tasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons, 
        style = {
            font = "sans 10",
            font_focus = "sans 10 bold",
            font_minimized = "sans 10 italic"
        },
        widget_template = {
            id     = "background_role",
            widget = wibox.container.background,
            create_callback = update_tasklist_callback,
            update_callback = update_tasklist_callback,
            {
                widget = wibox.container.place,
                {
                    layout = wibox.layout.fixed.horizontal,
                    {
                        widget  = wibox.container.margin,
                        margins = 2,
                        {
                            id     = "client_icon_role",
                            widget = awful.widget.clienticon, -- Use clienticon and update it manually, for higher resolution images
                        },
                    },
                    {
                        id     = "text_role",
                        widget = wibox.widget.textbox,
                    }
                }
            }
        }
    }

    return tasklist
end



-- Create status bars
awful.screen.connect_for_each_screen(function (s)
    s.mytaglist = create_taglist(s)
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mytasklist = create_tasklist(s)

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
            system_tray,
            volume_widget,
            battery_widget,
            clock_widget,
        }
    }
end)


-- Code to update the colors
awesome.connect_signal("theme_refreshed", function ()
    mainlauncher.image = beautiful.awesome_icon

    for s in screen do
        s.mywibar.fg = beautiful.fg_normal
        s.mywibar.bg = beautiful.bg_normal
        s.selected_tag:emit_signal("property::selected") -- Emit a tag change signal, to force a color update
    end
end)

-- Trigger update of Taglist, if clients are moved around
client.connect_signal("swapped", function(c) c.first_tag:emit_signal("property::icon") end)



-- Some Plugins may require these two to be set
-- awful.util.taglist_buttons = taglist_buttons
-- awful.util.tasklist_buttons = tasklist_buttons

