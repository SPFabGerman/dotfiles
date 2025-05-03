local gears = require("gears")

-- Auto focus urgent windows
client.connect_signal("property::urgent", function(c)
    if c.urgent then c:jump_to() end
end)

-- Focus follows Mouse
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false}) -- TODO: Maybe switch to c:jump_to()?
end)



-- Mouse follows Focus
local function move_mouse_onto_focused_client(unconditional)
    local c = client.focus
    if mouse.object_under_pointer() ~= c or unconditional then
        local geometry = c:geometry()
        local x = geometry.x + geometry.width/2
        local y = geometry.y + geometry.height/2
        mouse.coords({x = x, y = y}, true)
        -- awful.placement.centered(mouse, {parent = c})
    end
end

client.connect_signal("focus", function ()
    -- Move mouse at end of event loop, to ensure that all clients have the correct position
    gears.timer.delayed_call(move_mouse_onto_focused_client)
end)

client.connect_signal("swapped", function (c1, c2, issource)
    -- Only change mouse position if the focused client is swapped.
    if issource and c2 == client.focus then
        -- mouse.object_under_pointer is updated to late, so we have to focus unconditionaly.
        gears.timer.delayed_call(move_mouse_onto_focused_client, true)
    end
end)
