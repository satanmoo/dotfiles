# uv 설정

uv 자체는 Homebrew로 깐다(Brewfile `brew "uv"`).

| 저장소 | 적용 위치 | 방식 |
| --- | --- | --- |
| `uv/uv.toml` | `~/.config/uv/uv.toml` | 심볼릭 링크 |
| `uv/tools.txt` | `~/.local/bin` | `uv tool install`로 설치 |

```sh
mkdir -p ~/.config/uv
ln -s ~/dotfiles/uv/uv.toml ~/.config/uv/uv.toml
```

## uv.toml

모든 프로젝트에 공통으로 적용되는 기본값이다. 프로젝트 `pyproject.toml`의 `[tool.uv]`가 있으면 그쪽이 우선한다.

- **`python-preference = "only-managed"`**: uv가 받은 Python(`~/.local/share/uv/python`)만 쓰고 Homebrew·macOS의 Python은 무시한다. 없는 버전은 새로 받는다. 기본값 `managed`는 uv가 받은 것을 먼저 찾되 없으면 Homebrew Python도 쓴다. 그러면 `brew upgrade`로 Homebrew Python이 바뀔 때 그 위에 만든 가상환경이 깨질 수 있고, 맥마다 쓰는 Python이 달라진다. 이미 만든 가상환경은 바뀌지 않는다.
- **기계마다 다른 값은 넣지 않는다**: 회사 사내 미러(`index-url`), 프록시 인증서(`native-tls`) 등. uv.toml은 다른 파일을 include하지 못하므로 그 맥의 `~/.zshenv.local`에 환경 변수(`UV_INDEX_URL`, `UV_NATIVE_TLS=1` 등)로 둔다.

## tools.txt

uv에는 Brewfile 같은 도구 목록 기능이 없어 목록 파일로 대신한다. 한 줄에 하나씩 적고, 설명은 그 위 줄에 `#`로 쓴다(줄 끝 주석은 xargs가 인자로 읽는다).

```sh
# 목록 설치 (이미 있으면 건너뛴다)
grep -v -e '^#' -e '^$' ~/dotfiles/uv/tools.txt | xargs -n1 uv tool install
# 전부 업그레이드
uv tool upgrade --all
```

- 실행 파일은 `~/.local/bin`에 생긴다. 이 폴더는 `zsh/zprofile`이 PATH에 넣는다.
- 지금 목록: `pyrefly`(nvim Python 언어 서버, `../nvim/README.md`).
