#!/bin/bash
# Install Forge into ~/.claude (file copy only — idempotent, safe to re-run).
# The one manual/agent step afterwards: merge the SessionStart hook into
# ~/.claude/settings.json (see README §Install).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "$HOME/.claude/skills" "$HOME/.claude/forge/retro"
cp -r "$ROOT/skills/"forge-* "$HOME/.claude/skills/"
cp "$ROOT/forge-home/L0-router.md" "$HOME/.claude/forge/"
# Never clobber a locally-evolved changelog
[ -f "$HOME/.claude/forge/CHANGELOG.md" ] || cp "$ROOT/forge-home/CHANGELOG.md" "$HOME/.claude/forge/"

echo "installed: $(ls -d "$HOME"/.claude/skills/forge-*/ | wc -l) skills -> ~/.claude/skills/"
echo ""
echo "Remaining step — add this entry to hooks.SessionStart in ~/.claude/settings.json:"
echo "  { \"type\": \"command\", \"command\": \"cat $HOME/.claude/forge/L0-router.md\" }"
echo "Then restart your Claude Code session."
