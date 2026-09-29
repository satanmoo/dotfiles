# AltTab 설정

창 단위 전환기. 같은 앱의 창(크롬 프로필별 창 등)을 썸네일·제목으로 구분해 고르려고 쓴다. 설치는 `brew install --cask alt-tab`.

`alt-tab-config.plist`는 설정 창 General → **Export settings…** 로 뽑은 것이다(기본값과 다른 항목만 들어 있다). 되살릴 때는 **Import settings…** 로 이 파일을 고른다. Import는 AltTab 소유 키만 걸러 **설정 전체를 덮어쓴다**. 설정을 바꾸면 다시 Export해 이 파일을 갱신한다.

- **링크나 `defaults write`로 넣지 않는다**: 11.x는 단축키를 `{string, secureData(NSKeyedArchiver)}` 사전으로 저장하고, 형식이 맞지 않는 값은 실행할 때 지운다(2026-09-29 개인 맥북, `holdShortcut`에 문자열만 넣었다가 지워짐). Export/Import만 쓴다.

## 단축키

- **Shortcut 1 = `⌘⇥`** (hold `⌘`, press `⇥`): macOS 앱 전환기를 대체한다. 기본값 `⌥⇥`는 AeroSpace의 `alt-tab`·`alt-shift-tab`과 겹친다(`../aerospace/README.md`). AeroSpace는 `alt` 조합, AltTab은 `⌘` 조합으로 나눈다.
- **Shortcut 2는 쓰지 않는다**: Pro 기능이라 체험이 끝나면 막힌다. 같은 앱 창 순환은 macOS 기본 `` ⌘` ``.
- Gesture는 끈다(트랙패드 세·네 손가락은 macOS 몫).

## 그 밖의 값 (Export 기준)

- `captureWindowsInBackground = false`: 썸네일을 미리 찍지 않는다. 보라색 화면 녹화 표시와 DRM 영상 깜빡임을 피한다. 썸네일은 덜 최신이다.
- `appearanceSize = 0`(small), `shortcutStyle = 0`(키를 떼면 고른 창으로 이동).
- `showWindowlessApps2 = 1`(hide), `showFullscreenWindows2 = 0`(show): Shortcut 2용 값. 쓰지 않지만 Export에 남는다.
- `updatePolicy = 1`(주기적 확인), `crashPolicy = 0`(보내지 않음).

## AeroSpace와 함께

AeroSpace 워크스페이스는 모두 macOS Space 하나 안에 있으므로 "Show windows from Spaces"로는 워크스페이스를 가를 수 없다. All Spaces로 둔다. 다른 워크스페이스의 창을 고르면 AeroSpace가 그 워크스페이스로 넘어간다.
