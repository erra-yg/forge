---
name: forge-arch
description: Proactive architecture health pass — find deepening opportunities, seam problems, and duplicated concerns before they become defects. Use when asked to audit architecture or codebase health, when escaped-defect entries cluster in one area, or when forge-rootcause's three-strike rule fires.
---

# Forge Arch

Retro watches process entropy; this skill watches **code entropy**. It produces *candidates, never changes* — every improvement it proposes enters through `forge-triage` like any other task, because architecture work is usually M/L and interview-worthy. A skill that both diagnoses and operates grades its own homework.

## Evidence sources, in priority order

1. **Defect gravity** — `escaped-defect` retro entries and `forge-rootcause` post-mortems clustering in one module. A module that keeps breaking is telling you its boundaries are wrong; this is the strongest architecture signal and the one that makes this skill Forge-native rather than aesthetic.
2. **Three-strike escalations** — forge-rootcause hands off here when three fix attempts fail in the same area.
3. **On-demand sweep** — the user asks; the code itself is the evidence.

An architecture pass with no defect evidence and no user request is YAGNI — this is not scheduled busywork.

## The pass

Work module by module with the deep-module vocabulary:

- **Seam audit** — where do tests struggle to attach? A behavior only testable through mocking three layers marks a missing seam. One adapter is a hypothetical seam; two adapters are a real one.
- **Depth check** — deep modules hide a lot of behavior behind a small interface. Wide-shallow modules (big interface, thin logic) and pass-through layers are flattening candidates.
- **Deletion test** — if this module vanished, what would actually break? Code nothing would miss is a removal candidate; code everything would miss deserves its interface budget.
- **Duplicated concerns** — the same responsibility implemented in 2+ places drifts apart silently; name the canonical home.
- **Reach-through** — modules using other modules' internals instead of their interfaces.

## Output

A short ranked report — top 3–5 opportunities, no more. Each: location, the smell, **the evidence** (which defect cluster, which seam pain, which strike-out), expected payoff, recommended lane. Then stop. Chosen items go to `forge-triage`; glossary-worthy boundary decisions crystallizing during the pass go through `forge-glossary` as usual.
