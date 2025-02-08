hs = hs

hs.loadSpoon("OpenQuickly")

-- Bind end key to output #
hs.hotkey.bind({}, "end", function()
    hs.eventtap.keyStrokes("#")
end)

-- Map Shift + Backspace to Delete
hs.hotkey.bind({'shift'}, 'delete', function()
    hs.eventtap.keyStroke({}, 'forwarddelete')
end)

spoon.OpenQuickly:start()