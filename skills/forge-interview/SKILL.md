---
name: forge-interview
description: Design-tree interview that turns a rough idea into a settled design. Use for lane M (one-way-door mode) and lane L (full mode) after forge-triage, or when the user asks to stress-test, grill, or sharpen a plan.
---

# Forge Interview

Walk the design tree with the user until every load-bearing branch is resolved. The tree: every plan branches into decisions, decisions depend on each other. Descend in dependency order — an early answer reshapes later questions, which is why questions go one at a time and never as a questionnaire.

## Before the first question

1. **Explore first.** Read the relevant code, CONTEXT.md, docs/forge/ bus, recent commits. Every question the codebase can answer, answer by reading it — asking the user what the code already knows wastes their attention and your credibility.
2. **Scope check.** If the request contains multiple independent subsystems, say so before refining details; decompose into sub-projects and interview the first one. Refining a project that needs splitting is the most expensive interview failure.
3. **Approaches are the root node.** Propose 2–3 genuinely different approaches with trade-offs, recommendation first. The chosen approach determines which branches exist below it.

## Question discipline

- **One question per message**, via AskUserQuestion where options are enumerable: recommended option first with "(推荐)", concrete consequences in each description.
- **Every question carries your recommended answer.** You have context the user is paying you to apply; a question without a recommendation is work you pushed back onto them.
- **Depth follows the lane:**
  - **M / one-way-door mode**: interview ONLY hard-to-reverse or genuinely ambiguous decisions. Reversible details — decide yourself, state the decision inline ("默认用 X,可改"), move on.
  - **L / full mode**: walk every branch, but a branch whose resolution follows from an earlier answer is stated, not asked.
- **Terminology work is inline.** When a term resolves or conflicts, apply `forge-glossary` at that moment, not at the end.
- **Empirical questions get prototypes, not debate.** If a 30-minute throwaway would answer it better than three rounds of speculation, invoke `forge-prototype` and return with the answer.
- **Unknown facts get research.** External-knowledge questions (library behavior, API limits) → `forge-research` in the background while the interview continues on other branches.

## Convergence and exit

The interview is done when remaining unknowns are all reversible details. Then:

1. Present the design compactly — sections scaled to their complexity, not a fixed template. Cover: chosen approach and why, module boundaries and interfaces, data flow, error handling, test seams.
2. One approval question: anything to revisit?
3. Exit by lane: **M** → straight to implementation (seams → `forge-tdd`). **L** → `forge-prd`.

No design doc file is written in M — the durable residue is glossary entries, ADRs, and the design summary in conversation (claude-mem captures the rest). L's durable form is the PRD, produced next.

## Anti-patterns

- Twenty questions about reversible details (log to `forge-retro` if you catch yourself — it means the lane or mode was wrong).
- Asking before exploring ("what framework is this?" — read the lockfile).
- A question list dumped in one message.
- Advancing while a load-bearing branch is unresolved because the user seemed impatient — name the risk instead: "剩 X 未定,拍错代价是 Y,要现在定还是先走?"
