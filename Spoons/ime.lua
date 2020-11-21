local hotkey = require "hs.hotkey"
local window = require "hs.window"
local keycodes = require "hs.keycodes"
local watcher = require "hs.application.watcher"


local function Chinese()
    keycodes.currentSourceID("com.sogou.inputmethod.sogou.pinyin")
end

local function English()
    keycodes.currentSourceID("com.apple.keylayout.ABC")
end

local app2Ime = {
    ["GoLand"] = English,
    ["iTerm"] = English,
    ["Xcode"] = English,
    ["CLion"] = English,
    ["Code"] = English, -- vscode
    ["IntelliJ IDEA"] = English,
    ["金山词霸"] = English,
}


-- helper hotkey to figure out the app path and name of current focused window
hotkey.bind(hyper, ".", function()
    print("App path:        "
            ..window.focusedWindow():application():path()
            .."\n"
            .."App name:      "
            ..window.focusedWindow():application():name()
            .."\n"
            .."IM source id:  "
            ..keycodes.currentSourceID())
end)

-- Handle cursor focus and application's screen manage.
local function applicationWatcher(appName, eventType, appObject)
    if eventType == watcher.activated then
        if app2Ime[appName] then
            app2Ime[appName]()
        else
            -- chinese default
            Chinese()
        end
    end
end

local appWatcher = watcher.new(applicationWatcher)
appWatcher:start()