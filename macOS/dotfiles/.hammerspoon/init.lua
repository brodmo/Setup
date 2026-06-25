local hyper = require("hyper")
local display = require("display")
local keys = require("keys")
local timer = require("timer")

timer.start() -- session-length clock in the menubar

--- APP HOTKEYS ---

hyper.bindApps({
	W = "Brave Browser", -- Web
	F = "draw.io", -- Files
	P = { "Zed", "PyCharm" }, -- Programming

	A = "Zen", -- AI
	R = "Obsidian", -- Read
	S = "Spotify",
	T = "Ghostty", -- Terminal

	Z = "Zotero",
	X = "Google Chrome", -- eXtra browser
	C = "Todoist", -- Checklist

	[";"] = "System Settings",
})

--- HYPER CONTROLS ---

hyper.bindKey("h", "left")
hyper.bindKey("n", "down")
hyper.bindKey("e", "up")
hyper.bindKey("i", "right")

hyper.bindAction(",", function()
	keys.sendKey({}, "pageup")
end)
hyper.bindAction(".", function()
	keys.sendKey({}, "pagedown")
end)

hyper.bindAction("escape", function()
	keys.sendMediaKey("PLAY")
end)
hyper.bindAction("f1", function()
	keys.sendMediaKey("SOUND_DOWN")
end)
hyper.bindAction("f2", function()
	keys.sendMediaKey("SOUND_UP")
end)

hyper.bindAction("2", function()
	keys.sendKey({ "cmd", "shift" }, "[")
end)
hyper.bindAction("3", function()
	keys.sendKey({ "cmd", "shift" }, "]")
end)

--- MOVE ON DISPLAY ---

hyper.bindAction("Left", function()
	display.tileWindow(display.window(), "left")
end)

hyper.bindAction("Right", function()
	display.tileWindow(display.window(), "right")
end)

hyper.bindAction("Up", function()
	display.window():maximize()
end)

hyper.bindAction("Down", function()
	display.centerWindow(display.window(), 0.7, 0.8)
end)

--- MOVE BETWEEN DISPLAYS ---

hyper.bindAction("[", function()
	local win = display.window()
	local currentScreen = win:screen()
	local prevScreen = display.screenInDirection(currentScreen, "west")
		or display.screenInDirection(currentScreen, "north")
	if prevScreen then
		win:moveToScreen(prevScreen)
	end
end)

hyper.bindAction("]", function()
	local win = display.window()
	local currentScreen = win:screen()
	local nextScreen = display.screenInDirection(currentScreen, "east")
		or display.screenInDirection(currentScreen, "south")
	if nextScreen then
		win:moveToScreen(nextScreen)
	end
end)
