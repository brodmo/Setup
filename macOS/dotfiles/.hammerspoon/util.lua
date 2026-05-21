---@diagnostic disable-next-line: undefined-global
local hs = hs

local M = {} -- Module

--- HYPER KEY SETUP ---

hs.execute( -- remap caps lock to f18
	[[/usr/bin/hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x70000006D}]}']]
)

local hyper = hs.hotkey.modal.new()

hs.hotkey.bind({}, "F18", function()
	hyper.triggered = false
	hyper:enter()
end, function()
	hyper:exit()
	if not hyper.triggered then
		hs.eventtap.keyStroke({}, "escape", 0)
	end
end)

function M.bindHyper(key, fn)
	local wrapped = function()
		hyper.triggered = true
		fn()
	end
	hyper:bind({}, key, wrapped, nil, wrapped)
end

function M.bindApps(apps)
	for key, app in pairs(apps) do
		M.bindHyper(key, function()
			hs.application.launchOrFocus(app)
		end)
	end
end

function M.sendKey(mods, key)
	return function()
		hs.eventtap.event.newKeyEvent(mods, key, true):post()
		hs.eventtap.event.newKeyEvent(mods, key, false):post()
	end
end

function M.mediaKey(key)
	return function()
		hs.eventtap.event.newSystemKeyEvent(key, true):post()
		hs.eventtap.event.newSystemKeyEvent(key, false):post()
	end
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
