---
name: forge-prototype
description: Answer one design question with throwaway code instead of debate. Use when an interview or design discussion hits an empirically-answerable question — behavior, feasibility, performance, API shape, UI feel.
---

# Forge Prototype

When a design question can be settled by 30 minutes of throwaway code, the prototype beats another round of speculation — and the ANSWER, not the code, is the deliverable.

## Rules of the game

- **One question per prototype**, stated in writing before the first line: "Q: does X hold under Y?" A prototype answering three questions answers none of them cleanly.
- **Throwaway from birth.** Build in the scratchpad or a `proto-` temp dir, never inside `src/`. First line of the entry file: `// THROWAWAY prototype — answers: <question>. Do not import.` No error handling, no persistence, no polish, no tests — those are production concerns and this is not production.
- **One command to run.** If demonstrating the answer takes a setup ritual, the prototype has failed its only UX requirement.
- **Logic questions** → smallest runnable script printing the observable answer. **UI/feel questions** → toggleable variants side by side, because "which feels right" needs contrast to answer.
- **Timebox it.** A prototype that grows past its timebox is answering "can I build this?" — which was not the question. Stop and report what was learned.

## The write-back law

**A prototype without write-back never happened.** Before deleting (and deletion is the default end state):

1. Record the answer IN the artifact that asked the question — the ADR (via `forge-glossary` if it meets the three conditions), the PRD's Implementation decisions, the issue's Notes, or the interview's design summary.
2. If a snippet encodes the decision more precisely than prose (state machine, schema, type shape) — inline the trimmed snippet there, marked as prototype-derived.
3. Then delete. Absorbing prototype code wholesale into production is forbidden: production code goes through `forge-tdd`, and prototype code was exempted from every discipline precisely because it would die.

## Session hygiene

Big prototypes that need their own session: hand off with the question + repo pointers, and bring back ONLY the answer + snippet. The prototype session's context does not merge back.
