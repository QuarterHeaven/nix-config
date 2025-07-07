hs.loadSpoon("SpoonInstall")

-- -----------------------------------------------------------------------
--                            ** Requires **                            --
-- -----------------------------------------------------------------------
-- require "window-management"
-- require "key-binding"

-- 修改 hs.alert 的默认风格
hs.alert.defaultStyle.textFont        = "Menlo"              -- 字体
hs.alert.defaultStyle.textSize        = 24                    -- 字号
hs.alert.defaultStyle.radius          = 8                     -- 圆角
hs.alert.defaultStyle.fillColor       = { red = 0, green = 0, blue = 0, alpha = 0.75 }  -- 背景色
hs.alert.defaultStyle.textColor       = { red = 1, green = 1, blue = 1, alpha = 1 }     -- 文本色
hs.alert.defaultStyle.strokeColor     = { red = 1, green = 1, blue = 1, alpha = 0.8 }   -- 边框色
hs.alert.defaultStyle.strokeWidth     = 2                     -- 边框宽度
hs.alert.defaultStyle.fadeInDuration  = 0.3                   -- 淡入时长
hs.alert.defaultStyle.fadeOutDuration = 0.3                   -- 淡出时长
hs.alert.defaultStyle.atScreenEdge    = 0.5                   -- 距离屏幕边缘的距离（0.5 居中）  [oai_citation:0‡hammerspoon.org](https://www.hammerspoon.org/docs/hs.alert.html?utm_source=chatgpt.com)

-- -----------------------------------------------------------------------
--                            ** For Debug **                           --
-- -----------------------------------------------------------------------
function reloadConfig(files)
  local doReload = false
  for _,file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    hs.reload()
    hs.alert.show('Config Reloaded')
  end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()

-- Well, sometimes auto-reload is not working, you know u.u
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "n", function()
  hs.reload()
  hs.alert.show("Config reloaded")
end)
hs.alert.show("Config loaded")

-- spoon.SpoonInstall.repos.PaperWM = {
-- 	url = "https://github.com/mogenson/PaperWM.spoon",
-- 	desc = "PaperWM.spoon repository",
-- 	branch = "main",
-- }

-- spoon.SpoonInstall.repos.ActiveSpace = {
-- 	url = "https://github.com/QuarterHeaven/ActiveSpace.spoon",
-- 	desc = "ActiveSpace.spoon repository",
--         branch = "main",
-- }

-- hammerspoonLogFile = assert(io.open('Hammerspoon.log','a'))
-- hammerspoonLogFile:setvbuf("line")

-- -- Override Hammerspoon's print with print that logs to file, not just HS console
-- -- See print() definition in https://github.com/Hammerspoon/hammerspoon/blob/master/extensions/_coresetup/init.lua
-- local old_print, tostring = print, tostring
-- local tconcat, pack = table.concat, table.pack
-- print = function(...)
--     local vals = pack(...)

--     for k = 1, vals.n do
--       vals[k] = tostring(vals[k])
--     end

--     local l = tconcat(vals, "\t")
--     hammerspoonLogFile:write(l, '\n')
--     return old_print(l)
-- end

-- spoon.SpoonInstall:updateAllRepos()

-- spoon.SpoonInstall:andUse("PaperWM", {
-- 	repo = "PaperWM",
-- 	config = {
-- 		screen_margin = 16,
-- 		window_gap = 10,
-- 		window_ratios = { 0.38195, 0.5, 0.61804 }
-- 	},
-- 	start = false,
-- 	hotkeys = {
--                 refresh_windows      = { { "alt", "shift" }, "r" },

-- 		-- switch to a new focused window in tiled grid
-- 		focus_left           = { { "alt" }, "h" },
-- 		focus_right          = { { "alt" }, "l" },
-- 		focus_up             = { { "alt" }, "k" },
-- 		focus_down           = { { "alt" }, "j" },

-- 		-- move windows around in tiled grid
-- 		swap_left            = { { "alt", "shift" }, "h" },
-- 		swap_right           = { { "alt", "shift" }, "l" },
-- 		swap_up              = { { "alt", "shift" }, "k" },
-- 		swap_down            = { { "alt", "shift" }, "j" },

-- 		-- position and resize focused window
-- 		center_window        = { { "alt" }, "c" },
-- 		full_width           = { { "alt" }, "f" },
-- 		cycle_width          = { { "alt" }, "r" },
-- 		reverse_cycle_width  = { { "ctrl", "alt" }, "r" },
-- 		cycle_height         = { { "alt", "shift" }, "r" },
-- 		reverse_cycle_height = { { "ctrl", "alt", "shift" }, "r" },

-- 		-- move focused window into / out of a column
-- 		slurp_in             = { { "alt" }, "i" },
-- 		barf_out             = { { "alt" }, "o" },

-- 		-- switch to a new Mission Control space
-- 		switch_space_l       = { { "alt" }, "," },
-- 		switch_space_r       = { { "alt" }, "." },
-- 		switch_space_1       = { { "alt" }, "1" },
-- 		switch_space_2       = { { "alt" }, "2" },
-- 		switch_space_3       = { { "alt" }, "3" },
-- 		switch_space_4       = { { "alt" }, "4" },
-- 		switch_space_5       = { { "alt" }, "5" },
-- 		switch_space_6       = { { "alt" }, "6" },
-- 		switch_space_7       = { { "alt" }, "7" },
-- 		switch_space_8       = { { "alt" }, "8" },
-- 		switch_space_9       = { { "alt" }, "9" },

-- 		-- move focused window to a new space and tile
-- 		move_window_1        = { { "cmd", "shift" }, "1" },
-- 		move_window_2        = { { "cmd", "shift" }, "2" },
-- 		move_window_3        = { { "cmd", "shift" }, "3" },
-- 		move_window_4        = { { "cmd", "shift" }, "4" },
-- 		move_window_5        = { { "cmd", "shift" }, "5" },
-- 		move_window_6        = { { "cmd", "shift" }, "6" },
-- 		move_window_7        = { { "cmd", "shift" }, "7" },
-- 		move_window_8        = { { "cmd", "shift" }, "8" },
-- 		move_window_9        = { { "cmd", "shift" }, "9" }
-- 	}
-- })

-- spoon.SpoonInstall:andUse("ActiveSpace", {
-- 	repo = "ActiveSpace",
-- 	start = false
-- })



-- use 4 fingers swipe to focus nearby window
-- local current_id, threshold
-- Swipe = hs.loadSpoon("Swipe")
-- Swipe:start(4, function(direction, distance, id)
-- 	if id == current_id then
-- 		if distance > threshold then
-- 			threshold = math.huge -- only trigger once per swipe

-- 			-- use "natural" scrolling
-- 			if direction == "left" then
-- 				PaperWM.actions.focus_right()
-- 			elseif direction == "right" then
-- 				PaperWM.actions.focus_left()
-- 			elseif direction == "up" then
-- 				PaperWM.actions.focus_down()
-- 			elseif direction == "down" then
-- 				PaperWM.actions.focus_up()
-- 			end
-- 		end
-- 	else
-- 	end
-- end)

super = {"ctrl", "alt", "cmd"}
hs.hotkey.bind({'cmd', 'ctrl'}, 't', function () hs.application.launchOrFocusByBundleID("com.mitchellh.ghostty") end)
-- hs.hotkey.bind({'cmd', 'ctrl'}, 't', function () hs.application.launchOrFocusByBundleID("net.kovidgoyal.kitty") end)
hs.hotkey.bind({'cmd'}, 'e', function () hs.application.launchOrFocusByBundleID("org.gnu.Emacs") end)
-- local aerospace = require("aerospace")

local manualSpoons = {
                     -- "WarpMouse"
                     -- "ScrollDesktop"
      }
local spoonInstallSpoons = {
                           -- "PaperWM",
                           -- "ActiveSpace"
      }

-- 手动安装的
for _, spoonName in ipairs(manualSpoons) do
    if spoonName and hs.fs.attributes(os.getenv("HOME") .. "/.hammerspoon/Spoons/" .. spoonName .. ".spoon") then
        hs.loadSpoon(spoonName)
        if spoon[spoonName] and spoon[spoonName].start then
            spoon[spoonName]:start()
        end
    else
        hs.alert.show("Missing Spoon: " .. spoonName)
    end
end

-- SpoonInstall 管理的
for _, spoonName in ipairs(spoonInstallSpoons) do
    spoon.SpoonInstall:andUse(spoonName, {
        start = true,
    })
end
