#!/bin/bash
# Install Forge into ~/.claude (file copy only — idempotent, safe to re-run).
# The one manual/agent step afterwards: merge the SessionStart hook into
# ~/.claude/settings.json (see README §Install).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "$HOME/.claude/skills" "$HOME/.claude/forge/retro"
cp -r "$ROOT/skills/"forge-* "$HOME/.claude/skills/"
cp "$ROOT/forge-home/L0-router.md" "$ROOT/forge-home/subagent-codex.md" "$HOME/.claude/forge/"
# Never clobber a locally-evolved changelog
[ -f "$HOME/.claude/forge/CHANGELOG.md" ] || cp "$ROOT/forge-home/CHANGELOG.md" "$HOME/.claude/forge/"
# Telemetry hook script (invocation-fidelity ledger)
mkdir -p "$HOME/.claude/forge/bin" "$HOME/.claude/forge/telemetry"
cp "$ROOT/forge-home/bin/log-skill.sh" "$HOME/.claude/forge/bin/" && chmod +x "$HOME/.claude/forge/bin/log-skill.sh"

echo "installed: $(ls -d "$HOME"/.claude/skills/forge-*/ | wc -l) skills -> ~/.claude/skills/"
echo ""
echo "Remaining step — merge TWO hook entries into ~/.claude/settings.json:"
echo "  hooks.SessionStart: { \"type\": \"command\", \"command\": \"cat $HOME/.claude/forge/L0-router.md\" }"
echo "  hooks.PostToolUse:  { \"matcher\": \"Skill\", \"hooks\": [ { \"type\": \"command\", \"command\": \"$HOME/.claude/forge/bin/log-skill.sh\" } ] }"
echo "Then restart your Claude Code session."
