---@diagnostic disable-next-line: undefined-global
local hs = hs

--- HELPERS ---

local hyper = hs.hotkey.modal.new()

hs.execute( -- remap caps lock to f18
	[[/usr/bin/hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x70000006D}]}']]
)

hs.hotkey.bind({}, "F18", function()
	hyper.triggered = false
	hyper:enter()
end, function()
	hyper:exit()
	if not hyper.triggered then
		hs.eventtap.keyStroke({}, "escape", 0)
	end
end)

local function bindHyper(key, fn)
	local wrapped = function()
		hyper.triggered = true
		fn()
	end
	hyper:bind({}, key, wrapped, nil, wrapped)
end

local function sendKey(mods, key)
	return function()
		hs.eventtap.event.newKeyEvent(mods, key, true):post()
		hs.eventtap.event.newKeyEvent(mods, key, false):post()
	end
end

local function mediaKey(key)
	return function()
		hs.eventtap.event.newSystemKeyEvent(key, true):post()
		hs.eventtap.event.newSystemKeyEvent(key, false):post()
	end
end

--- HYPER CONTROLS ---

bindHyper("h", sendKey({}, "left"))
bindHyper("n", sendKey({}, "down"))
bindHyper("e", sendKey({}, "up"))
bindHyper("i", sendKey({}, "right"))

bindHyper(",", sendKey({}, "pageup"))
bindHyper(".", sendKey({}, "pagedown"))

bindHyper("escape", mediaKey("PLAY"))
bindHyper("f1", mediaKey("SOUND_DOWN"))
bindHyper("f2", mediaKey("SOUND_UP"))

bindHyper("2", sendKey({ "cmd", "shift" }, "["))
bindHyper("3", sendKey({ "cmd", "shift" }, "]"))

--- APP HOTKEYS ---

local apps = {
	W = "Brave Browser", -- Web
	F = "draw.io", -- Files
	P = "Zed", -- Programming

	A = "Zen", -- AI
	R = "Obsidian", -- Read
	S = "Spotify", -- Spotify
	T = "Ghostty", -- Terminal

	Z = "Zotero",
	X = "Chrome", -- eXtra browser
	C = "Todoist", -- Checklist
}

for key, app in pairs(apps) do
	bindHyper(key, function()
		hs.application.launchOrFocus(app)
	end)
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

local function tileWindow(win, side)
	local x = side == "left" and 0 or 0.5
	resizeWindow(win, x, 0, 0.5, 1)
end

local function centerWindow(win, x_scale, y_scale)
	local x_offset = (1 - x_scale) / 2
	local y_offset = (1 - y_scale) / 2
	resizeWindow(win, x_offset, y_offset, x_scale, y_scale)
end

local function window()
	return hs.window.focusedWindow()
end

bindHyper("Left", function()
	tileWindow(window(), "left")
end)

bindHyper("Right", function()
	tileWindow(window(), "right")
end)

bindHyper("Up", function()
	window():maximize()
end)

bindHyper("Down", function()
	centerWindow(window(), 0.7, 0.8)
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

bindHyper("[", function()
	local win = window()
	local currentScreen = win:screen()
	local prevScreen = screenInDirection(currentScreen, "west") or screenInDirection(currentScreen, "north")
	if prevScreen then
		win:moveToScreen(prevScreen)
	end
end)

bindHyper("]", function()
	local win = window()
	local currentScreen = win:screen()
	local nextScreen = screenInDirection(currentScreen, "east") or screenInDirection(currentScreen, "south")
	if nextScreen then
		win:moveToScreen(nextScreen)
	end
end)
