---@diagnostic disable-next-line: undefined-global
local hs = hs

local M = {} -- Module

--- HYPER KEY SETUP ---

hs.execute( -- remap caps lock to f18
	[[/usr/bin/hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x70000006D}]}']]
)

local keyMap = {} -- key -> key. Rewrites the keycode but keeps the modifier flags.
local actionMap = {} -- key -> action. Runs an action and swallows the key.

local F18 = hs.keycodes.map["f18"]
local keyDown = hs.eventtap.event.types.keyDown
local keyUp = hs.eventtap.event.types.keyUp

local SYNTH_MARK = 0xF18 -- tagged on events we post so the tap skips them instead of recursing
local sourceUserData = hs.eventtap.event.properties.eventSourceUserData

local hyperActive = false
local hyperUsed = false -- did a binding fire? if not, a lone caps tap sends escape

local hyperTap = hs.eventtap.new({ keyDown, keyUp }, function(e)
	if e:getProperty(sourceUserData) == SYNTH_MARK then
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

	if not (hyperActive and e:getType() == keyDown) then
		return false
	end

	hyperUsed = true

	local name = hs.keycodes.map[code]

	local key = keyMap[name]
	if key then
		e:setKeyCode(hs.keycodes.map[key]) -- modifiers pass through
		return false
	end

	local action = actionMap[name]
	local f = e:getFlags()
	if action and not (f.cmd or f.alt or f.ctrl or f.shift) then -- no modifiers held
		action()
		return true -- swallow
	end

	M.sendKey({ "cmd", "alt", "ctrl" }, name)
	return true
end)

M._hyperTap = hyperTap -- keep a reference so it isn't garbage-collected
hyperTap:start()

function M.bindHyperKey(sourceKey, targetKey)
	keyMap[sourceKey:lower()] = targetKey
end

function M.bindHyperAction(key, fn)
	actionMap[key:lower()] = fn
end

function M.bindApps(apps)
	for key, app in pairs(apps) do
		M.bindHyperAction(key, function()
			hs.application.launchOrFocus(app)
		end)
	end
end

function M.sendKey(mods, key)
	local down = hs.eventtap.event.newKeyEvent(mods, key, true)
	down:setProperty(sourceUserData, SYNTH_MARK)
	down:post()
	local up = hs.eventtap.event.newKeyEvent(mods, key, false)
	up:setProperty(sourceUserData, SYNTH_MARK)
	up:post()
end

function M.mediaKey(key)
	hs.eventtap.event.newSystemKeyEvent(key, true):post()
	hs.eventtap.event.newSystemKeyEvent(key, false):post()
end

--- MOVE ON DISPLAY ---

local function resizeWindow(win, x, y, w, h)
	if not win then
		hs.alert.show("Missing accessibility permissions")
		return
	end

	local screen = win:screen():frame()
	local f = win:frame()

	f.x = screen.x + (x * screen.w)
	f.y = screen.y + (y * screen.h)
	f.w = screen.w * w
	f.h = screen.h * h

	win:setFrame(f)
end

function M.tileWindow(win, side)
	local x = side == "left" and 0 or 0.5
	resizeWindow(win, x, 0, 0.5, 1)
end

function M.centerWindow(win, x_scale, y_scale)
	local x_offset = (1 - x_scale) / 2
	local y_offset = (1 - y_scale) / 2
	resizeWindow(win, x_offset, y_offset, x_scale, y_scale)
end

function M.window()
	return hs.window.focusedWindow()
end

--- MOVE BETWEEN DISPLAYS ---

local function westOf(current, target)
	return (target.x + target.w) <= current.x
end

local function northOf(current, target)
	return (target.y + target.h) <= current.y
end

local function eastOf(current, target)
	return westOf(target, current)
end

local function southOf(current, target)
	return northOf(target, current)
end

function M.screenInDirection(currentScreen, direction)
	local targetScreen
	local checkFunc

	if direction == "west" then
		targetScreen = currentScreen:toWest()
		checkFunc = westOf
	elseif direction == "east" then
		targetScreen = currentScreen:toEast()
		checkFunc = eastOf
	elseif direction == "north" then
		targetScreen = currentScreen:toNorth()
		checkFunc = northOf
	elseif direction == "south" then
		targetScreen = currentScreen:toSouth()
		checkFunc = southOf
	end

	if targetScreen then
		local currentFrame = currentScreen:frame()
		local targetFrame = targetScreen:frame()
		if checkFunc(currentFrame, targetFrame) then
			return targetScreen
		end
	end
	return nil
end

return M
