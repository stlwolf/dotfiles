local wezterm = require 'wezterm'
local act = wezterm.action

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.default_cwd = ''

config.color_scheme = 'iceberg-dark'
config.window_background_opacity = 0.8

config.font = wezterm.font('Rounded-X Mgen+ 1mn', {weight='Medium', stretch='Normal', style='Normal'})
config.font_size = 18.0

config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = 'RESIZE'
config.initial_cols = 180
config.initial_rows = 50
-- config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

config.adjust_window_size_when_changing_font_size = false
config.use_fancy_tab_bar = false

config.scrollback_lines = 8192
config.enable_scroll_bar = true

-- Cmd キーで tmux の mouse reporting をバイパスする
config.bypass_mouse_reporting_modifiers = 'SUPER'

-- https://zenn.dev/link/comments/7e0e1d3d8619dc
function random_color_scheme()
  math.randomseed(os.time())
  local schemes = {
    'iceberg-dark',
    'Iiamblack (terminal.sexy)',
    'Material (Gogh)',
    'Mellow Purple (base16)',
    'nord',
  }
  local i = math.random(#schemes)
  return schemes[i]
end

function random_background_image()
  local image_dir = ''
  local cmd = 'find "' .. image_dir .. '" -type f \\( -name "*.png" -o -name "*.jpg" -o -name "*.gif" \\)'
  local images = {}

  local f = io.popen(cmd)
  if f then
    for file in f:lines() do
      table.insert(images, file)
    end
    f:close()
  end

  if #images > 0 then
    math.randomseed(os.time())
    local i = math.random(#images)
    return images[i]
  end

  return nil
end

wezterm.on('random-color-scheme', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  scheme = random_color_scheme()
  overrides.color_scheme = scheme
  window:set_config_overrides(overrides)
end)

wezterm.on('random-background-image', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local image = random_background_image()
  if image then
    overrides.window_background_image = image
    window:set_config_overrides(overrides)
  end
end)

-- Cmd+Click で URL を開く（tmux mouse mode でも動作）
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'SUPER',
    action = act.OpenLinkAtMouseCursor,
  },
}

-- クリッカブル md ビューア連携（hub #210）:
-- ターミナル出力中に現れる生成 doc(md) の絶対パスを Cmd+Click でクリッカブルにする。
-- 既定規則(https / mailto 等)を消さずベースにし、oeview スキームの規則を table.insert で追加する。
-- クリックの横取りは下部の 'open-uri' ハンドラが担当（oe-view を起動）。
config.hyperlink_rules = wezterm.default_hyperlink_rules()
table.insert(config.hyperlink_rules, {
  -- $HOME 配下の絶対パス .md を広く対象にする（dir 構造で絞らない・空白なしパス前提）。
  -- md→glow は read-only。安全弁は oe-view 側（非md拒否・realpath・$HOME allowlist）に集約。
  regex = [[/Users/eddy/\S+\.md]],
  -- $0 はマッチ全体(= /Users/... の絶対パス)。結果は oeview:///Users/... （三スラッシュ）になる。
  format = 'oeview://$0',
})

config.keys = {
  { key = 'f', mods = 'CTRL|CMD', action = wezterm.action.ToggleFullScreen },
  { key = 'A', mods = 'CTRL', action = wezterm.action.EmitEvent 'random-color-scheme' },
  { key = 'V', mods = 'CTRL', action = wezterm.action.EmitEvent 'random-background-image' },
  { key = 'R', mods = 'CMD|SHIFT', action = act.ClearScrollback 'ScrollbackAndViewport' },
--   { key = 'UpArrow', mods = 'SHIFT', action = act.ScrollToPrompt(-1) },
--   { key = 'DownArrow', mods = 'SHIFT', action = act.ScrollToPrompt(1) },
}

local BG_INTERVAL = 60
local last_bg_switch = {}

wezterm.on('update-right-status', function(window, pane)
  local now = os.time()
  local id = window:window_id()
  local last = last_bg_switch[id] or 0
  if now - last >= BG_INTERVAL then
    last_bg_switch[id] = now
    local overrides = window:get_config_overrides() or {}
    local image = random_background_image()
    if image then
      overrides.window_background_image = image
      window:set_config_overrides(overrides)
    end
  end
end)

config.window_background_image = random_background_image()

config.window_background_image_hsb = {
  -- Darken the background image by reducing it to 1/3rd
  brightness = 0.15,

  -- You can adjust the hue by scaling its value.
  -- a multiplier of 1.0 leaves the value unchanged.
  hue = 1.0,

  -- You can adjust the saturation also.
  saturation = 1.0,
}

-- AI Mode: shell から user-var (OSC 1337 SetUserVar) を受けて toast 通知を出す
wezterm.on('user-var-changed', function(window, pane, name, value)
  if name == 'ai_notify' then
    local decoded = value
    local title, body, timeout_str = decoded:match('^([^|]*)|([^|]*)|([^|]*)$')
    if not title then
      -- パイプ区切りでない値（将来のフォーマット変更や手動送信）は生値を title に
      title, body, timeout_str = decoded, '', nil
    end
    title = (title and title ~= '') and title or 'AI Mode'
    body = body or ''
    local timeout = tonumber(timeout_str) or 4000

    local message = (body ~= '') and (title .. ': ' .. body) or title
    window:toast_notification('WezTerm AI', message, nil, timeout)
    wezterm.log_info('ai_notify: ' .. title .. ' - ' .. body)
  elseif name == 'ai_status' then
    wezterm.log_info('ai_status: ' .. value)
  end
end)

-- クリッカブル md ビューア連携（hub #210）: oeview:// リンクのクリックを横取りして oe-view を起動する。
-- 種別/allowlist/存在チェック・サニタイズは oe-view 側の責務。ここは parse と argv 起動のみ。
local OE_VIEW =
  '/Users/eddy/work/repos/github.com/stlwolf/ai-development-hub/projects/orchestration-engine/bin/oe-view'

wezterm.on('open-uri', function(window, pane, uri)
  local prefix = 'oeview://'
  if uri:sub(1, #prefix) ~= prefix then
    return -- oeview: 以外は既定動作（https 等はブラウザで開く）
  end

  -- 接頭辞を除去して絶対パスを取り出す（oeview:///Users/... → /Users/...）
  local path = uri:sub(#prefix + 1)
  -- パスに %XX のパーセントエンコードが含まれていれば復号（空白なしパスでは実質 no-op）
  path = path:gsub('%%(%x%x)', function(hex)
    return string.char(tonumber(hex, 16))
  end)

  -- oe-view は絶対パスで呼ぶ。さらに oe-view が内部で引く wez/glow は PATH 依存のため、GUI の
  -- 最小 PATH（~/bin・homebrew を含まない）では見つからず oe-view が exit 2 で無音になる（#210）。
  -- /usr/bin/env で PATH を補ってから oe-view を exec する（path は単一 argv 要素・shell 非経由）。
  local home = os.getenv('HOME') or ''
  local ok, err = pcall(function()
    wezterm.background_child_process {
      '/usr/bin/env',
      'PATH=' .. home .. '/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin',
      OE_VIEW, '--from-link', path,
    }
  end)
  if not ok then
    -- oe-view 不在(PR1 未マージ)や起動失敗でも Lua をクラッシュさせず、ログに残して静かに分かるようにする。
    wezterm.log_error('oeview: failed to launch oe-view: ' .. tostring(err))
  end

  return false -- ブラウザ等の既定動作を抑止する
end)

return config
