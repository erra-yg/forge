---
name: forge-tdd
description: Iron Law I — no implementation code without a failing test first, at an agreed seam. Use when implementing any feature or bugfix, before writing production code.
---

# Forge TDD

**IRON LAW: NO IMPLEMENTATION CODE WITHOUT A FAILING TEST FIRST.**

The test you write after the code passes because the code exists, not because the behavior is right. Only a test you have WATCHED fail proves it tests anything at all.

## Seams before tests

A seam is where behavior can be observed and replaced without editing the code under test. Tests are written at seams, and **seams are agreed with the user before the first test** (in M lane this is the one-message seam confirmation from triage; in L lane the PRD records them).

- Prefer existing seams; the ideal number of new seams is one.
- Test at the highest seam that can observe the behavior — module boundary over private function.
- The interface is the test surface: test what callers see, never internal steps. A test that breaks when you refactor internals without changing behavior is testing the wrong thing.
- No test at an unconfirmed seam. If no good seam exists, that is a design problem to raise, not a mocking problem to bury.

## The loop

1. **RED** — write the smallest test for the next slice of behavior. Run it. **Watch it fail, for the expected reason.** A test that passes immediately is a bug in the test.
2. **GREEN** — write the minimum code to pass. Not the code you know you'll need later — the minimum for this test. Run; watch it pass; rerun the neighbors.
3. **COMMIT the green.** Verified work must be un-destroyable: commit at every green, or at minimum every completed vertical slice. Small commits are the ratchet that stops later edits — yours or a subagent's — from silently unwinding what already worked.
4. Repeat in **vertical slices**: each cycle cuts through the layers to deliver an observable behavior end-to-end, not one horizontal layer at a time.
5. Refactor when the code asks for it — with green tests as the net (and commit the refactor separately from behavior changes). Refactoring is not a mandatory beat of every cycle.

Wrote implementation before its test? Delete it and start from RED. Delete means delete, not comment out — code written before its test infects the test with its own assumptions.

## Rationalizations, pre-refuted

| "…" | Reality |
|---|---|
| "Too simple to test" | Simple code with a wrong assumption is where silent bugs live. The test costs one minute. |
| "I'll add tests after" | After-tests pass by construction. They document the bug, they don't catch it. |
| "The test is hard to write" | That difficulty is the design telling you the seam is wrong. Listen to it (→ raise it, or `forge-rootcause` if it's a bug). |
| "Just this once, deadline" | The Law has no deadline clause. S-lane exemption below is the only exit. |

## Scope of the Law

Applies to all production code in M/L lanes. In S lane it applies **where a test surface exists**; for genuinely untestable surfaces (one-line config, prose, static assets) `forge-verify`'s behavioral check carries the burden instead. Bug fixes always start from a failing test that reproduces the bug — that test comes out of `forge-rootcause` and lands at the proper seam.
