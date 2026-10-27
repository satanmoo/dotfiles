# Cursor 설정

`~/Library/Application Support/Cursor/User/settings.json` → `cursor/settings.json` 심볼릭 링크. 확장은 `cursor/extensions.txt` 목록으로 설치한다. Cursor의 AI 설정(모델, 규칙 등)은 `settings.json`이 아니라 Cursor 계정과 앱 내부에 저장되므로 여기 없다.

## 새 맥에 적용

1. **설치**: `brew bundle --file ~/dotfiles/Brewfile`이 Cursor 앱과 `cursor` 명령(`/opt/homebrew/bin/cursor`)을 깐다. vscode-neovim이 쓰는 nvim도 같은 Brewfile에 있다.
2. **Cursor를 한 번 실행했다가 ⌘Q로 끈다**: 그래야 `~/Library/Application Support/Cursor/User/` 폴더가 생긴다. 실행 중에 링크를 바꾸면 Cursor가 열 때 읽은 값으로 덮어쓸 수 있으니 끈 상태에서 한다.
3. **기존 설정 옮기기**: 이미 쓰던 `settings.json`이 있으면 `cursor/settings.json`과 비교해 남길 값을 옮긴다(덮어쓰지 않는다).
   ```sh
   diff ~/Library/Application\ Support/Cursor/User/settings.json ~/dotfiles/cursor/settings.json
   ```
4. **링크·확장·키 반복**:
   ```sh
   rm ~/Library/Application\ Support/Cursor/User/settings.json
   ln -s ~/dotfiles/cursor/settings.json ~/Library/Application\ Support/Cursor/User/settings.json
   grep -v -e '^#' -e '^$' ~/dotfiles/cursor/extensions.txt | xargs -n1 cursor --install-extension
   defaults write com.todesktop.230313mzl4w4u92 ApplePressAndHoldEnabled -bool false
   ```
5. **Cursor를 다시 실행한다**: 키 반복 설정은 재시작해야 적용된다.

## 확인

- **링크**: `ls -l ~/Library/Application\ Support/Cursor/User/settings.json`이 `-> /Users/<사용자>/dotfiles/cursor/settings.json`으로 나온다.
- **vim 키**: 파일을 열고 Esc → `j`를 누르고 있으면 커서가 계속 내려간다. `dd`, `u`, `.` 같은 nvim 명령이 그대로 먹는다.
- **설정 창에 써도 링크가 남는지**: 설정 창(⌘,)에서 값 하나를 바꿨다 되돌린 뒤 위 `ls -l`이 여전히 링크다. Cursor는 링크를 따라가 이 파일에 직접 쓴다(2026-10-27 회사 맥북 Cursor 3.27에서 확인).

## 고칠 때

- **설정**: 설정 창에서 바꾸면 이 저장소의 `cursor/settings.json`이 바로 바뀐다. `git -C ~/dotfiles diff`로 보고 커밋한다. 다른 맥은 pull만 하면 된다(링크).
- **확장**: Cursor에서 확장을 깔거나 지우면 목록 파일은 바뀌지 않는다. `extensions.txt`에 직접 더하거나 빼고 커밋한다. 실제 설치 목록은 `cursor --list-extensions`로 본다(`anysphere.*`처럼 Cursor가 기본으로 넣은 확장은 목록에 적지 않는다). 다른 맥은 pull 뒤 위 설치 명령을 다시 실행한다.

## settings.json

- **`vscode-neovim.neovimExecutablePaths.darwin` = `/opt/homebrew/bin/nvim`**: vscode-neovim이 띄울 nvim. Homebrew nvim(Brewfile)을 쓴다. Apple Silicon Homebrew 경로라 모든 맥에서 같다.
- **`extensions.experimental.affinity`의 vscode-neovim = 1**: vscode-neovim을 다른 확장과 다른 확장 호스트 프로세스에서 돌린다. 다른 확장이 바쁠 때 키 입력이 늦어지지 않게 하는 vscode-neovim 권장 설정이다.
- **`window.autoDetectColorScheme`**: macOS의 밝은·어두운 모드를 따라 테마를 바꾼다.
- **`cursor.composer.queueMessageDefaultBehavior`, `cursor.composer.queueManualSendBehavior2` = `"steer"`**: 에이전트가 일하는 중에 보낸 메시지를 대기열에 쌓지 않고 진행 중인 실행에 바로 넣어 방향을 바꾼다.

## 확장: extensions.txt

Cursor에는 확장 목록 파일 기능이 없어 목록 파일로 대신한다(`../uv/tools.txt`와 같은 방식). 한 줄에 하나씩 적고, 설명은 그 위 줄에 `#`로 쓴다.

- **vscode-neovim**: Cursor에서 vim 키를 쓴다. 흉내 내는 VSCodeVim과 달리 화면 없는 실제 nvim을 띄워 키를 처리하므로 nvim과 똑같이 동작하고, `~/.config/nvim/init.lua`(`../nvim/`)를 그대로 읽는다. 그 안에서는 `vim.g.vscode`가 켜지므로 `init.lua`가 테마처럼 화면에 관한 설정을 건너뛴다.

## 키 반복: ApplePressAndHoldEnabled

macOS는 키를 길게 누르면 반복 입력 대신 악센트 문자 선택 창을 띄운다. 그러면 `j`를 누르고 있어도 커서가 계속 내려가지 않는다. 위 `defaults write`로 Cursor 앱(번들 ID `com.todesktop.230313mzl4w4u92`)에서만 끈다. Cursor를 다시 시작해야 적용된다. 링크로 넣을 수 없는 macOS 설정이라 새 맥에서 한 번 실행한다.
