hs = hs

hs.loadSpoon("ShiftIt")
hs.loadSpoon("Binder")

local binder = spoon.Binder
binder:register(
    {
        {{key = "end"}, {key = "#"}},
        -- {{modifiers = {"shift"}, key = "delete"}, {key = "forwarddelete"}}
    }
)


local shiftIt = spoon.ShiftIt
shiftIt:register(
    "f9",
    true,
    {
        Xcode = {modifiers = {"cmd", "shift"}, key = "o"},
        Cursor = {modifiers = {"cmd"}, key = "p"},
        ["Microsoft Teams"] = {modifiers = {"cmd"}, key = "e"}
    }
)
