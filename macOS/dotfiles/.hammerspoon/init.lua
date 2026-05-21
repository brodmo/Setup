local util = require("util")

--- APP HOTKEYS ---

util.bindApps({
	W = "Brave Browser", -- Web
	F = "draw.io", -- Files
	P = "Zed", -- Programming

	A = "Zen", -- AI
	R = "Obsidian", -- Read
	S = "Spotify",
	T = "Ghostty", -- Terminal

	Z = "Zotero",
	X = "Chrome", -- eXtra browser
	C = "Todoist", -- Checklist
})

--- HYPER CONTROLS ---

util.bindHyper("h", util.sendKey({}, "left"))
util.bindHyper("n", util.sendKey({}, "down"))
util.bindHyper("e", util.sendKey({}, "up"))
util.bindHyper("i", util.sendKey({}, "right"))

util.bindHyper(",", util.sendKey({}, "pageup"))
util.bindHyper(".", util.sendKey({}, "pagedown"))

util.bindHyper("escape", util.mediaKey("PLAY"))
util.bindHyper("f1", util.mediaKey("SOUND_DOWN"))
util.bindHyper("f2", util.mediaKey("SOUND_UP"))

util.bindHyper("2", util.sendKey({ "cmd", "shift" }, "["))
util.bindHyper("3", util.sendKey({ "cmd", "shift" }, "]"))

--- MOVE ON DISPLAY ---

util.bindHyper("Left", function()
	util.tileWindow(util.window(), "left")
end)

util.bindHyper("Right", function()
	util.tileWindow(util.window(), "right")
end)

util.bindHyper("Up", function()
	util.window():maximize()
end)

util.bindHyper("Down", function()
	util.centerWindow(util.window(), 0.7, 0.8)
end)

--- MOVE BETWEEN DISPLAYS ---

util.bindHyper("[", function()
	local win = util.window()
	local currentScreen = win:screen()
	local prevScreen = util.screenInDirection(currentScreen, "west") or util.screenInDirection(currentScreen, "north")
	if prevScreen then
		win:moveToScreen(prevScreen)
	end
end)

util.bindHyper("]", function()
	local win = util.window()
	local currentScreen = win:screen()
	local nextScreen = util.screenInDirection(currentScreen, "east") or util.screenInDirection(currentScreen, "south")
	if nextScreen then
		win:moveToScreen(nextScreen)
	end
end)
