-- window management
local hotkey = require "hs.hotkey"
local hints = require "hs.hints"
local window = require "hs.window"
local layout = require "hs.layout"
local screen = require "hs.screen"
local alert = require "hs.alert"
local fnutils = require "hs.fnutils"
local geometry = require "hs.geometry"
local mouse = require "hs.mouse"


-- default 0.2
window.animationDuration = 0

-- defines for window maximize toggler
local frameCache = {}
local function toggleMaximize()
    local win = window.focusedWindow()
    if frameCache[win:id()] then
        win:setFrame(frameCache[win:id()])
        frameCache[win:id()] = nil
    else
        frameCache[win:id()] = win:frame()
        win:maximize()
    end
end

--Predicate that checks if a window belongs to a screen
local function isInScreen(screen, win)
    return win:screen() == screen
end

function focusScreen(screen)
    --Get windows within screen, ordered from front to back.
    --If no windows exist, bring focus to desktop. Otherwise, set focus on
    --front-most application window.
    local windows = fnutils.filter(
            window.orderedWindows(),
            fnutils.partial(isInScreen, screen))
    local windowToFocus = #windows > 0 and windows[1] or window.desktop()
    windowToFocus:focus()

    -- move cursor to center of screen
    local pt = geometry.rectMidPoint(screen:fullFrame())
    mouse.setAbsolutePosition(pt)
end

-- maximized active window and move to selected monitor

local function moveTo(window, monitor)
    local is_full_screen = window:isFullScreen()
    if is_full_screen then
        -- 先退出全屏状态移动后再全屏
        window = window:toggleFullScreen()
    end

    window = window:moveToScreen(monitor, false, true)

    if is_full_screen then
        window:toggleFullScreen():isFullScreen()
    end
    return window
end



local function bindWindowToMonitor(monitor_id)
    return function ()
        local monitor = getMonitor(monitor_id)
        if not monitor then
            alert.show(string.format("[bindWindowToMonitor]invalid monitor id: %d", monitor_id))
            return
        end

        moveTo(window.focusedWindow(), monitor)
        focusScreen(monitor)
    end
end

-- left half
hotkey.bind(hyper, "J", function()
  if window.focusedWindow() then
    window.focusedWindow():moveToUnit(layout.left50)
  else
    alert.show("No active window")
  end
end)

-- right half
hotkey.bind(hyper, "L", function()
  window.focusedWindow():moveToUnit(layout.right50)
end)

-- top half
hotkey.bind(hyper, "I", function()
  window.focusedWindow():moveToUnit'[0,0,100,50]'
end)

-- bottom half
hotkey.bind(hyper, "K", function()
  window.focusedWindow():moveToUnit'[0,50,100,100]'
end)

-- left top quarter
hotkey.bind(hyperAlt, "Left", function()
  window.focusedWindow():moveToUnit'[0,0,50,50]'
end)

-- right bottom quarter
hotkey.bind(hyperAlt, "Right", function()
  window.focusedWindow():moveToUnit'[50,50,100,100]'
end)

-- right top quarter
hotkey.bind(hyperAlt, "Up", function()
  window.focusedWindow():moveToUnit'[50,0,100,50]'
end)

-- left bottom quarter
hotkey.bind(hyperAlt, "Down", function()
  window.focusedWindow():moveToUnit'[0,50,50,100]'
end)

-- full screen
hotkey.bind(hyper, 'F', function() 
  window.focusedWindow():toggleFullScreen()
end)

-- center window
hotkey.bind(hyper, 'C', function() 
  window.focusedWindow():centerOnScreen()
end)

-- maximize window
hotkey.bind(hyper, 'M', function() toggleMaximize() end)


-- display a keyboard hint for switching focus to each window
hotkey.bind(hyperShift, '/', function()
    hints.windowHints()
    -- Display current application window
    -- hints.windowHints(hs.window.focusedWindow():application():allWindows())
end)

-- switch active window
hotkey.bind(hyperShift, "H", function()
  window.switcher.nextWindow()
end)


-- 移动窗口及鼠标到指定显示器,并保持窗口状态(全屏)
hotkey.bind(hyper, "Left", bindWindowToMonitor(LEFT_MONITOR))

hotkey.bind(hyper, "Down", bindWindowToMonitor(MAC_MONITOR))

hotkey.bind(hyper, "Up", bindWindowToMonitor(UPPER_MONITOR))

-- 循环移动窗口
hotkey.bind(hyper, "Right", function()
    local current_window = window.focusedWindow()
    local current_screen = current_window:screen()
    local next_screen = getMonitor(MONITOR_ORDER[current_screen:id()])
    moveTo(current_window, next_screen)
    focusScreen(next_screen)
end)
