#!/usr/bin/env bash
# farm.sh — Farmの機構。ルールを覚える代わりに、これを実行する。
#
#   bash barn/farm.sh status   # 健康診断（soil / harvest / seeds / git）
#   bash barn/farm.sh index    # 0_soil/_index.md をfrontmatterから再生成
#   bash barn/farm.sh stale    # staleな成果物だけを表示
#
# 制約: ファイルパスに空白を含めない（snake_case命名を前提とする）
set -eu

cd "$(dirname "$0")/.."

SOIL_DIR="0_soil"
SEEDS_DIR="1_seeds"
HARVEST_DIR="2_harvest"
INDEX_FILE="$SOIL_DIR/_index.md"
SOIL_STALE_DAYS=90

# ---- frontmatter helpers ----------------------------------------------------

fm_get() { # fm_get <file> <key> : フラットなキーの値を返す
  awk -v key="$2" '
    NR==1 { if ($0 != "---") exit; next }
    $0=="---" { exit }
    index($0, key":")==1 {
      sub("^" key ":[[:space:]]*", "")
      gsub(/"/, "")
      print; exit
    }
  ' "$1"
}

fm_deps() { # fm_deps <file> : depends_on のリスト項目を1行1件で返す
  awk '
    NR==1 { if ($0 != "---") exit; next }
    $0=="---" { exit }
    /^depends_on:/ { grab=1; next }
    grab && /^[[:space:]]*-[[:space:]]/ {
      sub(/^[[:space:]]*-[[:space:]]*/, ""); gsub(/"/, ""); print; next
    }
    grab { grab=0 }
  ' "$1"
}

to_epoch() { # YYYY-MM-DD -> epoch秒（BSD/GNU両対応、失敗時は空）
  date -j -f "%Y-%m-%d" "$1" +%s 2>/dev/null || date -d "$1" +%s 2>/dev/null || echo ""
}

# ---- soil -------------------------------------------------------------------

soil_report() {
  echo "== soil =="
  local now warn f base st up title epoch age_days
  now=$(date +%s)
  warn=0
  for f in "$SOIL_DIR"/*.md; do
    [ -e "$f" ] || continue
    base=$(basename "$f")
    [ "$base" = "_index.md" ] && continue
    title=$(fm_get "$f" title)
    st=$(fm_get "$f" status)
    up=$(fm_get "$f" updated)
    if [ -z "$st" ]; then
      echo "  [!] $base : frontmatterがない（barn/templates/soil.md を適用する）"
      warn=1
      continue
    fi
    local mark="ok"
    if [ "$st" != "canonical" ]; then
      mark="${st}（生成に使わない）"
      warn=1
    fi
    local note=""
    if [ -n "$up" ]; then
      epoch=$(to_epoch "$up")
      if [ -n "$epoch" ]; then
        age_days=$(( (now - epoch) / 86400 ))
        if [ "$age_days" -gt "$SOIL_STALE_DAYS" ]; then
          note=" ← updatedが${age_days}日前。棚卸し対象"
          warn=1
        fi
      fi
    fi
    echo "  [$mark] $base ($up) $title$note"
  done
  [ "$warn" -eq 0 ] && echo "  すべてcanonical・鮮度OK"
  return 0
}

# ---- harvest ----------------------------------------------------------------

artifact_state() { # artifact_state <file> : FRESH|STALE|UNBUILT|BROKEN と理由を出力
  local f="$1" built deps d missing changed dirty
  built=$(fm_get "$f" built_from)
  deps=$(fm_deps "$f")
  if [ -z "$deps" ]; then
    echo "UNBUILT|depends_on未申告"
    return 0
  fi
  missing=""
  for d in $deps; do
    [ -f "$d" ] || missing="$missing $d"
  done
  if [ -n "$missing" ]; then
    echo "BROKEN|依存先が存在しない:$missing"
    return 0
  fi
  if [ -z "$built" ]; then
    echo "UNBUILT|built_from未記録"
    return 0
  fi
  if ! git cat-file -e "$built^{commit}" 2>/dev/null; then
    echo "BROKEN|built_from=$built がgitに存在しない"
    return 0
  fi
  # shellcheck disable=SC2086
  changed=$(git rev-list "$built"..HEAD -- $deps 2>/dev/null | wc -l | tr -d ' ')
  # shellcheck disable=SC2086
  dirty=$(git status --porcelain -- $deps 2>/dev/null | wc -l | tr -d ' ')
  if [ "$changed" -gt 0 ] || [ "$dirty" -gt 0 ]; then
    echo "STALE|依存soilに変更あり（commit:${changed} / 未commit:${dirty}）→ soilから再生成する"
  else
    echo "FRESH|"
  fi
  return 0
}

harvest_report() { # harvest_report [stale_only]
  local stale_only="${1:-}" found=0 shown=0 f name st state reason
  echo "== harvest =="
  while IFS= read -r f; do
    name=$(fm_get "$f" artifact)
    [ -z "$name" ] && continue
    found=1
    st=$(artifact_state "$f")
    state=${st%%|*}
    reason=${st#*|}
    if [ -n "$stale_only" ] && [ "$state" = "FRESH" ]; then
      continue
    fi
    shown=1
    if [ "$state" = "FRESH" ]; then
      echo "  [FRESH] $name ($f)"
    else
      echo "  [$state] $name ($f)"
      echo "          $reason"
    fi
  done <<EOF
$(find "$HARVEST_DIR" -name '*.md' -type f 2>/dev/null | sort)
EOF
  [ "$found" -eq 0 ] && echo "  成果物なし（最初のコンパイルは barn/templates/artifact.md から）"
  [ "$found" -eq 1 ] && [ "$shown" -eq 0 ] && echo "  すべてFRESH"
  return 0
}

# ---- seeds / git ------------------------------------------------------------

seeds_report() {
  echo "== seeds =="
  local count
  count=$(find "$SEEDS_DIR" -type f ! -name '.gitkeep' 2>/dev/null | wc -l | tr -d ' ')
  echo "  ${count}件。直近:"
  find "$SEEDS_DIR" -type f ! -name '.gitkeep' -print0 2>/dev/null \
    | xargs -0 ls -t 2>/dev/null | head -5 | sed 's/^/    /'
  [ "$count" = "0" ] && echo "    （なし）"
  return 0
}

git_report() {
  echo "== git =="
  local n
  n=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  if [ "$n" = "0" ]; then
    echo "  クリーン"
  else
    echo "  未コミット変更 ${n}件（蒸留の儀式のあとにコミットする）"
  fi
  return 0
}

# ---- index ------------------------------------------------------------------

index_cmd() {
  local f base title summary st up tags
  {
    echo "<!-- このファイルは barn/farm.sh index が自動生成する。手で編集しない -->"
    echo ""
    echo "# Soil Index（自動生成）"
    echo ""
    echo "| ファイル | タイトル | 概要 | status | updated | tags |"
    echo "| --- | --- | --- | --- | --- | --- |"
    for f in "$SOIL_DIR"/*.md; do
      [ -e "$f" ] || continue
      base=$(basename "$f")
      [ "$base" = "_index.md" ] && continue
      title=$(fm_get "$f" title)
      summary=$(fm_get "$f" summary)
      st=$(fm_get "$f" status)
      up=$(fm_get "$f" updated)
      tags=$(fm_get "$f" tags)
      echo "| [$base](./$base) | $title | $summary | $st | $up | $tags |"
    done
  } > "$INDEX_FILE"
  echo "generated: $INDEX_FILE"
}

# ---- main -------------------------------------------------------------------

cmd="${1:-status}"
case "$cmd" in
  status)
    echo "== Farm Status ($(date +%Y-%m-%d)) =="
    soil_report
    harvest_report
    seeds_report
    git_report
    ;;
  stale)
    harvest_report stale_only
    ;;
  index)
    index_cmd
    ;;
  *)
    echo "usage: bash barn/farm.sh [status|index|stale]"
    exit 1
    ;;
esac
