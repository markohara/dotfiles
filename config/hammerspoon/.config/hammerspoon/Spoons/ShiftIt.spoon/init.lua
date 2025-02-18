--- === ShiftIt ===
---
--- A spoon that enables performing a quick action for an application using double-tap shift

local obj = {}
obj.__index = obj

obj.shiftTap = nil
obj.keyTap = nil
obj.lastShiftTime = 0
obj.shiftTapCount = 0
obj.shiftTimeout = 0.3

obj.appMappings = {}

-- Function to create a fixed-size array
function createFixedSizeArray(maxSize)
    local array = {}
    
    function array:add(item)
        if #self < maxSize then
            table.insert(self, item)
        else
            table.remove(self, 1)
            table.insert(self, item)
        end
    end
    
    return array
end

-- Initialize keyStrokes as a fixed-size array
obj.keyStrokes = createFixedSizeArray(10)

function obj:init()
    self.shiftTap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(event)
        local flags = event:getFlags()
        if flags.shift and self:isAppMapped() then
            return self:handleShiftTap(-10)
        end
        return false
    end)

    self.keyTap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
        if self:isAppMapped() then
            self.keyStrokes:add(event:getKeyCode())
        end
        return false
    end)
    return self
end

function obj:isAppMapped()
    return self.appMappings[hs.application.frontmostApplication():name()] ~= nil
end

function obj:register(mappings)
    for appName, config in pairs(mappings) do
        self.appMappings[appName] = {modifiers = config.modifiers, key = config.key}
    end

    self.shiftTap:start()
    self.keyTap:start()
end

function obj:handleShiftTap(keyCode)
    local currentTime = os.time()
    self.shiftTapCount = (currentTime - self.lastShiftTime > self.shiftTimeout) and 1 or self.shiftTapCount + 1
    self.lastShiftTime = currentTime
    self.keyStrokes:add(keyCode)

    local n = #self.keyStrokes
    if self.keyStrokes[n-1] ~= self.keyStrokes[n] then return end

    local mapping = self.appMappings[hs.application.frontmostApplication():name()]
    if mapping then
        hs.eventtap.keyStroke(mapping.modifiers, mapping.key)
    end
    
    self.shiftTapCount = 0
end

return obj