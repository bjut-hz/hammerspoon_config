local hotkey = require "hs.hotkey"
local alert = require "hs.alert"
local window = require "hs.window"
local mouse = require "hs.mouse"


local function mouseHighlight()
    if mouseCircle then
        mouseCircle:delete()
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end
    mousepoint = hs.mouse.getAbsolutePosition()
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
    mouseCircle:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
    mouseCircle:setFill(false)
    mouseCircle:setStrokeWidth(5)
    mouseCircle:bringToFront(true)
    mouseCircle:show()

    mouseCircleTimer = hs.timer.doAfter(3, function() mouseCircle:delete() end)
end


-- 绑定指定的显示器id
local function bindMouseToMonitor(monitor_name)
    return function ()
        local monitor = getMonitor(monitor_name)
        if not monitor then
            alert.show(string.format("[bindMouseToMonitor]invalid monitor id: %d", monitor_name))
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


-- 循环移动鼠标
hotkey.bind(hyperCtrl, "Right", function()
    local current_screen = mouse.getCurrentScreen()
    local next_screen = getMonitor(MONITOR_ORDER[current_screen:name()])
    focusScreen(next_screen)
end)