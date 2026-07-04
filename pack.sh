#!/bin/bash
# Forge 主同步脚本:以 ~/.claude 实况为唯一源,双输出到
#   1) 本仓库工作区(skills/ + forge-home/)
#   2) 个人-wsl-setup/payload/forge/(离线装机包,若存在)
# forge evolve 后跑一次,然后在本仓库 git commit + push。
set -euo pipefail
REPO="$(cd "$(dirname "$0")" && pwd)"
PAYLOAD="$REPO/../个人-wsl-setup/payload/forge"

sync_to() {
  local dst="$1"
  rm -rf "$dst/skills"
  mkdir -p "$dst/skills" "$dst/forge-home"
  for d in "$HOME"/.claude/skills/forge-*/; do
    cp -r "$d" "$dst/skills/"
  done
  cp "$HOME/.claude/forge/L0-router.md" "$HOME/.claude/forge/CHANGELOG.md" "$dst/forge-home/"
}

sync_to "$REPO"
echo "repo synced: $(ls "$REPO/skills" | wc -l) skills"

if [ -d "$(dirname "$PAYLOAD")" ]; then
  sync_to "$PAYLOAD"
  echo "setup payload synced: $PAYLOAD"
else
  echo "setup payload 不存在,跳过(本机可能只有 repo)"
fi
