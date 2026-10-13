# Neovim 설정

`~/.config/nvim` → `nvim/` 폴더 심볼릭 링크. 처음엔 `init.lua` 파일만 링크했지만, `vim.pack`이 같은 폴더에 쓰는 잠금 파일(`nvim-pack-lock.json`)도 저장소에 넣으려고 2026-10-13에 폴더째 링크로 바꿨다. `init.vim`은 두지 않는다(`init.lua`와 둘 다 있으면 E5422).

```sh
ln -s ~/dotfiles/nvim ~/.config/nvim
```

## 기본 옵션

- **`tabstop`·`shiftwidth` 4, `expandtab`**: 탭 대신 공백 4칸.
- **`number`**: 라인 번호.
- **`clipboard = 'unnamedplus'`**: `y`·`p`가 nvim 내부 레지스터가 아니라 macOS 클립보드(pbcopy/pbpaste)를 쓴다. 다른 앱에 바로 붙여 넣을 수 있다. SSH 너머 작업기에서 nvim을 쓰면 pbcopy가 로컬 맥에 닿지 않는다. OSC 52(nvim 내장 `vim.ui.clipboard.osc52`)는 아직 설정하지 않았다.

## 색 테마: github-nvim-theme

- **`github_light_default`**: GitHub 웹의 밝은 코드 색. 기본 테마는 키워드(`def`, `for`, `return`)에 색이 없어 읽기 어려웠다. WezTerm도 밝은 테마(`iTerm2 Light Background`)라 밝은 쪽을 골랐다. 같은 플러그인에 `github_light`(예전 GitHub 색), `github_light_high_contrast`, `github_dark_default` 등이 있어 `:colorscheme <Tab>`으로 바로 바꿔 볼 수 있다.
- **설치는 nvim 0.12 내장 `vim.pack`**: 플러그인 관리자를 따로 깔지 않는다. 플러그인은 `~/.local/share/nvim/site/pack/core/opt/`에 받고, 받은 커밋은 `nvim-pack-lock.json`에 적힌다. 다른 맥은 pull 후 nvim을 처음 열 때 설치 여부를 묻고, 잠금 파일의 커밋 그대로 받는다.
- **업데이트**: `:lua vim.pack.update()` → 바뀐 내용을 보고 `:write`로 확정(`:quit`은 취소) → `nvim-pack-lock.json`을 커밋한다.
- 플러그인 저장소의 마지막 커밋은 2024-12다. 동작은 하지만 새 nvim 기능을 따라오지 못하면 다른 테마로 바꾼다.

## 입력 모드를 나가면 영문 자판

- **`InsertLeave` → `macism com.apple.keylayout.ABC`**: 한글로 쓰다 Esc를 누르면 한글 자판이 그대로 남아 노멀 모드 단축키(`j`, `dd`, `:` …)가 `ㅓ`, `ㅇㅇ`처럼 들어간다. 입력 모드를 떠날 때 ABC로 바꾼다. 입력 모드로 돌아와도 한글로 되돌리지는 않는다.
- **macism**: `brew install laishulu/homebrew/macism`(Brewfile). `im-select`는 한글 같은 CJK 입력기에서 ABC로 바꿀 때 메뉴 막대만 바뀌고 실제 입력은 그대로인 경우가 있어 macism을 쓴다. 영문 자판 ID는 `macism`을 인자 없이 실행해 확인한다(ABC가 아니라 U.S. 자판이면 `com.apple.keylayout.US`).
- `vim.system`으로 비동기 실행해 Esc가 늦어지지 않는다. macism이 없는 기계에서는 이 부분을 건너뛴다.

## Python 언어 서버: Pyrefly

- **설치**: `uv tool install pyrefly`(`../uv/tools.txt`). 실행 파일은 `~/.local/bin`에 생기고, `zsh/zprofile`이 이 폴더를 PATH에 넣는다. pyrefly가 없는 기계에서는 이 부분을 건너뛴다.
- **플러그인 없이 연결**: nvim 0.11+의 `vim.lsp.config`·`vim.lsp.enable`을 쓴다. 값은 nvim-lspconfig의 `lsp/pyrefly.lua`를 옮겼다. 프로젝트 루트는 `pyproject.toml`·`.git` 등이 있는 가장 가까운 폴더다.
- **고른 이유**: 2026-10에 ty(Astral)와 비교했다. 둘 다 Rust라 빠르지만 Pyrefly는 1.x 안정판이고 ty는 아직 베타다. ty가 stable이 되면 다시 검토한다([#3](https://github.com/satanmoo/dotfiles/issues/3)).
- **ty로 바꾸려면**: `cmd = { 'ty', 'server' }`, root_markers의 `pyrefly.toml` → `ty.toml`, `vim.lsp.enable('ty')`. `uv/tools.txt`도 바꾼다.

LSP가 붙으면 nvim 기본 키로 쓴다(따로 매핑하지 않았다).

| 동작 | 키 |
| --- | --- |
| 정의로 이동 | `Ctrl-]`, Ctrl+클릭 |
| 뒤로 / 앞으로 | `Ctrl-o` / `Ctrl-i` (Ctrl+우클릭도 뒤로) |
| 사용처 (quickfix 목록) | `grr` |
| 구현으로 이동 | `gri` |
| 이름 바꾸기 | `grn` |
| 코드 액션 | `gra` |
| 문서 보기 | `K` |
| 파일 심볼 목록 | `gO` |

- 기본 `gd`는 LSP가 아니라 같은 파일 안에서 글자로 찾는다.
- 터미널은 ⌘ 키를 nvim에 넘기지 못하므로 IntelliJ의 ⌘+클릭은 쓸 수 없다. 붙었는지는 `:checkhealth vim.lsp`로 본다.
