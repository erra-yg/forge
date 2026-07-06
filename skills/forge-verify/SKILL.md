---
name: forge-verify
description: Iron Law III — no completion claim without fresh evidence. Use before saying done/fixed/passing/works, before any commit, and before marking any issue or task complete.
---

# Forge Verify

**IRON LAW: NO COMPLETION CLAIM WITHOUT FRESH VERIFICATION EVIDENCE.**

Claiming work is complete without verifying it is not efficiency — it is a false report. This gate runs every time, however confident you feel; confidence without evidence is exactly the failure mode this Law exists to stop.

## The gate

1. **Identify** what "working" means for THIS change — the observable behaviors the request implies, not just "tests pass".
2. **Run** the checks, freshly, now. Stale output from earlier in the session is not evidence; the code has changed since.
3. **Read** the output. Actually read it — a green exit code with a warning you skipped is how regressions ship.
4. **Verify behaviorally.** Tests and typechecks prove the code agrees with itself. Where a runtime surface exists, drive it: run the CLI on real input, hit the endpoint, load the page, execute the script end-to-end, and observe the actual output. A green suite over a broken flow is the shared blind spot of every test-centric process — this step is what makes Forge's verification different.
5. **Claim** only what the evidence shows, with the evidence: "验证:`cmd` → <actual output>". If something failed, report it plainly with the output — a failed check honestly reported is a good outcome of this gate, not a bad one.

## The deterministic floor

Deterministic gates — test suite, typecheck, lint, build — are the floor; LLM judgment (yours or any reviewer's) is a semantic layer ON TOP of them, never a substitute. **A red deterministic signal cannot be overruled by model judgment**: "that failing test doesn't matter" is not a verdict anyone in this pipeline may issue. Either the code is wrong (fix it) or the test is wrong (prove it, say so explicitly, fix the test) — a red floor always resolves to a change, never to a waiver.

## Two-tier depth

- **S lane / small diffs:** one behavioral check of the changed surface + affected tests. Minutes, not ceremony.
- **M/L lanes / pre-commit / pre-land:** full relevant test suite + typecheck/lint + behavioral drive of each changed flow. In `forge-run`, the verifying agent must be a different context than the implementing agent — implementers grade their own homework too generously.

## Forbidden vocabulary

Until the gate has run, these words are lies waiting to be discovered: "should work", "probably fine", "looks correct", "完成了", "修好了", premature "Great!/完美". If a claim contains "should", it is not a claim — it is a hypothesis, and hypotheses go through the gate.

## Verifying subagent reports

Never relay a subagent's "success" as your own claim. Check the diff exists (`git diff --stat`), spot-check the substance, rerun its key check yourself. An agent that reports completion is providing testimony, not evidence.

## When evidence can't be produced

Some effects genuinely can't be verified in-session (deploy behavior, another machine's environment). Say so explicitly and name what WAS verified: "本地行为已验证(evidence);X 需要部署后确认". Unverifiable is a status, not a license to claim success.
