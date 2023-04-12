local double_press = require("ctrlDoublePress")

local open_wezterm = function()
    local appName = "wezTerm"
    hs.application.launchOrFocus(appName)
end

double_press.timeFrame = 0.5
double_press.action = open_wezterm

-- QuickTimeウィンドウの再生/一時停止をトグル
function toggleQuickTimePlayback()
    hs.notify.new({title="Hammerspoon", informativeText="toggleQuickTimePlayback called"}):send()
    local script = [[
        tell application "QuickTime Player"
            set allDocs to every document
            if (count of allDocs) > 0 then
                repeat with eachDoc in allDocs
                    if (playing of eachDoc) is true then
                        pause eachDoc
                    else
                        play eachDoc
                    end if
                end repeat
            end if
        end tell
    ]]
    local _, _, stderr = hs.osascript.applescript(script)
    if stderr and (type(stderr) == "string") and (string.len(stderr) > 0) then
        hs.notify.new({title="Hammerspoon", informativeText="QuickTime Playback Toggle Error: " .. stderr}):send()
    end
end

-- ショートカットキーの設定
hs.hotkey.bind({"ctrl", "alt"}, "P", toggleQuickTimePlayback)

