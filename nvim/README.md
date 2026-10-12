# Neovim 설정

`~/.config/nvim/init.vim` → `nvim/init.vim` 심볼릭 링크.

```sh
mkdir -p ~/.config/nvim
ln -s ~/dotfiles/nvim/init.vim ~/.config/nvim/init.vim
```

## 입력 모드를 나가면 영문 자판

- **`InsertLeave` → `macism com.apple.keylayout.ABC`**: 한글로 쓰다 Esc를 누르면 한글 자판이 그대로 남아 노멀 모드 단축키(`j`, `dd`, `:` …)가 `ㅓ`, `ㅇㅇ`처럼 들어간다. 입력 모드를 떠날 때 ABC로 바꾼다. 입력 모드로 돌아와도 한글로 되돌리지는 않는다.
- **macism**: `brew install laishulu/homebrew/macism`(Brewfile). `im-select`는 한글 같은 CJK 입력기에서 ABC로 바꿀 때 메뉴 막대만 바뀌고 실제 입력은 그대로인 경우가 있어 macism을 쓴다. 영문 자판 ID는 `macism`을 인자 없이 실행해 확인한다(ABC가 아니라 U.S. 자판이면 `com.apple.keylayout.US`).
- `jobstart`로 비동기 실행해 Esc가 늦어지지 않는다. macism이 없는 기계에서는 이 줄을 건너뛴다.
