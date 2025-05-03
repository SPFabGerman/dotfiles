local awful = require("awful")
local charitable = require("charitable")

local numtags = 9
local default_layout = awful.layout.suit.tile


-- Create Tags
local tnames = {}
local tlayouts = {}
for i = 1, numtags do
    tnames[i] = tostring(i)
    tlayouts[i] = default_layout
end
charitable.tags = charitable.create_tags(tnames, tlayouts)

-- Show an unselected tag when a screen is connected
awful.screen.connect_for_each_screen(function(s)
    for i = 1, #charitable.tags do
         if not charitable.tags[i].selected then
             charitable.tags[i].screen = s
             charitable.tags[i]:view_only()
             return
         end
    end
end)

-- Ensure that removing screens doesn't kill tags
tag.connect_signal("request::screen", function(t)
    t.selected = false
    for s in screen do
        if s ~= t.screen then
            t.screen = s
            return
        end
    end
end)



-- Reset Layout, if tag is empty
tag.connect_signal("property::selected", function(t)
    if #t:clients() == 0 then t.layout = default_layout end
end)
