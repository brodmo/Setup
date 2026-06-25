---@diagnostic disable-next-line: undefined-global
local hs = hs

local M = {} -- Module

local SYNTH_MARK = 0xF18 -- tagged on events we post so the tap skips them instead of recursing
local sourceUserData = hs.eventtap.event.properties.eventSourceUserData

function M.isSynthKey(e) return e:getProperty(sourceUserData) == SYNTH_MARK end

function M.sendKey(mods, key)
	local down = hs.eventtap.event.newKeyEvent(mods, key, true)
	down:setProperty(sourceUserData, SYNTH_MARK)
	down:post()
	local up = hs.eventtap.event.newKeyEvent(mods, key, false)
	up:setProperty(sourceUserData, SYNTH_MARK)
	up:post()
end

function M.sendMediaKey(key)
	hs.eventtap.event.newSystemKeyEvent(key, true):post()
	hs.eventtap.event.newSystemKeyEvent(key, false):post()
end

return M
