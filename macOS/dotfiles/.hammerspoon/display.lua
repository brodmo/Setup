---@diagnostic disable-next-line: undefined-global
local hs = hs

local M = {}

--- MOVE ON DISPLAY ---

local function resizeWindow(x, y, w, h)
	local win = hs.window.focusedWindow()
	if not win then
		hs.alert.show("Accessibility permissions may be missing")
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

function M.tileWindow(side)
	local x = side == "left" and 0 or 0.5
	resizeWindow(x, 0, 0.5, 1)
end

function M.centerWindow(x_scale, y_scale)
	local x_offset = (1 - x_scale) / 2
	local y_offset = (1 - y_scale) / 2
	resizeWindow(x_offset, y_offset, x_scale, y_scale)
end

function M.maximizeWindow() resizeWindow(0, 0, 1, 1) end

--- MOVE BETWEEN DISPLAYS ---

local function westOf(current, target) return (target.x + target.w) <= current.x end

local function northOf(current, target) return (target.y + target.h) <= current.y end

local function eastOf(current, target) return westOf(target, current) end

local function southOf(current, target) return northOf(target, current) end

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

function M.moveToScreen(directions) -- first direction with a screen wins
	local win = hs.window.focusedWindow()
	local currentScreen = win:screen()
	for _, direction in ipairs(directions) do -- ipair to keep order
		local target = screenInDirection(currentScreen, direction)
		if target then
			win:moveToScreen(target)
			return
		end
	end
end

return M
