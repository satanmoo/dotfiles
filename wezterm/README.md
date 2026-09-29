# WezTerm 설정

`~/.config/wezterm/wezterm.lua` → `wezterm/wezterm.lua` 심볼릭 링크. WezTerm은 `$WEZTERM_CONFIG_FILE`이 없으면 `~/.config/wezterm/wezterm.lua`와 `~/.wezterm.lua`를 찾으므로 `~/.wezterm.lua`는 두지 않는다. 저장하면 WezTerm이 설정을 자동으로 다시 읽는다.

```sh
mkdir -p ~/.config/wezterm
ln -s ~/dotfiles/wezterm/wezterm.lua ~/.config/wezterm/wezterm.lua
```

## 기본값과 다른 설정

기본값은 WezTerm `20240203-110809` 기준. 적은 것만 기본값과 다르고, 나머지(키 바인딩·벨·글꼴)는 기본값 그대로다.

- **`front_end = "WebGpu"`**: 기본값은 `OpenGL`이다(`20240127` 한 버전만 WebGpu가 기본이었고 `20240128`에 되돌아갔다). 지우면 렌더러가 OpenGL로 바뀐다.
- **`color_scheme = 'iTerm2 Light Background'`**: 밝은 테마. 기본은 WezTerm 자체의 어두운 색.
- **`window_decorations = "RESIZE"`**: 제목 표시줄을 없애고 크기 조절만 남긴다(기본 `"TITLE | RESIZE"`). AeroSpace가 창 배치를 맡으므로 제목 표시줄이 필요 없다.
- **`window_padding` 사방 8px**: 기본은 좌우 1칸·위아래 반 칸(글자 크기 기준).
