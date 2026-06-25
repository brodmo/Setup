---@diagnostic disable-next-line: undefined-global
local hs = hs

local M = {} -- Module

local hyper = require("hyper")

local cycleState = {} -- bound key -> index to activate on its next press

local function cycleApps(key, names)
	local current = hs.application.frontmostApplication()
	local currentIdx = hs.fnutils.indexOf(names, current and current:name())
	if currentIdx then
		cycleState[key] = (currentIdx % #names) + 1
	end
	hs.application.launchOrFocus(names[cycleState[key] or 1])
end

function M.bind(apps)
	for key, app in pairs(apps) do
		if type(app) == "table" then -- a list of apps -> cycle through them
			hyper.bindAction(key, function()
				cycleApps(key, app)
			end)
		else
			hyper.bindAction(key, function()
				hs.application.launchOrFocus(app)
			end)
		end
	end
end

return M
