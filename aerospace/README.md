# AeroSpace 설정

`~/.aerospace.toml` → `aerospace/aerospace.toml` 심볼릭 링크. AeroSpace는 `~/.aerospace.toml`과 `~/.config/aerospace/aerospace.toml`만 읽으므로(둘 다 있으면 오류) 링크는 하나만 둔다. 적용 중인 파일은 `aerospace config --config-path`로 확인한다.

```sh
ln -s ~/dotfiles/aerospace/aerospace.toml ~/.aerospace.toml
aerospace reload-config
```

## 로그인 시 실행

- **`start-at-login = true`**: 재부팅 후에도 타일링이 바로 돌게 한다. 설정을 읽을 때 AeroSpace가 macOS 로그인 항목에 스스로 등록한다(`sfltool dumpbtm`에 `bobko.aerospace` enabled). 이 파일을 pull하는 모든 맥에 적용된다.

## 단축키

- 모든 바인딩은 `alt`(⌥) 조합이다. `⌘` 조합은 macOS·앱 몫으로 비워 둔다.
- **`alt-tab` = `workspace-back-and-forth`**, **`alt-shift-tab` = `move-workspace-to-monitor`**.
- **`alt-[` / `alt-]`**: 지금 모니터에서 창이 있는 워크스페이스만 이전/다음으로 순환. `exec-and-forget`은 PATH가 없으므로 `aerospace`를 절대 경로(Apple Silicon `/opt/homebrew/bin/aerospace`)로 쓴다.

## AltTab과 함께 쓰기

AltTab(창 단위 전환기, 크롬 프로필 창 구분용)의 기본 트리거 `⌥⇥`는 위 `alt-tab`·`alt-shift-tab`과 겹친다. AeroSpace 쪽을 그대로 두고 **AltTab Shortcut 1을 `⌘⇥`로** 바꿔 macOS 앱 전환기를 대체한다(2026-09-29 개인 맥북).

- AltTab 단축키는 설정 창에서 바꾼다. 11.x는 단축키를 문자열 + 아카이브 데이터 사전으로 저장하므로 `defaults write`로 문자열만 넣으면 실행 시 지워진다. 옮길 때는 설정 창의 Export/Import settings를 쓴다.
- Shortcut 2(Pro 기능)는 쓰지 않는다. 같은 앱 창 순환은 macOS 기본 `` ⌘` ``.
- AeroSpace 워크스페이스는 모두 macOS Space 하나 안에 있으므로 AltTab의 "Show windows from Spaces"로는 워크스페이스를 가를 수 없다. All Spaces로 둔다. 다른 워크스페이스의 창을 고르면 AeroSpace가 그 워크스페이스로 넘어간다.
