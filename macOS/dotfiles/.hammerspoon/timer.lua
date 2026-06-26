---@diagnostic disable-next-line: undefined-global
local hs = hs

local M = {} -- Module

local menubar = hs.menubar.new()
local sessionStart = os.time()
local lockedAt

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
	M._refreshTimer = hs.timer.doEvery(10, refresh)
	M._lockWatcher = hs.caffeinate.watcher
		.new(function(e)
			if e == hs.caffeinate.watcher.screensDidLock then
				lockedAt = os.time()
			elseif e == hs.caffeinate.watcher.screensDidUnlock then
				if lockedAt and os.time() - lockedAt >= 300 then
					newSession() -- locked 5 min = break
				end
				lockedAt = nil
			end
		end)
		:start()

	menubar:setClickCallback(newSession)
	refresh()
end

return M
