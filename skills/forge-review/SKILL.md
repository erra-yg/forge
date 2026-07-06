---
name: forge-review
description: Two-axis code review (standards ∥ spec-fidelity) of a diff. Use after implementing in M lane (lite mode), per-issue in forge-run (full mode), or when the user asks for a review of changes.
---

# Forge Review

Review a diff on two independent axes. They answer different questions and must not contaminate each other: beautiful code that builds the wrong thing, and faithful code full of smells, are both real failures that single-axis review misses.

**Fix the diff range first**: `git diff <base>...HEAD`. Reviewing "recent changes" without a pinned base reviews noise.

## Axis 1 — Standards

Is this good code by this repo's standards?

- The repo's own conventions outrank general taste: match surrounding naming, error handling, comment density, test style. A "fix" that fights house style is a defect.
- Classic smells as the baseline: duplication, dead code, mystery names, long functions doing several things, leaky abstractions, swallowed errors, unnecessary state.
- Simplification: could this diff be smaller and achieve the same behavior? Flag scaffolding that no longer earns its place.

## Axis 2 — Spec fidelity

Does this diff build what was agreed? Judge against the governing artifact (issue brief in L lane, interview design summary in M, the user's request in S):

- **Missing** — agreed behavior not implemented, edge cases silently skipped.
- **Creep** — behavior nobody asked for (YAGNI violations, speculative options, drive-by refactors).
- **Wrong** — implemented, but not what the spec meant. Terminology drift against CONTEXT.md counts: code that names a concept differently than the glossary is a spec bug.

## The human-judgment queue

The two axes cover what a machine can check. Some questions must be **routed to the human, never auto-resolved**: domain assumptions (physics, numerics, units, statistical validity), algorithm choice against domain convention, performance trade-offs in hot paths — anything where being wrong looks identical to being right from inside the code. Output these as an explicit "needs human judgment" list alongside the findings, each with your recommendation attached. Machine review is an advanced linter; pretending the two axes cover domain truth manufactures false confidence. Under a tight leash this queue is presented before advancing; under loose, at the next stage boundary.

## Modes

- **Lite (M lane):** one reviewer pass covering both axes, severity-tagged. Same session is acceptable, but review the DIFF, not your memory of writing it.
- **Full (L lane, inside forge-run):** two parallel subagents, one per axis, neither seeing the other's findings nor the implementer's session history — each gets the diff, the governing artifact, and CONTEXT.md. Controller merges results; do not force a single winner across axes.

## Findings and response discipline

Each finding: severity (**Critical** = wrong behavior/data loss/security → fix before anything else; **Important** = will bite soon → fix before proceeding; **Minor** = note it, fix if touching that area), location, one-sentence defect, concrete failure scenario.

Receiving findings (from this review, or any external reviewer):
- **No performative agreement.** "You're absolutely right" and thanks add nothing — evaluate, then act or rebut.
- **Verify before implementing.** A reviewer's claim is a hypothesis; check it against the code before changing anything. Reviewers lack session context and are sometimes simply wrong.
- **Push back with evidence** when a finding is mistaken — deference to a wrong review is a defect with two authors.
- Unclear feedback → clarify before touching code.

Fixes go back through `forge-verify` before the review is declared resolved.
