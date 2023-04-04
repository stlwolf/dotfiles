local double_press = require("ctrlDoublePress")

local open_alacritty = function()
    local appName = "wezTerm"
    local app = hs.application.get(appName)

    if app == nil or app:isHidden() or not(app:isFrontmost()) then
        hs.application.launchOrFocus(appName)
    else
        app:hide()
    end
end

double_press.timeFrame = 0.5
double_press.action = open_alacritty
