---
name: forge-handoff
description: Checkpoint the current task into a durable handoff on the bus. Use when context is running low, before a planned /compact, when pausing mid-task, or when work must continue in another session or on another machine.
---

# Forge Handoff

The continuity primitive. A session's context is disposable; task state must not be. A handoff is an intentional, structured baton written for your successor — which is usually a future you with none of your current context.

Where the L-lane bus already carries continuity (issues with self-contained briefs), a handoff covers everything the bus doesn't: mid-interview state, M-lane work in flight, half-implemented issues, and anything about to be lost to /compact.

## Write side — checkpoint

**Step 0 — flush durable knowledge first.** Unrecorded glossary terms or ADR-worthy decisions go through `forge-glossary` NOW. A handoff is not a substitute for write-back; it is the last call for it. Decisions that belong in the PRD get written to the PRD, not restated in the handoff.

Then write `docs/forge/handoff/<slug>.md` (no repo? use `~/.claude/forge/handoff/` with a `project:` field):

```markdown
---
status: active          # active | consumed | superseded
lane: M                 # S | M | L
stage: implementing     # interviewing | designing | implementing | reviewing | landing
created: YYYY-MM-DD
---
## Task
One paragraph: what is being built and why, which chain stage we're at.

## State of the world
Branch/worktree; files touched; test status (green, or WHICH tests are red and why
that's expected); what has passed forge-verify vs what hasn't.

## Decisions made
Pointers to where each decision lives (glossary entry, ADR, PRD section, issue) —
not restatements. Only decisions that live nowhere else may be stated here.

## Next action
The successor's exact first move: file, command, expected result. This line is the
difference between a 2-minute resume and a 20-minute re-derivation.

## Open branches
Unresolved questions, each with current thinking and your recommended answer.

## Landmines
What was tried and failed; non-obvious constraints discovered; things that look
wrong but are intentional.
```

Reference artifacts by path — never duplicate their contents. Redact anything secret. Keep it under ~80 lines: the successor has the repo, the bus, and git history; a handoff is a map, not the territory.

**One active handoff per task.** Supersede (set `status: superseded`, write the new one) rather than accumulate.

## Resume side

`forge-triage` checks for `status: active` handoffs at task start; when one matches the incoming task, resume mode replaces fresh triage:

1. Read the handoff, then **verify its claims against reality** — `git status`, run the named tests. The world may have moved since it was written; Iron Law III applies to inherited claims too. A handoff is testimony from a dead session, not evidence.
2. Mark it `status: consumed`.
3. Re-enter the chain at the stated stage — do not re-run stages the handoff shows as complete, and do not trust stages it doesn't.

## /compact

Compaction is lossy and you don't control what survives. Before a planned /compact mid-task, write a handoff; afterwards, the handoff file outranks the compact summary as the source of task truth. If a compact happened without one, treat the summary's task claims with resume-side skepticism (verify before building on them).

## Boundaries

- **Not a diary.** If nothing is in flight (task just completed and verified), there is nothing to hand off — the bus, glossary, and git history already say everything.
- **Not claude-mem.** Observations are a passive ledger of what happened; a handoff is an active baton for what happens next. They complement, never substitute.
- **L lane post-PRD rarely needs one** — reach for it only on mid-issue interrupts.
