local hyper = require("hyper")
local display = require("display")
local keys = require("keys")
local apps = require("apps")
local timer = require("timer")

timer.start() -- session-length clock in the menubar

--- APP HOTKEYS ---

hyper.bindAction("W", function() apps.open("Brave Browser") end) -- Web
hyper.bindAction("F", function() apps.open("draw.io") end) -- Files
hyper.bindAction("P", function() apps.cycle({ "Zed", "PyCharm" }) end) -- Programming

hyper.bindAction("A", function() apps.open("Zen") end) -- AI
hyper.bindAction("R", function() apps.open("Obsidian") end) -- Read
hyper.bindAction("S", function() apps.open("Spotify") end)
hyper.bindAction("T", function() apps.open("Ghostty") end) -- Terminal

hyper.bindAction("Z", function() apps.open("Zotero") end)
hyper.bindAction("X", function() apps.open("Google Chrome") end) -- eXtra browser
hyper.bindAction("C", function() apps.open("Todoist") end) -- Checklist

hyper.bindAction(";", function() apps.open("System Settings") end)

--- KEYBINDS ---

hyper.bindKey("h", "left")
hyper.bindKey("n", "down")
hyper.bindKey("e", "up")
hyper.bindKey("i", "right")

hyper.bindAction(",", function() keys.sendKey({}, "pageup") end)
hyper.bindAction(".", function() keys.sendKey({}, "pagedown") end)

hyper.bindAction("escape", function() keys.sendMediaKey("PLAY") end)
hyper.bindAction("f1", function() keys.sendMediaKey("SOUND_DOWN") end)
hyper.bindAction("f2", function() keys.sendMediaKey("SOUND_UP") end)

hyper.bindAction("2", function() keys.sendKey({ "cmd", "shift" }, "[") end)
hyper.bindAction("3", function() keys.sendKey({ "cmd", "shift" }, "]") end)

--- DISPLAY CONTROLS ---

hyper.bindAction("Left", function() display.tileWindow(display.window(), "left") end)
hyper.bindAction("Right", function() display.tileWindow(display.window(), "right") end)

hyper.bindAction("Up", function() display.window():maximize() end)
hyper.bindAction("Down", function() display.centerWindow(display.window(), 0.7, 0.8) end)

hyper.bindAction("[", function() display.moveToScreen({ "west", "north" }) end)
hyper.bindAction("]", function() display.moveToScreen({ "east", "south" }) end)
