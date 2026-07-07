---
name: forge-experiment
description: Hypothesis-driven experiment campaign against an explicit metric — parameter sweeps, optimization runs, systematic comparisons. Propose it when a question needs many controlled trials; run it ONLY after the user approves objective, metric, and boundaries.
---

# Forge Experiment

A campaign of controlled trials against a metric, with the discipline that makes unattended exploration trustworthy. Where `forge-prototype` answers one design question in minutes, a campaign sweeps a space over hours — possibly overnight, possibly across sessions.

## The approval gate — the one exception to announce-and-go

**A campaign never self-starts.** Starting one is a budget commitment, and budget commitments belong to the user — same class as irreversible actions. Suggest a campaign (from interview, arch, rootcause, or domain work) in one fixed shape, then WAIT:

> "这适合一轮实验战役:目标 X,指标 Y,预估 N 次实验 × 单次成本量级 Z——开吗?"

The campaign opens with the user-approved contract (Karpathy's triple):
- **Objective** — what better means, in one sentence.
- **Metric** — how done/better is judged. In tight-leash domains the metric's *domain meaning* requires explicit user sign-off (the agent can rank configs by a number; whether the number means anything physically is the operator's call). Initial hypothesis list too.
- **Boundaries** — files/configs/environments that must not be touched; autonomy color (below).

Numbers like interim-synthesis period or early-stop patience are set per-campaign at opening, judged by scale — never hard-coded defaults (word-budget-style fake rigor is exactly what campaigns have disproven).

## Phase 0 — calibrate the measurement

Before ANY experiment: measure the baseline twice. If repeated measurement of the same configuration disagrees materially, **fix the measurement first** — every conclusion downstream of a broken instrument is noise. Measurement changes mid-campaign are logged, and affected experiments rerun. (Field report: a 25-experiment overnight run surfaced three measurement bugs; self-correction is expected, silent self-correction is forbidden.)

## The loop

Each experiment is four mandatory fields, appended to the state file BEFORE and AFTER running:

```
### E-NNN <one-line hypothesis>
- hypothesis: falsifiable, with expected direction and rough magnitude
- prediction: what the metric should do if the hypothesis holds
- result: actual measurement (verbatim numbers, not adjectives)
- verdict: supported / refuted / inconclusive — and what it kills or opens
```

Rules:
- **One variable per experiment** (rootcause's instrumentation discipline). Interaction effects get explicit combination experiments only after their single-variable results exist.
- **Order the queue by information value** — run the experiment that best splits the surviving hypothesis space next, not the easiest one.
- **Interim synthesis** every K experiments (K set at opening): which hypotheses are dead, what space remains, continue or early-stop. Consecutive no-new-information runs force a synthesis.
- **Negative results are first-class.** Refuted paths get the same four fields, the same care. The excluded-paths list is often the campaign's most valuable output — it is money future projects don't re-spend.
- Experiments run isolated (worktree or scratch dir per the boundaries). Experiment code is throwaway: TDD-exempt like prototype code, and equally banned from production absorption.

## State file — on the bus

`docs/forge/experiments/YYYY-MM-DD-<slug>.md`, frontmatter: `status: running|paused|done`, objective, metric, boundaries, budget (max experiments / time), counts. Append-only body. The file IS the campaign: interrupted sessions resume by reading it (handoff-compatible); a future scheduled loop wakes, reads it, runs a batch, writes back, stops at the stop condition — the design is loop-ready without modification.

## Autonomy colors

- 🟢 loose-leash domain + read-only-or-isolated writes → may run fully unattended (overnight).
- 🟡 tight-leash domain → interim syntheses are presented at checkpoints, not just a final report.
- 🔴 touches production config / external services → never runs unattended, each such experiment individually confirmed.

## Landing

The campaign ends at its stop condition (budget hit, space exhausted, or early-stop synthesis). Then:
1. **Rerun the winner under independent `forge-verify`** — a single campaign measurement is testimony, not evidence. No verdict without the confirmation run.
2. **Write-back law** (as prototype): winner → ADR/PRD/issue with the config diff; excluded paths → the report's dead-ends section; the campaign file marked `done`. A campaign whose conclusion lives only in the state file never happened.
3. Winner lands in production through the normal lane — full discipline resumes, no experiment code rides along.
