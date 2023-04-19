local double_press = require("ctrlDoublePress")
local toggle_quicktime = require("toggleQuickTime")

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
