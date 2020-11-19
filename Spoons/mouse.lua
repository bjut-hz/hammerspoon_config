local hotkey = require "hs.hotkey"
local alert = require "hs.alert"

-- 绑定指定的显示器id
local function bindMouseToMonitor(monitor_id)
    return function ()
        local monitor = getMonitor(monitor_id)
        if not monitor then
            alert.show(string.format("[bindMouseToMonitor]invalid monitor id: %d", monitor_id))
            return
        end

        focusScreen(monitor)
    end
end

-- 移动鼠标至指定的显示器
-- 根据显示器位置设置快捷键
-- Left键对应左侧显示器
hotkey.bind(hyperCtrl, "Left", bindMouseToMonitor(LEFT_MONITOR))
-- Down对应mac的显示器
hotkey.bind(hyperCtrl, "Down", bindMouseToMonitor(MAC_MONITOR))
-- Up对应上侧的显示器
hotkey.bind(hyperCtrl, "Up", bindMouseToMonitor(UPPER_MONITOR))