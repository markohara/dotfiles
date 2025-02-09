hs = hs

hs.loadSpoon("ShiftIt")

-- Bind end key to output #
hs.hotkey.bind({}, "end", function()
    hs.eventtap.keyStrokes("#")
end)

-- Map Shift + Backspace to Delete
hs.hotkey.bind({'shift'}, 'delete', function()
    hs.eventtap.keyStroke({}, 'forwarddelete')
end)

local shiftIt = spoon.ShiftIt

shiftIt:register(
    {
        Xcode = {modifiers = {"cmd", "shift"}, key = "o"},
        Cursor = {modifiers = {"cmd"}, key = "p"}
    }
)