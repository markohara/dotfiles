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

obj.modTap = nil
obj.keyTap = nil

obj.lastShiftTime = 0
obj.hotkeyTapCount = 0
obj.timeout = 0.3

obj.hotkey = nil
obj.swallows = false
obj.appMappings = {}

obj.keyStrokes = createFixedSizeArray(10)

function obj:init()
    self.modTap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(event)
        if not self:isAppMapped() then return false end
        local flags = event:getFlags()

        for flagName, isActive in pairs(flags) do
            if isActive then
                self.keyStrokes:add(flagName)
            end
        end

        self:handleKeyPressedEvent()
        return false
    end)

    self.keyTap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
        if not self:isAppMapped() then return false end
        local key = hs.keycodes.map[event:getKeyCode()]

        self.keyStrokes:add(key)
        self:handleKeyPressedEvent()

        return self.swallows and key == self.hotkey or false
    end)
    return self
end

function obj:isAppMapped()
    return self.appMappings[hs.application.frontmostApplication():name()] ~= nil
end

function obj:register(hotkey, swallows, mappings)
    self.hotkey = hotkey
    self.swallows = swallows

    for appName, config in pairs(mappings) do
        self.appMappings[appName] = {modifiers = config.modifiers, key = config.key}
    end

    self.modTap:start()
    self.keyTap:start()
end

function obj:handleKeyPressedEvent()
    local currentTime = os.time()
    self.hotkeyTapCount = (currentTime - self.lastShiftTime > self.timeout) and 1 or self.hotkeyTapCount + 1
    self.lastShiftTime = currentTime

    if self.hotkeyTapCount == 1 then return end
    
    local n = #self.keyStrokes
    if n < 2 then return end
    if self.keyStrokes[n-1] ~= self.hotkey or self.keyStrokes[n] ~= self.hotkey then return end

    local mapping = self.appMappings[hs.application.frontmostApplication():name()]
    if mapping then
        hs.eventtap.keyStroke(mapping.modifiers, mapping.key)
    end
    
    self.hotkeyTapCount = 0
    self.keyStrokes:flush()
end

return obj