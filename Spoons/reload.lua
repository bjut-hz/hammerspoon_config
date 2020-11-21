local pathwatcher = require "hs.pathwatcher"
local alert = require "hs.alert"

-- http://www.hammerspoon.org/go/#fancyreload
local function reloadConfig(files, flagTables)
	alert.show("Hammerspoon Config Hot Reloaded")
	local doReload = false
	for _, file in pairs(files) do
		if file:sub(-4) == ".lua" then
			doReload = true
		end
	end
	if doReload then
		hs.reload()
	end
end

local watched_path = os.getenv("HOME") .. "/.hammerspoon/"
pathwatcher.new(watched_path, reloadConfig):start()
