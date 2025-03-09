--- === ShiftIt ===
---
--- A spoon that enables performing a quick action for an application using double-tap shift
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

    function array:flush()
        while #self > 0 do
            table.remove(self)
        end
        print(#self)
    end
    
    return array
end

local obj = {}
obj.__index = obj

obj.shiftTap = nil
obj.keyTap = nil

obj.lastShiftTime = 0
obj.shiftTapCount = 0
obj.shiftTimeout = 0.3

obj.hotkey = nil
obj.appMappings = {}

obj.keyStrokes = createFixedSizeArray(10)

function obj:init()
    self.shiftTap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(event)
        if not self:isAppMapped() then return false end
        local flags = event:getFlags()

        for flagName, isActive in pairs(flags) do
            if isActive then
                self.keyStrokes:add(flagName)
            end
        end

        self:handleShiftTap()
        return false
    end)

    self.keyTap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
        if not self:isAppMapped() then return false end

        self.keyStrokes:add(hs.keycodes.map[event:getKeyCode()])
        self:handleShiftTap()

        return false
    end)
    return self
end

function obj:isAppMapped()
    return self.appMappings[hs.application.frontmostApplication():name()] ~= nil
end

function obj:register(hotkey, mappings)
    self.hotkey = hotkey
    for appName, config in pairs(mappings) do
        self.appMappings[appName] = {modifiers = config.modifiers, key = config.key}
    end

    self.shiftTap:start()
    self.keyTap:start()
end

function obj:handleShiftTap()
    local currentTime = os.time()
    self.shiftTapCount = (currentTime - self.lastShiftTime > self.shiftTimeout) and 1 or self.shiftTapCount + 1
    self.lastShiftTime = currentTime

    if self.shiftTapCount == 1 then return end
    
    local n = #self.keyStrokes
    if n < 2 then return end
    if self.keyStrokes[n-1] ~= self.hotkey or self.keyStrokes[n] ~= self.hotkey then return end

    local mapping = self.appMappings[hs.application.frontmostApplication():name()]
    if mapping then
        hs.eventtap.keyStroke(mapping.modifiers, mapping.key)
    end
    
    self.shiftTapCount = 0
    self.keyStrokes:flush()
end

return obj