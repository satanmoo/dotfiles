local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- 렌더링
config.front_end = "WebGpu"

-- 컬러스킴
config.color_scheme = 'iTerm2 Light Background'

-- 창 설정
config.window_decorations = "RESIZE"
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }

return config
