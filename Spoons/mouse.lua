local hotkey = require "hs.hotkey"
local alert = require "hs.alert"
local window = require "hs.window"
local mouse = require "hs.mouse"
local notify = require "hs.notify"


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
            notify.show("🔨🔨🔨", string.format("[bindMouseToMonitor]invalid monitor id: %s", monitor_name), "")
            return
        end

        focusScreen(monitor)
    end
end

-- 移动鼠标至指定的显示器
for key, monitor_name in pairs(MONITOR_HOT_KEY_TEMPLATE) do
    hotkey.bind(hyperCtrl, key, bindMouseToMonitor(monitor_name))
end


-- 循环移动鼠标
hotkey.bind(hyperCtrl, "space", function()
    local current_screen = mouse.getCurrentScreen()
    local next_screen = getMonitor(MONITOR_CIRCLE_ORDER[current_screen:name()])
    focusScreen(next_screen)
end)