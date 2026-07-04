---
name: forge-rootcause
description: Iron Law II — no fix without root cause. Use on any bug, test failure, error, or unexpected behavior, before proposing or applying any fix.
---

# Forge Rootcause

**IRON LAW: NO FIX WITHOUT ROOT CAUSE INVESTIGATION FIRST.**

A fix applied to a symptom teaches you nothing, usually doesn't hold, and often hides the real defect deeper. The temptation this Law exists to kill: "I see something plausible, let me just try changing it."

## Phase 0 — build the red loop

Before ANY hypothesis: construct a **tight, red-capable feedback loop** — a single command that reproduces the failure in seconds and will visibly turn green when the defect is truly gone. Shrink it: fewer steps, less data, shorter runtime, deterministic. **No red-capable command, no Phase 1.** If you cannot reproduce it, reproducing it IS the investigation.

## Phase 1 — locate

- Read the error and the code path it names — actually read them, not skim.
- Trace data backward from the failure point to where reality diverged from expectation.
- State **up to 3 falsifiable hypotheses, ranked** by likelihood. Each must name the observation that would kill it.

## Phase 2 — instrument, one variable at a time

Test the top hypothesis with the cheapest observation that can falsify it (targeted log with a `[DBG-xxx]` tag, breakpoint, minimal probe script). One variable per experiment — a probe that changes two things produces evidence about neither. Hypothesis dies → next one. All three die → your model of the system is wrong somewhere upstream; widen the frame, re-derive hypotheses. Never bypass this by stacking speculative edits.

**Three failed fix attempts is an architecture signal**, not a call for a fourth attempt: stop, question the design of the failing area, raise it.

## Phase 3 — fix at the cause

- Root cause confirmed by evidence → write the failing regression test at the proper seam (`forge-tdd` — the red loop often IS this test; formalize it).
- Smallest change that removes the cause. Resist drive-by fixes of unrelated smells you noticed — note them instead.
- Green loop + `forge-verify`. Remove all `[DBG-xxx]` instrumentation (grep for the tag).

## Post-mortem residue

One sentence in the session about what the root cause actually was. If it meets `forge-glossary`'s three ADR conditions (hard to reverse, surprising, real trade-off), record it — surprising root causes are exactly what ADRs are for. Recurring bug patterns worth a process change → `forge-retro` capture.

## Forbidden moves

- "Try this and see" edits to production code as a diagnostic method.
- Fixing the test to match broken behavior (unless evidence shows the TEST is wrong — then say so explicitly).
- Adding defensive code (retries, try/except, null checks) around a failure you haven't explained: that is symptom-burial with extra steps.
- Declaring environment/flakiness without evidence that reruns-unchanged actually vary.
