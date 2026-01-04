-- Fn+H/N/E/I → arrow keys (single-tap, low-lag)

local fnActive = false

-- raw keyCode → arrow keyCode map
local keyToArrow = {
  [hs.keycodes.map.h] = hs.keycodes.map.left,
  [hs.keycodes.map.n] = hs.keycodes.map.down,
  [hs.keycodes.map.e] = hs.keycodes.map.up,
  [hs.keycodes.map.i] = hs.keycodes.map.right,
}

local tap = hs.eventtap.new({
    hs.eventtap.event.types.flagsChanged,
    hs.eventtap.event.types.keyDown
  }, function(e)
    local t = e:getType()
    if t == hs.eventtap.event.types.flagsChanged then
      fnActive = e:getFlags().fn
      return false
    elseif fnActive and t == hs.eventtap.event.types.keyDown then
      local arrow = keyToArrow[e:getKeyCode()]
      if arrow then
        hs.eventtap.event.newKeyEvent({}, arrow, true):post()
        hs.eventtap.event.newKeyEvent({}, arrow, false):post()
        return true
      end
    end
    return false
end)

tap:start()
