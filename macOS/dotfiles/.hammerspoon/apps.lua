---@diagnostic disable-next-line: undefined-global
local hs = hs

local M = {} -- Module

function M.open(name)
	hs.application.launchOrFocus(name)
end

local cycleIndex = {} -- app to focus on the next press, keyed by the joined app list

function M.cycle(names) -- steps through the apps on each press, resuming where it left off
	local key = table.concat(names, "\0")
	local current = hs.application.frontmostApplication()
	local currentIdx = hs.fnutils.indexOf(names, current and current:name())
	if currentIdx then
		cycleIndex[key] = (currentIdx % #names) + 1
	end
	M.open(names[cycleIndex[key] or 1])
end

return M
