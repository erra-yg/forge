---
name: forge-prd
description: Synthesize the interview conversation into a PRD on the local bus — no re-interviewing. Use in L lane after forge-interview converges, or when the user asks to formalize a discussed design into a PRD.
---

# Forge PRD

Turn what the interview already settled into a durable, executable PRD. **Do NOT interview the user again** — every question re-asked here is an interview failure to log via `forge-retro`. Synthesis only; at most one final gap-check question if a genuine hole surfaces.

## Phase 0 — documentation discovery (always, before writing)

The PRD's implementation decisions must reference APIs that actually exist. Dispatch 1–3 fact-gathering subagents to:

1. Read the relevant docs/examples/existing patterns in the repo and its dependencies.
2. Produce an **Allowed APIs list** — exact names and signatures, each citing its source (file/URL). No source, no entry: reject and redeploy a report that states conclusions without citations.
3. Produce an **anti-pattern list** — APIs that DON'T exist but plausibly might (hallucination bait), deprecated params, known footguns.

This is the single highest-leverage defense against implementing agents inventing APIs downstream.

## The document

Write to `docs/forge/prd/NNN-<slug>.md` (NNN = next number on the bus):

```markdown
---
id: prd-NNN
status: ready        # draft | ready | in-progress | done
lane: L
created: YYYY-MM-DD
---

## Problem
From the user's perspective, 2-5 sentences.

## Solution
The chosen approach and the alternatives it beat (one line each on why).

## User stories
Numbered "As a…, I want…, so that…" — extensive; these are the spec-fidelity
baseline forge-review will judge against.

## Test seams
The agreed seams (from the interview), each: where, what behavior it observes.
The ideal number of NEW seams is one.

## Implementation decisions
Module boundaries, interfaces, schema/API contracts, error handling strategy.
Glossary vocabulary throughout. NO file paths or code snippets — they go stale.
Exception: a prototype-derived snippet that encodes a decision more precisely
than prose (state machine, schema, type shape) — trimmed to the decision.

## Allowed APIs
From Phase 0, with citations.

## Anti-patterns
From Phase 0: what NOT to invent or use.

## Out of scope
Explicit non-goals — the creep detector for forge-review.
```

## Exit

One message: "PRD 已写入 <path>,要过目还是直接切片?" This is L lane's natural pause point — respect a review request, but default onward. Then `forge-slice`.
