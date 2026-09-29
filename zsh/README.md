# zsh 설정

| 저장소 | 적용 위치 | 기계별 값 |
| --- | --- | --- |
| `zsh/zshenv` | `~/.zshenv` (링크) | `~/.zshenv.local` (템플릿 `zshenv.local.example`) |
| `zsh/zprofile` | `~/.zprofile` (링크) | `~/.zprofile.local` (템플릿 `zprofile.local.example`) |
| `zsh/zshrc` | `~/.zshrc` (링크) | `~/.zshrc.local` (템플릿 `zshrc.local.example`) |
| `zsh/p10k.zsh` | `~/.p10k.zsh` (링크) | — |

```sh
ln -s ~/dotfiles/zsh/zshenv ~/.zshenv
ln -s ~/dotfiles/zsh/zprofile ~/.zprofile
ln -s ~/dotfiles/zsh/zshrc ~/.zshrc
ln -s ~/dotfiles/zsh/p10k.zsh ~/.p10k.zsh
```

## 세 파일의 역할

터미널 앱과 WezTerm은 새 창을 로그인 + 대화형 셸로 연다. 읽는 순서는 `~/.zshenv` → `/etc/zprofile` → `~/.zprofile` → `~/.zshrc`.

- **`zshenv`**: 모든 zsh에서. 터미널뿐 아니라 `ssh host '명령'`, 에이전트가 띄우는 zsh, zsh 스크립트도 읽는다. 어디서든 필요한 환경 변수만. PATH는 두지 않는다 — 로그인 셸이면 뒤이어 `/etc/zprofile`의 `path_helper`가 순서를 다시 짠다.
- **`zprofile`**: 로그인 셸에서 한 번. PATH·환경 변수처럼 한 번 정하면 되는 것. `/etc/zprofile`의 `path_helper`가 PATH를 macOS 기본 순서로 다시 짠 **뒤에** 읽히므로, 여기서 앞에 넣은 경로가 유지된다.
- **`zshrc`**: 대화형 셸에서. 프롬프트·플러그인·자동완성·히스토리·별칭. `[[ -o interactive ]] || return` 아래는 대화형이 아니면 건너뛴다.
- `ssh host '명령'`은 `zshenv`만 읽는다. launchd 작업은 zsh 파일을 하나도 읽지 않는다(bash 스크립트면 더더욱). 무인 스크립트는 PATH·`SSH_AUTH_SOCK`을 스크립트 안에서 정하거나 절대 경로를 쓴다.

## zshenv

- **`SSH_AUTH_SOCK`**: git SSH 서명(`gpg.format = ssh`)은 `~/.ssh/config`의 `IdentityAgent`가 아니라 이 변수의 에이전트에 서명을 맡긴다. Secretive 소켓을 가리킨다(`../git/README.md`, `../ssh/README.md`). 로그인 셸에만 두면 `ssh host 'git commit'`과 에이전트의 비로그인 셸에서 서명이 실패하므로 여기에 둔다.

## zprofile

- **`typeset -U PATH path FPATH fpath`**: 같은 경로는 처음 것만 남긴다. `brew shellenv`와 `/etc/paths.d/homebrew`가 `/opt/homebrew/bin`을 두 번 넣고, 셸 안에서 셸을 띄우면 물려받은 PATH에 같은 경로가 다시 붙기 때문이다. `export PATH=...`처럼 문자열 쪽으로 넣는 값까지 거르려면 배열(`path`)과 문자열(`PATH`) 둘 다에 걸어야 한다.
- **`brew shellenv`**: `/opt/homebrew/bin`을 `/usr/bin`보다 앞에 둔다(Homebrew git이 Apple git보다 먼저 잡힌다). Homebrew 자동완성 폴더(`/opt/homebrew/share/zsh/site-functions`)도 fpath 앞에 넣는다.

## zshrc

- **zinit**(Homebrew 설치)으로 플러그인을 받는다: powerlevel10k(프롬프트), fast-syntax-highlighting, zsh-completions, zsh-autosuggestions, zsh-history-substring-search(↑/↓로 입력한 앞부분과 맞는 기록 검색).
- **powerlevel10k**: 맨 위 instant prompt 블록이 설정을 다 읽기 전에 프롬프트를 먼저 그린다. 모양은 `p10k.zsh`(`p10k configure`가 만든 파일, nerdfont-v3 아이콘).
- 히스토리: 시각 기록, 중복 제거, 창끼리 공유, 900만 줄.
- `AUTO_CD`(폴더 이름만 쳐도 이동), `mv`·`cp`는 덮어쓰기 전에 묻는다, `EDITOR=nvim`.

## 기계별 파일

- `~/.zshenv.local`: 이 기계에만 있는, 모든 zsh에서 쓰는 환경 변수(PATH 제외).
- 설치기가 `~/.zshenv`에 덧붙인 줄(예: uv의 `~/.local/bin` PATH)은 링크를 통해 `zsh/zshenv`에 들어간다. `git status`에 보이면 PATH는 `~/.zprofile.local`, 그 밖의 변수는 `~/.zshenv.local`로 옮긴다.
- `~/.zprofile.local`: 이 기계에만 있는 PATH. 예: JetBrains Toolbox의 셸 스크립트 폴더(`idea`, `studio`).
- `~/.zshrc.local`: 이 기계에서만 쓰는 도구 초기화·별칭.
- JetBrains Toolbox는 "셸 스크립트 생성"이 켜져 있으면 `~/.zprofile` 끝에 PATH 줄을 직접 덧붙인다. `~/.zprofile`은 링크라 그 줄이 `zsh/zprofile`에 들어가므로, `git status`에 보이면 그 줄을 `~/.zprofile.local`로 옮긴다.
