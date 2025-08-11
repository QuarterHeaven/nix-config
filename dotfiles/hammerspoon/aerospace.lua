-- aerospace.lua

local hs = hs
local hyper      = {"alt"}           -- i3 的 Alt
local hyperShift = {"alt", "shift"}  -- i3 的 Alt+Shift
local bash = function(cmd)
   -- -l 读登录 shell，-c 执行命令后退出
   return '/bin/bash -l -c \''..cmd..'\''
end

-- 把 zsh 当作登录 shell 来拿到正确的 PATH
local SHELL = "/bin/zsh"

-- 异步执行一条 shell 命令，执行完毕后回调
local function runShell(cmd, callback)
   -- -l: login，-c: 执行完退出
   local task = hs.task.new(
      SHELL,
      function(exitCode, stdout, stderr)
         callback(exitCode, stdout, stderr)
         return true -- 自动释放
      end,
      {"-lc", cmd}
   )
   task:start()
end

-- 通用的切换函数：direction 传 "next" 或 "prev"
local function switchWorkspace(direction)
   -- 第一步：异步获取当前聚焦在鼠标所在监视器上的工作区
   runShell("aerospace list-workspaces --monitor mouse --visible", function(exitCode, stdout, stderr)
               if exitCode ~= 0 or stdout == "" then
                  hs.alert.show("❌ 获取当前工作区失败:\n" .. (stderr or stdout))
                  return
               end
               -- 去掉可能的换行
               local ws = stdout:match("^%s*(.-)%s*$")

               -- 第二步：异步先切到当前工作区，再切到 next/prev
               runShell("aerospace workspace " .. ws .. " && aerospace workspace " .. direction, function(e2, o2, err2)
                           if e2 ~= 0 then
                              hs.alert.show("❌ 切换到 " .. direction .. " 失败:\n" .. (err2 or o2))
                              return
                           end
                           runShell("aerospace list-workspaces --monitor mouse --visible", function(exitCode, stdout, stderr)
                                       if exitCode ~= 0 or stdout == "" then
                                          hs.alert.show("❌ 获取当前工作区失败:\n" .. (stderr or stdout))
                                          return
                                       end
                                       -- 去掉可能的换行
                                       local ws2 = stdout:match("^%s*(.-)%s*$")
                                       
                                       hs.alert.show("当前工作区: " .. ws2)
                           end)
               end)
   end)
end

--------------------------------------------------------------------------------
-- Main Mode: focus, move, layouts, fullscreen, float toggle, reload
--------------------------------------------------------------------------------
hs.hotkey.bind(hyper, "H", function()
                  hs.execute("aerospace focus --boundaries-action wrap-around-the-workspace left", true)
end)
hs.hotkey.bind(hyper, "J", function()
                  hs.execute("aerospace focus --boundaries-action wrap-around-the-workspace down", true)
end)
hs.hotkey.bind(hyper, "K", function()
                  hs.execute("aerospace focus --boundaries-action wrap-around-the-workspace up", true)
end)
hs.hotkey.bind(hyper, "L", function()
                  hs.execute("aerospace focus --boundaries-action wrap-around-the-workspace right", true)
end)

hs.hotkey.bind(hyperShift, "H", function()
                  hs.execute("aerospace move left", true)
end)
hs.hotkey.bind(hyperShift, "J", function()
                  hs.execute("aerospace move down", true)
end)
hs.hotkey.bind(hyperShift, "K", function()
                  hs.execute("aerospace move up", true)
end)
hs.hotkey.bind(hyperShift, "L", function()
                  hs.execute("aerospace move right", true)
end)

hs.hotkey.bind(hyper, "F", function()
                  hs.execute("aerospace fullscreen", true)
end)

hs.hotkey.bind(hyper, "S", function()
                  hs.execute("aerospace layout v_accordion", true)
end)
hs.hotkey.bind(hyper, "W", function()
                  hs.execute("aerospace layout h_accordion", true)
end)
hs.hotkey.bind(hyper, "E", function()
                  hs.execute("aerospace layout tiles horizontal vertical", true)
end)

hs.hotkey.bind({"alt"}, "left", function()
      switchWorkspace("next")
end)

hs.hotkey.bind({"alt"}, "right", function()
      switchWorkspace("prev")
end)

hs.hotkey.bind(hyperShift, "space", function()
                  hs.execute("aerospace layout floating tiling", true)
end)

hs.hotkey.bind(hyperShift, "C", function()
                  hs.execute("aerospace reload-config", true)
end)

--------------------------------------------------------------------------------
-- Workspace 切换 & 窗口移动到指定 Workspace
--------------------------------------------------------------------------------
for i = 1, 10 do
   local idx = i
   local key = tostring(idx % 10)            -- "1","2",…,"9","0"
   local pad = "pad" .. key                   -- "pad1","pad2",…,"pad9","pad0"

   -- 主键盘上 Alt+key
   hs.hotkey.bind(hyper, key, function()
                     hs.execute("aerospace workspace " .. idx, true)
   end)
   -- 小键盘上 Alt+pad
   hs.hotkey.bind(hyper, pad, function()
                     hs.execute("aerospace workspace " .. idx, true)
   end)

   -- 主键盘上 Alt+Shift+key
   hs.hotkey.bind(hyperShift, key, function()
                     hs.execute("aerospace move-node-to-workspace " .. idx, true)
   end)
   -- 小键盘上 Alt+Shift+pad
   hs.hotkey.bind(hyperShift, pad, function()
                     hs.execute("aerospace move-node-to-workspace " .. idx, true)
   end)
end

--------------------------------------------------------------------------------
-- Resize Mode: Alt+R 进入，H/J/K/L 调整，Enter/Esc 退出
--------------------------------------------------------------------------------
local resizeMode = hs.hotkey.modal.new(hyper, "R")

resizeMode:enter(function()
      hs.alert.show("Resize Mode")
end)
resizeMode:exit(function()
      hs.alert.show("→ Main Mode")
end)

resizeMode:bind("", "H", function()
                   hs.execute("aerospace resize width -50", true)
end)
resizeMode:bind("", "J", function()
                   hs.execute("aerospace resize height +50", true)
end)
resizeMode:bind("", "K", function()
                   hs.execute("aerospace resize height -50", true)
end)
resizeMode:bind("", "L", function()
                   hs.execute("aerospace resize width +50", true)
end)
resizeMode:bind("", "return", function() resizeMode:exit() end)
resizeMode:bind("", "escape", function() resizeMode:exit() end)

--------------------------------------------------------------------------------
-- 窗口浮动
--------------------------------------------------------------------------------

-- 要管理的应用列表
local bundleIDs = {
   "com.tencent.xinWeChat",
   "com.tencent.qq"
}

local function isMain(win)
   local ax = hs.axuielement.windowElement(win)
   return ax:attributeValue("AXMain") == true
end

-- 统一的处理函数
-- 按照应用和标题决定浮动还是平铺
local function handle(win)
   local b = win:application():bundleID()
   local t = win:title() or ""
   local id = win:id()

   -- hs.alert.show("current window: " .. id)

   if b == "com.tencent.xinWeChat" then
      -- 微信：只有主聊天窗口平铺，其他浮动
      if t == "微信 (聊天)" then
         runShell(
            string.format("aerospace layout --window-id %d tiling", id),
            function(exit)
               -- if exit ~= 0 then hs.alert.show("❌ 平铺失败" .. exit) end
         end)
      end

   elseif b == "com.tencent.qq" then
      -- QQ：主窗口平铺，其他浮动
      if t == "QQ" then
         runShell(
            string.format("aerospace layout --window-id %d tiling", id),
            function(exit)
               -- if exit ~= 0 then hs.alert.show("❌ 平铺失败") end
         end)
      end

   end
end

-- 订阅两种事件
hs.window.filter.default
   :subscribe(hs.window.filter.windowFocused, function(win, appName)
                 -- 只在 QQ/WeChat 里才跑 handle
                 local app = win:application()
                 if not app then
                    return
                 end
                 local b = app:bundleID()
                 if b == "com.tencent.xinWeChat" or b == "com.tencent.qq" then
                    handle(win)
                 end
             end)

--------------------------------------------------------------------------------
-- 加载完毕提示
--------------------------------------------------------------------------------
hs.alert.show
("AeroSpace config loaded")
