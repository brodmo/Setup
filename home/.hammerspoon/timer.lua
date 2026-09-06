---@diagnostic disable-next-line: undefined-global
local hs = hs

local M = {} -- Module

local menubar = hs.menubar.new()
local startTime = os.time()
local lockedAt

local PHASE_LENGTH = 15
local PHASE_EMOJIS = { "🌱", "🌸", "🌻", "🍁", "❄️", "🧊" }

local function refresh()
	local duration = os.time() - startTime
	local minutes = math.floor(duration / 60)
	local phase = math.floor(minutes / PHASE_LENGTH) + 1
	local emoji = PHASE_EMOJIS[math.min(phase, #PHASE_EMOJIS)]
	local text = tostring(minutes) .. "m"
	-- local text = minutes < 60 and string.format("%dm", minutes)
	-- 	or string.format("%dh %dm", math.floor(minutes / 60), minutes % 60)
	menubar:setTitle(emoji .. " " .. text)
end

function M.reset()
	startTime = os.time()
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
				if lockedAt and (os.time() - lockedAt) / 60 >= PHASE_LENGTH then
					M.reset()
				end
				lockedAt = nil
			end
		end)
		:start()

	menubar:setClickCallback(M.reset)
	refresh()
end

return M
