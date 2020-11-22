require "Spoons/reload"
require "Spoons/hotkey"
require "Spoons/system"
require "Spoons/launcher"
require "Spoons/monitor"
require "Spoons/windows"
require "Spoons/mouse"
require "Spoons/ime"


local alert = require "hs.alert"
-- require "Spoons/wifi"
-- require "Spoons/timer"
-- local calendar = require "Spoons/calendar"
-- calendar:init()

-- 防止lazy extension loading
local pathwatcher = require "hs.pathwatcher"
local screen = require "hs.screen"
local screen_watcher = require "hs.screen.watcher"

screen_watcher.new(function()
    if #screen.allScreens() ~= MONITOR_NUM then
        --alert.show("Hammerspoon Config Hot Reloaded")
        hs.notify.show("🖥💻🖥", "Config Hot Reloaded", "monitor changed")
        hs.reload()
    end
end):start()


pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", function(files, flagTables)

    local doReload = false
    for _, file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
            break
        end
    end
    if doReload then
        hs.notify.show("🔨🔨🔨", "Config Hot Reloaded", "lua file changed")
        hs.reload()
    end
end):start()
