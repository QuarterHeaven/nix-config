local wm = require('window-management')
local hk = require "hs.hotkey"

-- * Key Binding Utility
--- Bind hotkey for window management.
-- @function windowBind
-- @param {table} hyper - hyper key set
-- @param { ...{key=value} } keyFuncTable - multiple hotkey and function pairs
--   @key {string} hotkey
--   @value {function} callback function
local function windowBind(hyper, keyFuncTable)
  for key,fn in pairs(keyFuncTable) do
    hk.bind(hyper, key, fn)
  end
end

-- * Move window to screen
windowBind({"ctrl", "alt"}, {
  h = wm.throwLeft,
  l = wm.throwRight
})

-- * Set Window Position on screen
windowBind({"alt"}, {
  m = wm.maximizeWindow,
  c = wm.centerOnScreen,
  h = wm.leftHalf,
  l = wm.rightHalf,
  k = wm.topHalf,
  j = wm.bottomHalf,
  u = wm.cycleLeft,
  i = wm.cycleRight
})
-- * Set Window Position on screen
windowBind({"alt", "shift"}, {
  h = wm.rightToLeft,      -- ⌃⌥⇧ + ←
  l = wm.rightToRight,    -- ⌃⌥⇧ + →
  k = wm.bottomUp,           -- ⌃⌥⇧ + ↑
  j = wm.bottomDown        -- ⌃⌥⇧ + ↓
})