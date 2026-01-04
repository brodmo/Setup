local function setup()
	ps.sub("cd", function()
		local cwd = cx.active.current.cwd

		-- Update terminal cwd
		local url = "file://localhost" .. tostring(cwd):gsub(" ", "%%20")
		io.stdout:write(string.format("\27]7;%s\27\\", url))
		io.stdout:flush()

		-- Update zoxide with current directory
		ya.manager_emit("shell", {
			"zoxide add " .. ya.quote(tostring(cwd)),
			orphan = true,
		})

		-- Folder-specific sorting rules
		if cwd:ends_with("Downloads") then
			ya.emit("sort", { "mtime", reverse = true, dir_first = false })
		else
			ya.emit("sort", { "alphabetical", reverse = false, dir_first = true })
		end
	end)
end

return { setup = setup }
