---
name: forge-slice
description: Break a PRD into independently-executable vertical-slice issues on the local bus. Use in L lane after forge-prd, or when the user asks to split a plan into issues/tasks.
---

# Forge Slice

Cut the PRD into issues that a fresh session can pick up and finish without reading anything but the issue and the PRD. The slicing quality ceiling IS the execution quality ceiling — a slice that needs cross-issue context to understand will be implemented wrong in an isolated worktree.

## Slicing rules

- **Vertical, always.** Each issue cuts through all layers to deliver one observable behavior end-to-end. Horizontal slices ("all the models, then all the handlers") are forbidden — they defer integration risk to the last issue, where it is most expensive.
- **Tracer bullet first.** Issue 001 is the thinnest end-to-end path through the whole design — it proves the seams and surfaces integration surprises while everything is still cheap to change.
- **Prefactor before features.** If the design needs an existing structure changed, that change is its own early issue: make the change easy, then make the easy change.
- **Sized for one session** including its review and verification. Bigger → split; a 10-minute slice is fine, an open-ended one is not.
- **Independence over count.** Fewer, truly independent issues beat many entangled ones — dependencies serialize execution and kill worktree parallelism.

## Issue format

`docs/forge/issues/NNN-<slug>.md` (numbering shared with the bus):

```markdown
---
id: issue-NNN
prd: prd-NNN
status: ready        # ready | in-progress | done | blocked
depends_on: []       # issue ids; empty = parallelizable immediately
created: YYYY-MM-DD
---

## Goal
Objective: one sentence — what this slice makes better and for whom.
Done-when: the observable check that judges completion (feeds Seams & tests).
Red lines: what this slice must NOT touch or change (files, configs, behaviors).

## Deliverable
One observable behavior, phrased as what a user/caller can do after this lands.

## Behavior spec
The user stories from the PRD this slice covers (copy them in — the issue must
be self-contained). Edge cases in scope for THIS slice.

## Seams & tests
Which agreed seam(s) this slice's tests live at; what the failing-first test asserts.

## Notes for the implementer
Constraints, allowed-API pointers, anti-patterns relevant here. Behavioral
references, not file paths. Never assume the implementer saw the interview.
```

## Ordering and exit

Publish in dependency order, blockers first. Update the PRD frontmatter to `in-progress`. Present the slice map in one compact message: issue list, dependency edges, which are immediately parallelizable. Then `forge-run`.

Mid-execution discoveries that invalidate slicing (a dependency you missed, a slice that must split) → edit the bus files and say so; the bus is the single source of truth, not the original plan message.
