local screen = require "hs.screen"

-- 我的显示器Name
LEFT_MONITOR = "DELL P2719HC"
UPPER_MONITOR = "DELL U2718QM"
MAC_MONITOR = "Color LCD"

-- 显示器的顺序显示
MONITOR_ORDER = {
    [LEFT_MONITOR] = UPPER_MONITOR,
    [UPPER_MONITOR] = MAC_MONITOR,
    [MAC_MONITOR] = LEFT_MONITOR,
}

function getMonitor(monitor_name)
    for _, v in ipairs(screen.allScreens()) do
        if v:name() == monitor_name then
            return v
        end
    end
end

for _, v in ipairs(screen.allScreens()) do
    print(v:id(), v:name())
end


