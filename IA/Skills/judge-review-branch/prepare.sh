#!/usr/bin/env bash
# Prepare shared inputs for judge-review-branch, cached per branch commit.
# Usage: prepare.sh <branch> [--force] [--opencode-model <provider/model>]  (run from inside the repo)
set -euo pipefail

BRANCH="${1:?branch required}"; shift
FORCE=""; OC_MODEL=""
while [ $# -gt 0 ]; do
  case "$1" in
    --force) FORCE=1 ;;
    --opencode-model) OC_MODEL="${2:?model required}"; shift ;;
  esac
  shift
done

if ! REPO=$(git rev-parse --show-toplevel 2>/dev/null); then
  echo "STATUS=not-a-repo"
  exit 0
fi
SKILL_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO"

BASE=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's#^origin/##' || true)
if [ -z "$BASE" ]; then
  BASE=$(git show-ref -q --verify refs/remotes/origin/main && echo main || echo master)
fi

if ! git fetch -q origin "$BASE" "$BRANCH" 2>/dev/null; then
  echo "STATUS=missing-branch"
  exit 0
fi

SHA=$(git rev-parse "origin/$BRANCH")
REPO_KEY=$(basename "$REPO")
DIR="$HOME/.cache/judge-review/$REPO_KEY/${BRANCH//\//__}/${SHA:0:12}"
mkdir -p "$DIR"

if [ -z "$OC_MODEL" ]; then
  OC_MODEL=$(jq -r '.model // "default"' "$HOME/.config/opencode/opencode.json" 2>/dev/null || echo default)
  OC_OUT="$DIR/opencode.md"
else
  OC_OUT="$DIR/opencode.${OC_MODEL//\//_}.md"
fi
OPUS_OUT="$DIR/opus.md"

if [ -n "$FORCE" ]; then
  : > "$OPUS_OUT"
  : > "$OC_OUT"
fi

if [ ! -s "$DIR/diff.patch" ]; then
  git log --no-merges --format='%h %an %s' "origin/$BASE..origin/$BRANCH" > "$DIR/commits.txt"
  git diff --stat=200 "origin/$BASE...origin/$BRANCH" > "$DIR/stat.txt"
  git diff "origin/$BASE...origin/$BRANCH" > "$DIR/diff.patch"
fi

sed -e "s|{{BRANCH}}|$BRANCH|g" -e "s|{{SHA}}|$SHA|g" -e "s|{{DIR}}|$DIR|g" \
  -e "s|{{BASE}}|$BASE|g" -e "s|{{REPO}}|$REPO|g" \
  "$SKILL_DIR/review-prompt.md" > "$DIR/prompt.md"

echo "STATUS=ok"
echo "REPO=$REPO"
echo "BASE=$BASE"
echo "SHA=$SHA"
echo "DIR=$DIR"
echo "COMMITS=$(wc -l < "$DIR/commits.txt" | tr -d ' ')"
echo "DIFF_LINES=$(wc -l < "$DIR/diff.patch" | tr -d ' ')"
echo "OPUS_OUT=$OPUS_OUT"
echo "OPUS_CACHED=$([ -s "$OPUS_OUT" ] && echo yes || echo no)"
echo "OPENCODE_MODEL=$OC_MODEL"
echo "OPENCODE_OUT=$OC_OUT"
echo "OPENCODE_CACHED=$([ -s "$OC_OUT" ] && echo yes || echo no)"
