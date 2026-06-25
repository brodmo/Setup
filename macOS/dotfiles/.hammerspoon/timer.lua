---@diagnostic disable-next-line: undefined-global
local hs = hs

local M = {} -- Module

local menubar = hs.menubar.new()
local sessionStart = os.time()
local lockTimer

local function refresh()
	local duration = os.time() - sessionStart
	local emoji = duration >= 3600 and "⚠️ " or ""
	local minutes = math.floor(duration / 60)
	local text = minutes < 60 and string.format("%dm", minutes)
		or string.format("%dh %dm", math.floor(minutes / 60), minutes % 60)
	menubar:setTitle(emoji .. text)
end

local function newSession()
	sessionStart = os.time()
	refresh()
end

function M.start()
	-- keep references so they aren't garbage-collected
	M._tickTimer = hs.timer.doEvery(10, refresh)
	M._lockWatcher = hs.caffeinate.watcher
		.new(function(e)
			if e == hs.caffeinate.watcher.screensDidLock then
				lockTimer = hs.timer.doAfter(300, newSession) -- locked 5 min = break
			elseif e == hs.caffeinate.watcher.screensDidUnlock then
				if lockTimer then
					lockTimer:stop()
					lockTimer = nil
				end
			end
		end)
		:start()

	menubar:setClickCallback(newSession)
	refresh()
end

return M
