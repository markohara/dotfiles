--- === Binder ===
---
--- Simple key remapping DSL for Hammerspoon


local obj = {}
obj.__index = obj

function obj:init()
    return self
end

function obj:register(mappings)
    for _, mapping in ipairs(mappings) do
        local source, target = mapping[1], mapping[2]
        hs.hotkey.bind(source.modifiers or {}, source.key, function()
            hs.eventtap.keyStrokes(target.key)
        end)
    end

end

return obj
