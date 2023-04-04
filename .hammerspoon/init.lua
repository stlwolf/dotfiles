local double_press = require("ctrlDoublePress")

local open_wezterm = function()
    local appName = "wezTerm"
    hs.application.launchOrFocus(appName)
end

double_press.timeFrame = 0.5
double_press.action = open_wezterm
