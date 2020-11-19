local screen = require "hs.screen"

local monitorID2NameMap = {
    [69734662] = "Color LCD",
    [722482643] = "DELL P2719HC",
    [724072916] = "DELL U2718QM",
}

-- 我的显示器id
LEFT_MONITOR = 722482643
UPPER_MONITOR = 724072916
MAC_MONITOR = 69734662

-- 显示器的顺序显示
MONITOR_ORDER = {
    [722482643] = 724072916,
    [724072916] = 69734662,
    [69734662] = 722482643,
}

function getMonitor(monitor_id)
    for _, v in ipairs(screen.allScreens()) do
        if v:id() == monitor_id then
            return v
        end
    end
end


