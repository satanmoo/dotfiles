# SSH 설정

`~/.ssh/config` → `ssh/config` 심볼릭 링크. 기계마다 다른 값은 저장소 밖 `~/.ssh/config.local`에 둔다(템플릿 `config.local.example`, `chmod 600`). 이 문서는 설정 조각을 먼저 보여 주고, 그 설정이 **왜 있는지**를 적는다.

## 먼저 알아 둘 것: SSH 키 인증은 어떻게 도는가

- SSH로 접속하면 클라이언트(ssh)가 공개키를 **하나씩** 보여 주며 "이 키로 들어가도 되냐"고 묻고, 서버가 된다·안 된다를 답한다. 서버가 받아들이는 키가 나올 때까지 다음 키를 보여 준다.
- **에이전트**: 개인키를 들고 있다가 ssh 대신 서명해 주는 프로그램. 여기서는 Secretive(개인키가 Mac의 Secure Enclave 안에만 있어 복사할 수 없다). 에이전트는 키를 여러 개 가질 수 있다.
- 따로 지정하지 않으면 ssh는 에이전트가 가진 키를 **전부, 에이전트 순서대로** 보여 준다.
- **GitHub는 처음 받아들인 키로 누구인지 정한다.** 계정 인증 키면 그 계정으로, 저장소 배포 키면 "그 저장소 하나에만 접근하는 접속"으로 정해진다.

## 공통 (`ssh/config`)

```
Include config.local

Host *
  IdentityAgent ~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh
```

- **`Include config.local`을 맨 위에**: SSH는 같은 설정을 여러 번 만나면 **먼저 읽은 값**을 쓴다. 기계별 파일을 먼저 읽어야 그 값이 아래 공통 규칙보다 우선한다.
- **`Host *` + `IdentityAgent`**: 모든 호스트(`*`)에 접속할 때 Secretive 에이전트에게 키를 달라고 한다. 소켓 경로가 `~`로 시작해 사용자·기계와 무관하므로 공통에 둔다. Secretive에서는 키마다 사용할 때 Touch ID를 요구할지(Require Authentication), 알림만 띄울지(Notify) 고른다.

## 기계별 (`~/.ssh/config.local`)

```
Host github.com
  IdentityFile /Users/<사용자>/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/PublicKeys/<인증 키 ID>.pub
  IdentitiesOnly yes
```

- **`IdentityFile <공개키 경로>`**: github.com에 **이 키를 보여 줘라**는 지정. Secretive 키는 개인키가 파일로 없으므로 공개키(`.pub`)를 가리키고, ssh는 에이전트에서 짝이 맞는 키로 서명을 받는다. 경로는 Secretive 앱에서 키를 눌러 "Public Key Path".
- **`IdentitiesOnly yes`**: **지정한 키만** 보여 주고 에이전트의 나머지 키는 보여 주지 않는다. `IdentityFile`만 있으면 "이 키도 보여 줘라"일 뿐 에이전트의 다른 키도 계속 나간다. 두 줄이 같이 있어야 "이 키 하나만"이 된다.
- **왜 필요한가**: 에이전트에는 Touch ID 없이 쓰이는 저장소 배포 키(아래)도 들어 있다. 고정하지 않으면 그 배포 키가 먼저 받아들여져 GitHub가 이 기계를 **그 저장소의 배포 키**로 정하고, 다른 저장소는 모두 "저장소 없음"으로 거부된다(2026-09-28 실제로 발생). 기본 인증을 Touch ID 인증 키 하나로 고정해 막는다.
- **왜 기계별 파일인가**: Secretive가 키 파일 이름(ID)을 기계마다 다르게 만든다.

### 이 기계만 접속하는 호스트

```
Host <별칭>
  HostName <주소>
  User <계정>
  IdentityFile /Users/<사용자>/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/PublicKeys/<그 호스트용 키 ID>.pub
  IdentitiesOnly yes
  ControlMaster auto
  ControlPath ~/.ssh/cm-%C
  ControlPersist 4h
```

- 예: 지휘 기계가 명령을 보내는 원격 작업기. `ssh <별칭>`으로 접속한다.
- 주소·계정이 특정 환경의 값이라 공통 파일에 두지 않는다.
- 접속하는 기계마다 Secretive 키를 **따로** 만들어 상대 서버에 등록한다. 한 기계를 잃어버리면 상대 서버에서 그 기계의 키 줄만 지우면 된다.
- **연결 재사용(`ControlMaster auto`, `ControlPath`, `ControlPersist`)**: 첫 `ssh <별칭>`이 접속하고 이 기계에 마스터 프로세스로 남는다. 마스터는 `ControlPath`의 유닉스 소켓(`~/.ssh/cm-…`, 소유자만 접근)에서 기다리고, 다음 `ssh <별칭>`은 새로 접속하지 않고 그 연결 위에 명령을 얹는다(`auto`: 있으면 쓰고 없으면 만든다). 키가 Touch ID라 명령마다 승인하지 않으려고 쓴다. `ControlPersist 4h`는 마지막 사용 뒤 4시간 유지. 클라이언트만 해석하는 옵션이라 서버에는 오래 열린 연결 하나로 보인다. 상태 `ssh -O check <별칭>`, 재사용 중지 `ssh -O stop <별칭>`(새 요청만 막고 도는 명령은 끝까지 둔다), 즉시 끊기 `ssh -O exit <별칭>`.
- **주의 — 재사용 연결은 처음 접속한 시점의 원격 환경을 쓴다.** 원격의 사용자 세션은 연결이 만들어질 때 한 번 생기고, 그 연결의 명령은 모두 그 세션의 환경을 물려받는다. Windows 원격은 세션이 만들어질 때 레지스트리에서 환경을 한 번 읽으므로, PATH 같은 환경 변수를 바꾸는 설치를 했다면 확인 전에 `ssh -O stop <별칭>`으로 재사용을 끝내고 새로 접속한다(2026-09-30 데스크톱 uv 설치). macOS 원격은 zsh가 명령마다 설정 파일을 다시 읽어 해당 없다.

## 저장소별 배포 키 (git 저장소 로컬 설정)

무인 작업이 필요한 저장소만 쓴다. 무인 작업기에서는 파일 키로 만든다(아래, `git/gitconfig-auto.example`).

```
git -C <저장소> config --local core.sshCommand \
  "ssh -o IdentityAgent=none -o IdentitiesOnly=yes -i ~/.ssh/<저장소>-deploy"
```

- **배포 키**: GitHub에서 계정이 아니라 **저장소 하나**에 등록하는 SSH 키. 같은 키는 GitHub 전체에서 저장소 하나에만 붙는다. "Allow write access"를 켜야 푸시도 된다.
- `~/.ssh`의 **암호 없는 파일 키**로 만든다(`ssh-keygen -t ed25519 -N "" -f ~/.ssh/<저장소>-deploy`). Secretive 키는 에이전트(grok 등)가 띄운 ssh가 닿을 때마다 macOS가 다른 앱 데이터 접근 창을 띄우고, 허용해도 유지되지 않아 무인 pull·push가 멈춘다(2026-09-29). 파일 키라 복사될 수 있지만 배포 키라 영향이 그 저장소 하나로 한정되고, 새면 GitHub에서 그 키만 지운다.
- **`IdentityAgent=none`**: 에이전트를 아예 묻지 않는다. Secretive 소켓에 닿지 않게 하려는 것이다.
- **`core.sshCommand`**: 이 저장소에서 git이 SSH를 부를 때 쓸 명령. `-i <배포 키>`로 지정한 키를 **가장 먼저** 보여 준다(명령에 준 `-i`가 설정 파일의 `IdentityFile`보다 앞선다). GitHub가 배포 키를 받아들이므로 그 뒤의 인증 키는 쓰이지 않는다. 그래서 이 저장소만 Touch ID 없이 pull·push 되고, 다른 저장소는 계속 Touch ID 인증 키를 쓴다.

## 22번 포트가 막힌 네트워크

`~/.ssh/config.local`의 `Host github.com`에 두 줄을 더한다. GitHub는 443번 포트로도 SSH를 받는다.

```
  HostName ssh.github.com
  Port 443
```
