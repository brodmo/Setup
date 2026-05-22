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

util.bindHyperKey("h", "left")
util.bindHyperKey("n", "down")
util.bindHyperKey("e", "up")
util.bindHyperKey("i", "right")

util.bindHyperAction(",", util.sendKey({}, "pageup"))
util.bindHyperAction(".", util.sendKey({}, "pagedown"))

util.bindHyperAction("escape", util.mediaKey("PLAY"))
util.bindHyperAction("f1", util.mediaKey("SOUND_DOWN"))
util.bindHyperAction("f2", util.mediaKey("SOUND_UP"))

util.bindHyperAction("2", util.sendKey({ "cmd", "shift" }, "["))
util.bindHyperAction("3", util.sendKey({ "cmd", "shift" }, "]"))

--- MOVE ON DISPLAY ---

util.bindHyperAction("Left", function()
	util.tileWindow(util.window(), "left")
end)

util.bindHyperAction("Right", function()
	util.tileWindow(util.window(), "right")
end)

util.bindHyperAction("Up", function()
	util.window():maximize()
end)

util.bindHyperAction("Down", function()
	util.centerWindow(util.window(), 0.7, 0.8)
end)

--- MOVE BETWEEN DISPLAYS ---

util.bindHyperAction("[", function()
	local win = util.window()
	local currentScreen = win:screen()
	local prevScreen = util.screenInDirection(currentScreen, "west") or util.screenInDirection(currentScreen, "north")
	if prevScreen then
		win:moveToScreen(prevScreen)
	end
end)

util.bindHyperAction("]", function()
	local win = util.window()
	local currentScreen = win:screen()
	local nextScreen = util.screenInDirection(currentScreen, "east") or util.screenInDirection(currentScreen, "south")
	if nextScreen then
		win:moveToScreen(nextScreen)
	end
end)
