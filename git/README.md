# git 설정

`~/.gitconfig` → `git/gitconfig` 심볼릭 링크. 기계마다 다른 값은 저장소 밖 `~/.gitconfig-local`에 둔다(템플릿 `gitconfig-local.example`). 이 문서는 남아 있는 설정마다 **왜 이렇게 했는지**를 적는다.

## 신원

- **전역 신원 하나** (`[user]`): 모든 커밋은 개인 계정 satanmoo(`gyo8270@gmail.com`)로 한다. 폴더별로 신원을 나눌 이유가 없어 전역에 한 번만 적는다. 어느 폴더에서 클론해도 같은 신원으로 커밋된다.
- **`~/.gitconfig-local`** (`[include]`): 서명 키 경로처럼 기계마다 다른 값만 둔다. 저장소에 넣지 않으므로 다른 기계에 dotfiles를 가져가도 키가 섞이지 않는다.

## 서명

- **SSH 서명** (`gpg.format = ssh`, `commit.gpgsign`, `tag.gpgsign`): GPG 키를 따로 관리하지 않고 Secretive(Secure Enclave)의 SSH 키로 서명한다. GitHub 계정에 **Signing Key**로 등록한 키로 서명하면 커밋에 Verified가 붙는다.
- **서명 키는 기계당 하나, Secretive Protection Level = Notify**: Notify는 잠금이 풀린 동안 인증 없이 쓰이고 사용할 때 알림만 뜬다. 그래서 커밋할 때 Touch ID가 뜨지 않고, 에이전트의 무인 커밋도 서명된다. 서명 키만으로는 푸시할 수 없으므로 인증 키보다 풀어 두는 위험이 작다. 경로는 `~/.gitconfig-local`의 `user.signingkey`.
- **`~/.gitallowedsigners`** (`gpg.ssh.allowedSignersFile`): 이 기계에서 `git log --show-signature`로 서명을 검증할 때만 쓰는 목록이다. 첫 칸(principal)은 이메일, 나머지는 공개키. GitHub의 Verified 판정과는 무관하다. 현재 서명 키만 둔다(과거 커밋은 로컬에서 검증하지 않는다). 다른 기계의 서명 키를 넣으면 그 기계의 커밋도 여기서 검증된다.

## GitHub 접속: 원격 주소가 전송 방식을 정한다

기준은 저장소가 공개냐 비공개냐가 아니라 **누가 주소를 적었나**다.

| 경우 | 전송 | 인증 |
| --- | --- | --- |
| 내가 클론하는 저장소(공개·비공개, 내 것·남의 것 모두) | SSH (`git@github.com:…`) | Secretive 인증 키 |
| 도구가 프로젝트 파일에 적힌 주소로 받는 의존성 — 공개(예: Xcode SPM의 Firebase, Unity·CocoaPods·Homebrew) | 적힌 대로, 대개 HTTPS | 없음(익명) |
| 같은 경우인데 비공개(예: 프로젝트에 `https://github.com/<조직>/<비공개 패키지>.git`로 적힌 Unity 패키지) | HTTPS | gh 토큰 |

- 내 저장소를 SSH 주소로 받는 건 gh 설정 `git_protocol ssh`가 맡는다(아래 gh 절). 원격 주소 자체가 SSH라 주소 치환이 필요 없다.
- 이미 있는 클론은 원격 주소를 확인한다: `git remote get-url origin`이 `https://github.com/…`이면 `git remote set-url origin git@github.com:<소유자>/<저장소>.git`. HTTPS로 남아 있으면 SSH 키·배포 키 대신 gh 토큰으로 접속한다.
- 남이 적은 HTTPS 주소는 바꾸지 않는다. 바꾸려면 조직별 치환 목록이 필요하고, 공개 의존성을 받을 때도 키와 Touch ID를 요구하게 돼 무인 빌드가 멈춘다.
- **`[credential "https://github.com"]`**: 위 표의 세 번째 경우, 즉 HTTPS 주소인데 인증이 필요할 때 git이 비밀번호를 묻는 대신 gh에게 토큰을 받아 쓴다. 평소에는 거의 쓰이지 않는 보험이지만, 없으면 에이전트가 비밀번호 입력에서 멈춘다.
  - 첫 줄 `helper =`(빈 값): Homebrew git의 시스템 설정이 모든 호스트에 `osxkeychain` helper를 걸어 둔다. 이 줄이 github.com에서만 그것을 끈다. 끄지 않으면 키체인에 남은 옛 GitHub 비밀번호가 gh 토큰보다 먼저 쓰일 수 있다. 다른 호스트는 계속 키체인을 쓴다.
  - `/opt/homebrew/bin/gh` 절대 경로: Xcode 같은 GUI 앱이 git을 부를 때는 PATH가 짧아 `gh`만 적으면 못 찾는다. Apple Silicon Homebrew 경로다.

## SSH

SSH 키 고정·저장소별 배포 키·포트 우회는 `ssh/README.md`. 위 전송 규칙은 그 설정이 전제다.

## gh CLI (dotfiles가 관리하지 않음 — 새 기계에서 실행)

```
gh auth login
gh config set git_protocol ssh
gh config set -h github.com git_protocol ssh
```

- **`gh auth login`**: 토큰은 macOS 키체인에 저장된다. 토큰은 gh 명령(이슈·PR·API)과 위 HTTPS 보험에 쓰인다. 클론·푸시는 SSH 키가 맡는다.
- **`git_protocol ssh`를 두 곳에**: 전역 값(`~/.config/gh/config.yml`)과 github.com 호스트 값(`~/.config/gh/hosts.yml`)이 따로 있고 호스트 값이 우선한다. 둘 다 ssh여야 `gh repo clone`이 SSH 주소를 저장한다.
- **토큰 권한** `repo`·`workflow`·`read:org`·`gist`: `repo`는 접근 가능한 모든 저장소 읽기·쓰기, `workflow`는 Actions 워크플로 파일 수정, `read:org`는 조직 멤버십 읽기, `gist`는 gist. 토큰이 새면 이 범위가 열린다. SSH 키와 달리 기기 밖으로 복사될 수 있으므로 토큰으로 푸시하지 않는다.

## 기본 동작

- `core.quotepath = false`: 한글 파일 이름을 이스케이프 없이 표시.
- `core.precomposeunicode = true`: 맥의 한글 파일 이름(NFD)을 NFC로 다뤄 다른 OS와 이름이 어긋나지 않게.
- `core.autocrlf = false`: 줄바꿈 자동 변환 안 함.
- `core.excludesfile`: 모든 저장소 공통 무시 목록(`git/gitignore-global`).
- `fetch.prune`, `fetch.prunetags`: 원격에서 지운 브랜치·태그를 로컬 추적에서도 지움.
- `pull.rebase`, `rebase.autostash`, `rebase.autosquash`: pull은 merge 커밋 대신 rebase, 그 전에 미커밋 변경을 잠시 치웠다 되돌림, `fixup!` 커밋 자동 정렬.
- `merge.conflictstyle = zdiff3`: 충돌 표시에 공통 조상 버전까지 보여 판단이 쉬움.
- `rerere.enabled`: 한 번 푼 충돌 해결을 기억해 같은 충돌에 재적용.
- `push.default = simple`, `init.defaultBranch = main`, `log.date = iso8601`, `help.autocorrect = prompt`.
- `[filter "lfs"]`: Git LFS 표준 설정(`git lfs install`이 넣는 값).
