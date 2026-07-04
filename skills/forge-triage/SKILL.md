---
name: forge-triage
description: Entry point for any coding, design, or change task — sizes it into lane S/M/L and routes the workflow. Use when the user asks to build, add, fix, refactor, configure, or modify anything, before taking any other action.
---

# Forge Triage

Size the task, announce the lane, start moving. Never wait for lane confirmation — the user can override at any time, and a wrong lane costs one correction, not a ruined task.

## Lane criteria

Score three axes, each low/high:

| Axis | Low | High |
|---|---|---|
| **Reversibility** | trivially undone (git revert, config flip) | one-way door: schema, public API, data migration, published artifact |
| **Blast radius** | one file / local behavior | crosses modules, changes interfaces, touches shared state |
| **Ambiguity** | requirements fully clear from the request + code | multiple plausible interpretations, unstated constraints |

- All three low → **S**
- Any one high, fits in one session → **M**
- Two+ high, or work that cannot fit one session / needs parallel slices → **L**

Between two lanes? Ask one multiple-choice question. Otherwise never ask.

## Lane protocols

**S — direct:** One sentence ("S 道:直接修改 X"). Do the work. Iron Laws still apply (bug → `forge-rootcause`; implementation code → `forge-tdd` where a test surface exists). Finish with `forge-verify`. No design doc, no plan file, no interview.

**M — single session:** Announce lane + reason in one line. Then:
1. `forge-interview` in **one-way-door mode**: interview ONLY the decisions that are hard to reverse or genuinely ambiguous. Reversible details — decide yourself and note the choice.
2. Confirm test seams with the user (one message, from `forge-tdd`'s seam rule).
3. Implement via `forge-tdd`. On bugs, `forge-rootcause`.
4. `forge-review` (lite: single reviewer pass, both axes in one) → `forge-verify` → commit.
Durable artifacts: glossary/ADR updates via `forge-glossary` when terms/decisions crystallize. No PRD, no issues.

**L — multi-session:** Announce lane + reason. Then chain: `forge-interview` (full) → `forge-prd` → `forge-slice` → `forge-run` → `forge-land`. Each stage auto-advances; the natural pause points are PRD review and land options.

## Escalation / demotion

- Mid-task discovery that raises an axis (hidden coupling, ambiguity surfacing) → announce "升档 M→L: reason" and switch protocol. Work done so far carries over.
- A lane that proves too heavy → demote the same way. Log either event via `forge-retro` capture — misjudged lanes are the primary training signal for improving these criteria.

## Context sources

Before scoring, spend ≤1 minute: glance at repo state (CONTEXT.md, docs/forge/ bus, recent commits). If claude-mem is present and the task smells like something done before, one `mem-search` query is allowed. Do not launch broad exploration at triage — that belongs to the lane's own stages.
