# PLUGIN_NAME

[![version](https://img.shields.io/github/v/release/jeongph/PLUGIN_NAME?label=version&color=blue)](https://github.com/jeongph/PLUGIN_NAME/releases)
[![license](https://img.shields.io/github/license/jeongph/PLUGIN_NAME?color=lightgrey)](LICENSE)

한 줄 설명 — 설치하면 무엇이 달라지는지 쓴다.

## 설치

[jeongph/claude-plugins 마켓플레이스](https://github.com/jeongph/claude-plugins)에서 설치한다.

마켓플레이스 등록(최초 1회):

```sh
/plugin marketplace add jeongph/claude-plugins
```

플러그인 설치:

```sh
/plugin install PLUGIN_NAME@jeongph-claude-plugins
```

설치 후 Claude Code를 재시작하면 플러그인이 자동 활성화된다.

## 컴포넌트

| 종류 | 이름 | 역할 |
|------|------|------|
| command | `/example` | (예시 — 실제 컴포넌트로 바꾼다) |
| skill | `example-skill` | (예시 — 실제 컴포넌트로 바꾼다) |

## 사용 예

```
/example
```

## 라이선스

MIT — [LICENSE](LICENSE) 참조

---

<!-- TEMPLATE-DOCS-START -->
<!-- 아래는 템플릿 안내다. scripts/init.sh 가 이 블록을 통째로 지운다. -->

## 템플릿 사용법

이 레포는 [claude-plugin-template](https://github.com/jeongph/claude-plugin-template)에서 만들어졌다.

**1. 초기화**

```sh
./scripts/init.sh
```

`PLUGIN_NAME` 플레이스홀더를 레포 이름으로 바꾸고, 예시 컴포넌트와 초기화 스크립트를 지울지 물어본다.

**2. 컴포넌트 작성**

| 디렉토리 | 용도 |
|---|---|
| `commands/*.md` | 슬래시 커맨드 |
| `skills/<name>/SKILL.md` | 스킬 (Claude가 상황에 맞게 자동 로드) |
| `hooks/hooks.json` | 훅 (PreToolUse·PostToolUse 등) |
| `agents/*.md` | 서브에이전트 |

없는 디렉토리는 만들지 않아도 된다.

**3. 자동 릴리스**

`main`에 머지하면 [claude-plugins의 재사용 워크플로우](https://github.com/jeongph/claude-plugins/blob/main/.github/workflows/auto-release.yml)가 커밋 타입에서 버전을 정한다.

| 커밋 | 결과 |
|---|---|
| `feat:` | minor (`0.1.0` → `0.2.0`) |
| `fix:` `perf:` `refactor:` `revert:` `build:` | patch (`0.1.0` → `0.1.1`) |
| BREAKING (`!` 또는 `BREAKING CHANGE:`) | major가 0이면 minor, 1 이상이면 major |
| `docs:` `style:` `test:` `ci:` `chore:` | 릴리스하지 않음 |

여러 커밋이 있으면 가장 높은 변경 유형을 기준으로 버전을 한 번 올린다. 예를 들어 `feat`이 10건이어도 minor 버전은 한 번만 올린다.

`plugin.json` 갱신 → 태그 → Release → README 뱃지까지 자동으로 이어진다.

**4. 마켓플레이스 등록**

[jeongph/claude-plugins](https://github.com/jeongph/claude-plugins)의 `.claude-plugin/marketplace.json`에 항목을 추가한다.

```json
{
  "name": "PLUGIN_NAME",
  "description": "한 줄 설명",
  "source": {
    "source": "url",
    "url": "https://github.com/jeongph/PLUGIN_NAME.git",
    "sha": "0000000000000000000000000000000000000000"
  }
}
```

`sha`는 아무 값이나 두면 매시간 도는 동기화가 실제 HEAD로 채운다.

> `plugin.json`의 `version`은 유지한다. 마켓플레이스는 이 값으로 플러그인 버전을 고정하고, 자동 릴리스는 이 값을 기준으로 다음 버전을 계산한다.
