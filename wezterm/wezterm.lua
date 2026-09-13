local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- 렌더링
config.front_end = "WebGpu"

-- 컬러스킴
config.color_scheme = 'iTerm2 Light Background'

-- 창 설정
config.window_decorations = "RESIZE"
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }

-- 패널 분할과 이동 (AeroSpace의 Option 단축키와 구분)
local act = wezterm.action
-- Ctrl+Space를 누르고 뗀 뒤 2초 이내에 다음 키 입력
config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 2000 }
config.keys = {
  -- Vim의 :vsplit / :split처럼 v는 좌우, s는 상하 분할
  { key = 'v', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 's', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

  -- 리더 → h/j/k/l: 왼쪽/아래/위/오른쪽 패널로 이동
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
}

-- BEL 수신 시 macOS Glass 소리를 재생한다. 기본 벨과 중복 재생하지 않는다.
config.audible_bell = 'Disabled'
wezterm.on('bell', function(window, pane)
  wezterm.background_child_process {
    '/usr/bin/afplay', '/System/Library/Sounds/Glass.aiff',
  }
end)

return config
