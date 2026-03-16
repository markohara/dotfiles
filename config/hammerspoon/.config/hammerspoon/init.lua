hs = hs

hs.loadSpoon("ShiftIt")
hs.loadSpoon("Binder")

local binder = spoon.Binder
binder:register(
    {
        {{key = "end"}, {key = "#"}},
        {{modifiers = {"shift"}, key = "delete"}, {key = "forwarddelete"}}
    }
)


local shiftIt = spoon.ShiftIt
shiftIt:register(
    {
        Xcode = {modifiers = {"cmd", "shift"}, key = "o"},
        Cursor = {modifiers = {"cmd"}, key = "p"},
        Code = {modifiers = {"cmd"}, key = "p"},
        ["Microsoft Teams"] = {modifiers = {"cmd"}, key = "g"}
    }
)

-- Debug helper
--
-- hs.hotkey.bind({"cmd", "alt"}, "w", function()
--   local win = hs.window.focusedWindow()
--   if win then
--     print("Window title:", win:title())
--     print("Application:", win:application():name())
--   else
--     print("No focused window")
--   end
-- end)

hs.hotkey.bind({"cmd", "alt"}, "w", function()
  local win = hs.window.focusedWindow()
  if win then
    hs.alert.show("Window: " .. win:title() .. "\nApp: " .. win:application():name())
  else
    hs.alert.show("No focused window")
  end
end)

