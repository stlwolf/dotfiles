local scrollTimer = nil
local scrollInterval = 0.045
local scrollSpeed = -3
local speedMultiplier = 2
local scrollState = 0 -- 0: stopped, 1: normal speed, 2: double speed

-- スクロールする関数を定義します。
local function autoScroll()
  local scrollEvent = hs.eventtap.event.newScrollEvent({0, scrollSpeed}, {} , 'pixel')
  scrollEvent:post()
end

-- スクロールを始めるときに呼ばれます。
local function startScrolling()
  -- スクロール状態に基づいて挙動を変えます。
  if scrollState == 0 then
    scrollTimer = hs.timer.doEvery(scrollInterval, autoScroll)
    scrollState = 1
  elseif scrollState == 1 then
    scrollTimer:stop()
    scrollTimer = hs.timer.doEvery(scrollInterval/speedMultiplier, autoScroll)
    scrollState = 2
  else
    scrollTimer:stop()
    scrollTimer = nil
    scrollState = 0
  end
end

-- スクロールを停止する関数を定義します。
local function stopScrolling()
  if scrollTimer then
    scrollTimer:stop()
    scrollTimer = nil
    scrollState = 0
  end
end

return {
    startScrolling = startScrolling,
    stopScrolling = stopScrolling
}
