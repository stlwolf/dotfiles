local toggle_quicktime = {}

function toggle_quicktime.toggleQuickTimePlayback()
    hs.notify.new({title="Hammerspoon", informativeText="toggleQuickTimePlayback called"}):send()
    local script = [[
        if application "QuickTime Player" is running then
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
        end if
    ]]
    local _, _, stderr = hs.osascript.applescript(script)
    if stderr and (type(stderr) == "string") and (string.len(stderr) > 0) then
        hs.notify.new({title="Hammerspoon", informativeText="QuickTime Playback Toggle Error: " .. stderr}):send()
    end
end

return toggle_quicktime
