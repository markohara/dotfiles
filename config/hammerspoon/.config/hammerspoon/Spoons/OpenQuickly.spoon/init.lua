--- === QuickOpen ===
---
--- A Hammerspoon Spoon that enables quick open functionality in Xcode using double-tap shift

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

function obj:start()
    self.shiftTap:start()
    return self
end

function obj:add(appName, modifiers, key)
    self.appMappings[appName] = {modifiers = modifiers, key = key}
end

function obj:handleShiftTap()
    local currentTime = os.time()
    
    if (currentTime - self.lastShiftTime) < self.shiftTimeout then
        self.shiftTapCount = self.shiftTapCount + 1
    else
        self.shiftTapCount = 1
    end
    
    self.lastShiftTime = currentTime
    
    if self.shiftTapCount == 2 then
        local app = hs.application.frontmostApplication()
        local appName = app:name()
        
        if self.appMappings[appName] then
            local mapping = self.appMappings[appName]
            hs.eventtap.keyStroke(mapping.modifiers, mapping.key)
        end
        
        self.shiftTapCount = 0
    end
end

return obj