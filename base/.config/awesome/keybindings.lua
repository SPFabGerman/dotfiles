local awful = require("awful")
local gears = require("gears")

local charitable = require("charitable")

-- Default modkey.
local modkey = "Mod4"

globalkeys = gears.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Tab", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "Down",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "Up",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "Down", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "Up", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "Down", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "Up", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),

    -- switch to layout
    awful.key({ modkey, "Shift"   }, "t", function () awful.layout.set(awful.layout.suit.tile)                end,
              {description = "Tiling", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "g", function () awful.layout.set(awful.layout.suit.fair)                end,
              {description = "Grid", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "m", function () awful.layout.set(awful.layout.suit.max)                end,
              {description = "Max", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "c", function () awful.layout.set(awful.layout.suit.corner.nw)                end,
              {description = "Corner", group = "layout"}),
    awful.key({ modkey, "Shift", "Control" }, "f", function () awful.layout.set(awful.layout.suit.floating)                end,
              {description = "Floating", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Shift"  }, "f",       awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey,           }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        -- local screen = awful.screen.focused()
                        -- local tag = screen.tags[i]
                        -- if tag then
                        --    tag:view_only()
                        -- end
                        charitable.select_tag(charitable.tags[i], awful.screen.focused())
                  end),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      -- local screen = awful.screen.focused()
                      -- local tag = screen.tags[i]
                      -- if tag then
                      --    awful.tag.viewtoggle(tag)
                      -- end
                      charitable.toggle_tag(charitable.tags[i], awful.screen.focused())
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          -- local tag = client.focus.screen.tags[i]
                          local tag = charitable.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                      end
                  end),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          -- local tag = client.focus.screen.tags[i]
                          local tag = charitable.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end)
    )
end

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

-- Set keys
root.keys(globalkeys)
