---
name: forge-run
description: Execute ready issues from the bus — each issue in a fresh worktree with subagent implementation and two-stage review. Use in L lane after forge-slice, or to resume a partially-executed issue set.
---

# Forge Run

You are the controller. You route context, dispatch subagents, enforce gates, and update the bus. **You do not implement** — a controller that starts implementing loses the context economy that makes multi-issue execution work.

## Per-issue lifecycle

1. **Claim.** Pick the next `status: ready` issue whose `depends_on` are all `done`. Set `status: in-progress`.
2. **Isolate.** Create a worktree: `git worktree add .forge/wt/issue-NNN -b forge/issue-NNN` (from the current integration base). Ensure `.forge/` is gitignored. Run the project's setup + a baseline test pass in the worktree — a dirty baseline poisons every later verification.
3. **Implement.** Dispatch an implementer subagent whose prompt contains the FULL issue text + PRD's Allowed APIs & anti-patterns + CONTEXT.md glossary + worktree path — never "read the plan file yourself". **Every dispatched prompt (implementer, reviewers, verifier) ends with the codex from `~/.claude/forge/subagent-codex.md`, verbatim** — subagents run on assorted models and without it they narrate, re-litigate, and stop mid-promise. Pick each subagent's model tier by task weight: mechanical/small work goes to a cheaper tier, core implementation and verification keep full strength; when unsure, don't downgrade. The implementer follows `forge-tdd`; on bugs, `forge-rootcause`. It reports one of: `DONE` / `DONE_WITH_CONCERNS` / `NEEDS_CONTEXT` / `BLOCKED` — with evidence (commands run, output).
   - `NEEDS_CONTEXT` → answer from PRD/interview knowledge, redispatch. Recurring gaps mean the issue brief was thin — fix the brief on the bus, and `forge-retro` it.
   - `BLOCKED` → set issue `blocked` with reason, move on.
4. **Review.** `forge-review` full mode: two parallel reviewer subagents (standards ∥ spec-fidelity vs the issue's Behavior spec). Critical/Important findings → fix subagent in the same worktree → re-review the fix.
5. **Verify.** `forge-verify` by a verifier context that is not the implementer, inside the worktree: suite + behavioral drive of the issue's deliverable.
6. **Close.** Commit in the worktree (leave the branch for `forge-land`), set `status: done`. One-line progress note to the user.

## Parallelism

Issues with no dependency edge between them MAY run concurrently, each in its own worktree — this is why slices must be independent and worktrees mandatory. Cap concurrency at what you can genuinely supervise (2–3); a controller juggling five implementers rubber-stamps reports, which `forge-verify` exists to prevent. Never parallelize issues touching the same files; check before dispatching.

## Session boundaries

Context filling up mid-run is expected: the bus carries all state (issue statuses, branches named `forge/issue-NNN`). Stop cleanly at an issue boundary; the next session resumes with `forge-run` by reading the bus. Never let a session die mid-issue without setting the issue's status and noting the worktree state in it.

All issues `done` (or terminally `blocked`) → `forge-land`.
