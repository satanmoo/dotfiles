# dotfiles

satanmoo의 맥 공통 설정. 개인 맥북과 회사 맥북이 같은 저장소를 쓰고, 기계마다 다른 값은 저장소 밖 `*.local` 파일에 둔다.

**사람 계정 전용**: 사람이 앞에 있어 Touch ID·로그인 키체인을 쓸 수 있는 계정에만 적용한다. 무인 실행은 작업기의 전용 OS 계정(회사 맥북 `sigmastudio-bot`)에서 돌고 이 설정을 쓰지 않는다 — 그 계정의 설정은 dev-environment `engine/README.md` 「무인 계정」. 설정마다 **왜 이렇게 했는지**는 각 폴더 README에 있다.

| 폴더 | 적용 위치 | 방식 |
| --- | --- | --- |
| `git/` | `~/.gitconfig`, `~/.gitignore-global` | 심볼릭 링크 + `~/.gitconfig-local` |
| `ssh/` | `~/.ssh/config` | 심볼릭 링크 + `~/.ssh/config.local` |
| `zsh/` | `~/.zshenv`, `~/.zprofile`, `~/.zshrc`, `~/.p10k.zsh` | 심볼릭 링크 + `~/.zshenv.local`, `~/.zprofile.local`, `~/.zshrc.local` |
| `aerospace/` | `~/.aerospace.toml` | 심볼릭 링크 |
| `wezterm/` | `~/.config/wezterm/wezterm.lua` | 심볼릭 링크 |
| `nvim/` | `~/.config/nvim` (폴더) | 심볼릭 링크 |
| `uv/` | `~/.config/uv/uv.toml`, uv tool 도구 | 심볼릭 링크 + `uv/tools.txt` 목록으로 설치 |
| `cursor/` | `~/Library/Application Support/Cursor/User/settings.json`, Cursor 확장 | 심볼릭 링크 + `cursor/extensions.txt` 목록으로 설치 |
| `alt-tab/` | AltTab 설정 | 설정 창 Import (링크 불가) |

`Brewfile`은 이 설정들이 쓰는 도구만 담는다. 기계마다 다른 앱은 넣지 않는다.

## 새 맥에 적용

1. Homebrew 설치 후 도구 설치:
   ```sh
   git clone git@github.com:satanmoo/dotfiles.git ~/dotfiles   # SSH 전이면 HTTPS로 받고 나중에 바꾼다
   brew bundle --file ~/dotfiles/Brewfile
   grep -v -e '^#' -e '^$' ~/dotfiles/uv/tools.txt | xargs -n1 uv tool install
   ```
2. 링크. 이미 파일이 있으면 내용을 비교해 필요한 값을 옮긴 뒤 지운다(덮어쓰지 않는다).
   ```sh
   ln -s ~/dotfiles/git/gitconfig ~/.gitconfig
   ln -s ~/dotfiles/git/gitignore-global ~/.gitignore-global
   ln -s ~/dotfiles/ssh/config ~/.ssh/config
   ln -s ~/dotfiles/zsh/zshenv ~/.zshenv
   ln -s ~/dotfiles/zsh/zprofile ~/.zprofile
   ln -s ~/dotfiles/zsh/zshrc ~/.zshrc
   ln -s ~/dotfiles/zsh/p10k.zsh ~/.p10k.zsh
   ln -s ~/dotfiles/aerospace/aerospace.toml ~/.aerospace.toml
   mkdir -p ~/.config/wezterm && ln -s ~/dotfiles/wezterm/wezterm.lua ~/.config/wezterm/wezterm.lua
   ln -s ~/dotfiles/nvim ~/.config/nvim
   mkdir -p ~/.config/uv && ln -s ~/dotfiles/uv/uv.toml ~/.config/uv/uv.toml
   ```
3. 기계 값: `git/gitconfig-local.example` → `~/.gitconfig-local`, `ssh/config.local.example` → `~/.ssh/config.local`(`chmod 600`), 필요하면 `zsh/*.local.example` → `~/.zshenv.local`·`~/.zprofile.local`·`~/.zshrc.local`. Secretive에 이 기계 키를 만들고 GitHub·`~/.gitallowedsigners`에 등록한다(`git/README.md`, `ssh/README.md`).
4. AltTab: 설정 창 General → Import settings… → `alt-tab/alt-tab-config.plist`.
5. AeroSpace를 한 번 실행한다. `start-at-login = true`라 이후 로그인 때 스스로 뜬다.
6. Cursor를 한 번 실행해 설정 폴더를 만든 뒤 링크·확장·키 반복을 설정한다(`cursor/README.md`).

## 고칠 때

- 링크된 파일은 이 저장소에서 고치고 커밋한다. 다른 맥은 `git -C ~/dotfiles pull`로 받는다(링크라 pull만으로 적용된다).
- AltTab은 설정 창에서 바꾼 뒤 Export settings…로 `alt-tab/alt-tab-config.plist`를 덮어쓰고 커밋한다.
- Cursor 설정 창에서 바꾼 값은 링크된 `cursor/settings.json`에 바로 들어가니 커밋만 한다. 확장을 바꿨으면 `cursor/extensions.txt`를 직접 고친다(`cursor/README.md`).
- 커밋은 서명된다(Secretive). SecretAgent가 꺼져 있으면 커밋이 실패하니 Secretive를 연다.
