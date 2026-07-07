#!/bin/bash
# Forge telemetry: one JSONL line per Skill-tool invocation (PostToolUse hook, matcher "Skill").
# Deterministic, no LLM cost. Read by forge-retro's invocation-fidelity check.
mkdir -p "$HOME/.claude/forge/telemetry"
jq -c '{ts: (now | todate), session: (.session_id // "unknown"), skill: (.tool_input.skill // .tool_input.command // "unknown"), cwd: (.cwd // "")}' \
  >> "$HOME/.claude/forge/telemetry/invocations.jsonl" 2>/dev/null || true
exit 0
