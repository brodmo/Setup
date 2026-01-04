---@diagnostic disable-next-line: undefined-global
local hs = hs

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

local function tileWindow(win, side)
	local x = side == "left" and 0 or 0.5
	resizeWindow(win, x, 0, 0.5, 1)
end

local function centerWindow(win, x_scale, y_scale)
	local x_offset = (1 - x_scale) / 2
	local y_offset = (1 - y_scale) / 2
	resizeWindow(win, x_offset, y_offset, x_scale, y_scale)
end

hs.hotkey.bind({ "ctrl", "alt", "cmd" }, "Left", function()
	local win = hs.window.focusedWindow()
	tileWindow(win, "left")
end)

hs.hotkey.bind({ "ctrl", "alt", "cmd" }, "Right", function()
	local win = hs.window.focusedWindow()
	tileWindow(win, "right")
end)

hs.hotkey.bind({ "ctrl", "alt", "cmd" }, "Up", function()
	local win = hs.window.focusedWindow()
	win:maximize()
end)

hs.hotkey.bind({ "ctrl", "alt", "cmd" }, "Down", function()
	local win = hs.window.focusedWindow()
	centerWindow(win, 0.7, 0.8)
end)

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

local function screenInDirection(currentScreen, direction)
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

hs.hotkey.bind({ "ctrl", "alt", "cmd" }, "[", function()
	local win = hs.window.focusedWindow()
	local currentScreen = win:screen()
	local prevScreen = screenInDirection(currentScreen, "west") or screenInDirection(currentScreen, "north")
	if prevScreen then
		win:moveToScreen(prevScreen)
	end
end)

hs.hotkey.bind({ "ctrl", "alt", "cmd" }, "]", function()
	local win = hs.window.focusedWindow()
	local currentScreen = win:screen()
	local nextScreen = screenInDirection(currentScreen, "east") or screenInDirection(currentScreen, "south")
	if nextScreen then
		win:moveToScreen(nextScreen)
	end
end)
