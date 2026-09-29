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

AltTab의 기본 트리거 `⌥⇥`는 위 `alt-tab`·`alt-shift-tab`과 겹친다. AeroSpace 쪽을 그대로 두고 AltTab을 `⌘⇥`로 옮겼다(2026-09-29). AltTab 설정과 복원은 `../alt-tab/README.md`.
