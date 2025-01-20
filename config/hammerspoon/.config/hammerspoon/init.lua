hs = hs

-- Bind end key to output #
hs.hotkey.bind({}, "end", function()
    hs.eventtap.keyStrokes("#")
end)