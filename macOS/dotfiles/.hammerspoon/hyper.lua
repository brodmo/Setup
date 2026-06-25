---@diagnostic disable-next-line: undefined-global
local hs = hs

local M = {}

local keys = require("keys")

hs.execute( -- remap caps lock to f18
	[[/usr/bin/hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x70000006D}]}']]
)

local keyMap = {} -- key -> key. Rewrites the keycode but keeps the modifier flags.
local actionMap = {} -- key -> action. Runs an action and swallows the key.

local F18 = hs.keycodes.map["f18"]
local keyDown = hs.eventtap.event.types.keyDown
local keyUp = hs.eventtap.event.types.keyUp

local hyperActive = false
local hyperUsed = false -- did a binding fire? if not, a lone caps tap sends escape
local activeHyperKeydowns = {} -- source keycode -> target keycode

local hyperTap = hs.eventtap.new({ keyDown, keyUp }, function(e)
	if keys.isSynthKey(e) then
		return false
	end

	local code = e:getKeyCode()

	if code == F18 then -- match by keycode so modifiers don't matter
		if e:getType() == keyDown then
			if not hyperActive then -- ignore key-repeat while held
				hyperActive = true
				hyperUsed = false
			end
		else
			hyperActive = false
			if not hyperUsed then
				hs.eventtap.keyStroke({}, "escape", 0)
			end
		end
		return true -- swallow the hyper key itself
	end

	if e:getType() == keyUp then
		if activeHyperKeydowns[code] then -- balance a remapped key's release, even if hyper was let go first
			e:setKeyCode(activeHyperKeydowns[code])
			activeHyperKeydowns[code] = nil
		end
		return false
	end

	if not hyperActive then
		return false
	end
	hyperUsed = true

	local name = hs.keycodes.map[code]

	local key = keyMap[name]
	if key then
		local target = hs.keycodes.map[key]
		e:setKeyCode(target) -- modifiers pass through
		activeHyperKeydowns[code] = target
		return false
	end

	local action = actionMap[name]
	local f = e:getFlags()
	if action and not (f.cmd or f.alt or f.ctrl or f.shift) then -- no modifiers held
		action()
		return true -- swallow
	end

	keys.sendKey({ "cmd", "alt", "ctrl" }, name)
	return true
end)

M._hyperTap = hyperTap -- keep a reference so it isn't garbage-collected
hyperTap:start()

function M.bindKey(sourceKey, targetKey)
	keyMap[sourceKey:lower()] = targetKey
end

function M.bindAction(key, fn)
	actionMap[key:lower()] = fn
end

return M
