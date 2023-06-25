local double_press = require("ctrlDoublePress")
local toggle_quicktime = require("toggleQuickTime")
local scrollGoogleChrome = require("scrollGoogleChrome")

local open_wezterm = function()
    local appName = "wezTerm"
    hs.application.launchOrFocus(appName)
end

double_press.timeFrame = 0.5
double_press.action = open_wezterm

-- ショートカットキーの設定
hs.hotkey.bind({"ctrl", "cmd"}, "A", function()
    toggle_quicktime.toggleQuickTimePlayback()
end)

-- アプリケーションがアクティブな場合にのみ、キーバインドを有効にします。
function applicationWatcher(appName, eventType, appObject)
  if (appName == "Google Chrome") then
    if (eventType == hs.application.watcher.activated) then
      -- アプリがアクティブになったときに、キーバインドを有効にします。
      hs.hotkey.bind({"ctrl", "cmd"}, "K", scrollGoogleChrome.startScrolling)
    elseif (eventType == hs.application.watcher.deactivated) then
      -- アプリがアクティブでなくなったときに、スクロールを止めます。
      scrollGoogleChrome.stopScrolling()
    end
  end
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()
