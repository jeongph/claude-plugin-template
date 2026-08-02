#!/usr/bin/env bash
# 템플릿에서 만든 레포를 실제 플러그인으로 초기화한다.
#
#   ./scripts/init.sh                 # git remote 에서 이름을 알아낸다
#   ./scripts/init.sh my-plugin       # 이름을 직접 준다
#
# PLUGIN_NAME 플레이스홀더를 실제 이름으로 바꾸고, 예시 컴포넌트와 이
# 스크립트 자신을 지울지 물어본다.
set -euo pipefail

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

NAME="${1:-}"
if [ -z "$NAME" ]; then
  origin=$(git remote get-url origin 2>/dev/null || true)
  if [ -z "$origin" ]; then
    echo "레포 이름을 알아낼 수 없다. 인자로 넘겨라: ./scripts/init.sh my-plugin" >&2
    exit 1
  fi
  NAME=$(basename "$origin" .git)
fi

if [ "$NAME" = "claude-plugin-template" ]; then
  echo "템플릿 자신에서는 실행하지 않는다. 템플릿으로 새 레포를 만든 뒤 거기서 실행해라." >&2
  exit 1
fi

if ! printf '%s' "$NAME" | grep -qE '^[a-z0-9]+(-[a-z0-9]+)*$'; then
  echo "플러그인 이름은 kebab-case 여야 한다: $NAME" >&2
  exit 1
fi

echo "플러그인 이름: $NAME"

# 플레이스홀더 치환 — 텍스트 파일만 훑는다.
files=$(grep -rl 'PLUGIN_NAME' . --exclude-dir=.git 2>/dev/null || true)
if [ -n "$files" ]; then
  printf '%s\n' "$files" | while IFS= read -r f; do
    # BSD sed 와 GNU sed 의 -i 인자 규칙이 달라 임시 파일로 우회한다.
    sed "s/PLUGIN_NAME/$NAME/g" "$f" > "$f.tmp" && mv "$f.tmp" "$f"
    echo "  치환: $f"
  done
fi

# README 끝에 붙은 템플릿 안내 블록을 걷어낸다.
if grep -q '^<!-- TEMPLATE-DOCS-START -->' README.md 2>/dev/null; then
  # 마커부터 끝까지 버리고, 그 앞에 놓였던 구분선과 빈 줄도 함께 걷어낸다.
  # awk 의 exit 는 END 블록을 건너뛰지 않으므로 여기서 마무리한다.
  awk '
    /^<!-- TEMPLATE-DOCS-START -->/ { exit }
    { lines[NR] = $0 }
    END {
      n = NR
      while (n > 0 && (lines[n] == "" || lines[n] == "---")) n--
      for (i = 1; i <= n; i++) print lines[i]
    }
  ' README.md > README.tmp
  mv README.tmp README.md
  echo "  README 의 템플릿 안내 블록 제거"
fi

printf '\n예시 컴포넌트(commands/example.md, skills/example-skill)를 지울까? [y/N] '
read -r ans
case "$ans" in
  [yY]*)
    rm -rf commands/example.md skills/example-skill
    rmdir commands skills 2>/dev/null || true
    echo "  예시 삭제됨"
    ;;
  *) echo "  예시 유지" ;;
esac

printf '이 초기화 스크립트를 지울까? [y/N] '
read -r ans
case "$ans" in
  [yY]*)
    rm -f scripts/init.sh
    rmdir scripts 2>/dev/null || true
    echo "  scripts/init.sh 삭제됨"
    ;;
  *) echo "  유지" ;;
esac

cat <<EOF

초기화 완료. 남은 일:

  1. .claude-plugin/plugin.json 의 description·keywords 를 채운다
  2. 컴포넌트를 만든다 (commands/ · skills/ · hooks/ · agents/)
  3. README 를 채운다
  4. 커밋해서 main 에 올린다
       feat: ... 으로 커밋하면 0.1.0 -> 0.2.0
       fix:  ... 으로 커밋하면 0.1.0 -> 0.1.1
     태그·Release·뱃지가 자동으로 따라온다
  5. 마켓플레이스에 등록한다 — jeongph/claude-plugins 의
     .claude-plugin/marketplace.json 에 항목을 추가하면
     매시간 도는 동기화가 SHA 를 채운다

EOF
