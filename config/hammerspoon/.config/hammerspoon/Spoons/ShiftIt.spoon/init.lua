--- === ShiftIt ===
---
--- A spoon that enables performing a quick action for an application using double-tap shift

local obj = {}
obj.__index = obj

obj.shiftTap = nil
obj.lastShiftTime = 0
obj.shiftTapCount = 0
obj.shiftTimeout = 0.3

obj.appMappings = {}

function obj:init()
    self.shiftTap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(event)
        local flags = event:getFlags()
        if flags.shift then
            self:handleShiftTap()
        end
        return false
    end)
    return self
end

function obj:register(mappings)
    for appName, config in pairs(mappings) do
        self.appMappings[appName] = {modifiers = config.modifiers, key = config.key}
    end

    self.shiftTap:start()
end

function obj:handleShiftTap()
    local currentTime = os.time()
    self.shiftTapCount = (currentTime - self.lastShiftTime > self.shiftTimeout) and 1 or self.shiftTapCount + 1
    self.lastShiftTime = currentTime

    if self.shiftTapCount ~= 2 then return end
    
    local mapping = self.appMappings[hs.application.frontmostApplication():name()]
    if mapping then
        hs.eventtap.keyStroke(mapping.modifiers, mapping.key)
    end
    
    self.shiftTapCount = 0
end

return obj