# SSH 설정

`~/.ssh/config` → `ssh/config` 심볼릭 링크. 기계마다 다른 값은 저장소 밖 `~/.ssh/config.local`에 둔다(템플릿 `config.local.example`, `chmod 600`). 이 문서는 남아 있는 설정마다 **왜 이렇게 했는지**를 적는다.

## 공통 (`ssh/config`)

- **`Include config.local`을 맨 위에**: SSH는 같은 설정을 여러 번 만나면 **먼저 읽은 값**을 쓴다. 기계별 파일을 먼저 읽어야 그 값이 공통 규칙보다 우선한다.
- **`Host *` → Secretive 에이전트** (`IdentityAgent`): 키를 파일이 아니라 Secure Enclave에 두고, 모든 접속이 Secretive 에이전트를 거치게 한다. 키는 기기 밖으로 복사할 수 없고, 키마다 Touch ID 요구(Require Authentication)나 알림만(Notify)을 고를 수 있다. 소켓 경로는 `~`로 시작해 사용자·기계와 무관하므로 공통에 둔다.

## 기계별 (`~/.ssh/config.local`)

- **`Host github.com`에 인증 키 하나 고정** (`IdentityFile` + `IdentitiesOnly yes`): 에이전트는 가진 키를 순서대로 내민다. Touch ID 없이 쓰이는 배포 키가 먼저 받아들여지면 GitHub가 이 기계를 그 저장소의 배포 키로 인식해 다른 저장소가 모두 거부된다. 기본 인증을 Touch ID 키 하나로 고정해 막는다. 키 파일 이름은 Secretive가 기계마다 다르게 만들므로 기계별 파일에 둔다.
- **이 기계만 접속하는 호스트**(예: 지휘 기계가 다루는 원격 작업기): 주소·계정이 특정 환경의 값이라 공통에 두지 않는다. 기계마다 Secretive 키를 따로 만들어 상대에 등록한다 — 한 기계를 잃어버리면 그 키 줄만 지우면 된다.

## 저장소별 배포 키 (git 저장소 로컬 설정)

무인 작업이 필요한 저장소만: Secretive **Notify** 키를 그 저장소의 **쓰기 배포 키**로 등록하고, 그 저장소의 로컬 git 설정에서만 쓴다. 배포 키는 GitHub 전체에서 저장소 하나에만 붙어서, 인증 없이 쓰이는 키의 영향 범위가 그 저장소로 한정된다. 그 저장소는 Touch ID 없이 pull·push 된다.

```
git -C <저장소> config --local core.sshCommand \
  "ssh -o IdentityAgent=$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh -o IdentitiesOnly=yes -i <배포 키 .pub>"
```

## 22번 포트가 막힌 네트워크

`~/.ssh/config.local`의 `Host github.com`에 `HostName ssh.github.com`, `Port 443`을 더한다.
