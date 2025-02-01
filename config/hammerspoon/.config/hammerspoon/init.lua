hs = hs

hs.loadSpoon("OpenQuickly")

-- Bind end key to output #
hs.hotkey.bind({}, "end", function()
    hs.eventtap.keyStrokes("#")
end)

spoon.OpenQuickly:start()