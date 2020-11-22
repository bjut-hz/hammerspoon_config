local screen = require "hs.screen"
local alert = require "hs.alert"

MAC_MONITOR = "Color LCD"

MONITOR_HOT_KEY_TEMPLATE = {
    ["Down"] = MAC_MONITOR,
}
MONITOR_NUM = #screen.allScreens()
-- 循环移动的顺序
MONITOR_CIRCLE_ORDER = {}


function getMonitor(monitor_name)
    for _, v in ipairs(screen.allScreens()) do
        if v:name() == monitor_name then
            return v
        end
    end
end




-- 自动构建循环展示
local function monitor_init()
    local monitor_map = {}
    for _, v in ipairs(screen.allScreens()) do
        monitor_map[v:name()] = v
        print("monitor name: " .. v:name())
    end

    if MONITOR_NUM == 1 then
        MONITOR_CIRCLE_ORDER = {
            [MAC_MONITOR] = MAC_MONITOR
        }
    elseif MONITOR_NUM == 2 then
        for monitor_name, _ in pairs(monitor_map) do
            if monitor_name ~= MAC_MONITOR then
            --   new monitor, as UPPER_MONITOR
                UPPER_MONITOR = monitor_name
                MONITOR_HOT_KEY_TEMPLATE["Up"] = UPPER_MONITOR


                MONITOR_CIRCLE_ORDER = {
                    [UPPER_MONITOR] = MAC_MONITOR,
                    [MAC_MONITOR] = UPPER_MONITOR,
                }
            end
        end

    elseif MONITOR_NUM == 3 then
        -- 预定义的模板
        LEFT_MONITOR = "DELL P2719HC"
        UPPER_MONITOR = "DELL U2718QM"

        if not (monitor_map[LEFT_MONITOR] and monitor_map[UPPER_MONITOR]) then
            LEFT_MONITOR = nil
            UPPER_MONITOR = nil
            for monitor_name, _ in pairs(monitor_map) do
                if monitor_name ~= MAC_MONITOR then
                    if not LEFT_MONITOR then
                        LEFT_MONITOR = monitor_name
                    else
                        UPPER_MONITOR = monitor_name
                    end
                end
            end
        end

        MONITOR_HOT_KEY_TEMPLATE["Up"] = UPPER_MONITOR
        MONITOR_HOT_KEY_TEMPLATE["Left"] = LEFT_MONITOR

        MONITOR_CIRCLE_ORDER = {
            [LEFT_MONITOR] = UPPER_MONITOR,
            [UPPER_MONITOR] = MAC_MONITOR,
            [MAC_MONITOR] = LEFT_MONITOR,
        }

    else
        alert.show("暂时不支持这么多的显示器数量,请修改HammerSpoon")
    end
end


monitor_init()
