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
local notify = require "hs.notify"
local caffeinate_watcher = require "hs.caffeinate.watcher"

-- 窗口于显示器的位置关系信息
local window_monitor_info = {}

screen_watcher.new(function()
    if #screen.allScreens() ~= MONITOR_NUM then
        print("Config Hot Reloaded: monitor changed", #screen.allScreens(), MONITOR_NUM)
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
        print("Config Hot Reloaded: lua file changed")
        hs.reload()
    end
end):start()


-- mac休眠后，还原屏幕与显示器的对应位置
-- 需要保存当前窗口信息的事件
local saved_event = {
    [caffeinate_watcher.screensDidLock] = "screensDidLock",
    [caffeinate_watcher.screensDidSleep] = "screensDidSleep",
    [caffeinate_watcher.sessionDidResignActive] = "sessionDidResignActive",
    [caffeinate_watcher.systemWillPowerOff] = "systemWillPowerOff",
    [caffeinate_watcher.systemWillSleep] = "systemWillSleep",
}

-- 需要恢复保存的窗口信息的事件
local restored_event = {
    [caffeinate_watcher.screensDidUnlock] = "screensDidUnlock",
    [caffeinate_watcher.screensDidWake] = "screensDidWake",
    [caffeinate_watcher.sessionDidBecomeActive] = "sessionDidBecomeActive",
    [caffeinate_watcher.systemDidWake] = "systemDidWake",
}

caffeinate_watcher.new(function(event_type)
    print(string.format("saved event: %s, restored event: %s", saved_event[event_type], restored_event[event_type]))
    if saved_event[event_type] then
        print("save event.....")
        local tmp_window = {}
        local all_windows = hs.window.allWindows()
        for _, w in ipairs(all_windows) do
            tmp_window[w:id()] = w:screen()
            print(string.format("window id: %s, app name: %s to monitor: %s", w:id(), w:application():name(), w:screen():name()))
        end

        window_monitor_info = tmp_window
    end

    if restored_event[event_type] then
        print("restore event.....")
        local current_all_windows = hs.window.allWindows()
        for _, w in ipairs(current_all_windows) do
            local screen = w:screen()
            local saved_screen = window_monitor_info[w:id()]
            if saved_screen and saved_screen:name() ~= screen:name() then
                print(string.format("move window id: %s, app name: %s to monitor: %s", w:id(), w:application():name(), saved_screen:name()))
                moveTo(w, saved_screen)
            end
        end
    end
end):start()