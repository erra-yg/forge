---
name: forge-glossary
description: Maintain the project's domain language — CONTEXT.md glossary and ADRs. Use when a term is coined, resolved, or conflicts with existing usage, or when a hard-to-reverse decision crystallizes during design, interview, debugging, or review.
---

# Forge Glossary

The durable-knowledge primitive. Other forge skills invoke this whenever language or decisions crystallize. Its two artifacts outlive every session; treat them as the project's accumulated intelligence.

## CONTEXT.md — the glossary

Lives at repo root. **A glossary and nothing else**: canonical terms, one-per-entry, with a definition and (where sharpening happened) an `Avoid:` line listing the fuzzy synonyms it replaces. No implementation details, no specs, no scratch notes — those rot; vocabulary compounds.

Format per entry:

```markdown
## Term
Definition in one or two sentences, in the project's own words.
Avoid: looser synonyms this term replaces.
```

**Behaviors:**
- **Update inline, the moment a term resolves.** Never batch to end of session — batched updates get skipped.
- **Challenge conflicts immediately.** User's usage contradicts the glossary → surface it: "CONTEXT.md defines X as …, but you seem to mean Y — which is it?"
- **Sharpen fuzzy language.** Overloaded word ("account", "session", "task") → propose the precise term and record it.
- **Cross-reference code.** When the user asserts how something works, check whether the code agrees; surface contradictions rather than silently recording the claim.
- Create the file lazily — first resolved term creates it.

## ADRs — decisions worth remembering

`docs/adr/NNNN-slug.md`, numbered sequentially, created lazily. An ADR is 3–10 sentences: context, the decision, the alternative that lost and why.

Write one ONLY when all three hold:
1. **Hard to reverse** — changing your mind later costs real work.
2. **Surprising without context** — a future reader would ask "why on earth this way?"
3. **A real trade-off** — genuine alternatives existed and one was chosen for reasons.

Any condition missing → no ADR. Most sessions produce zero ADRs and several glossary entries; that is the intended shape. Post-mortems from `forge-rootcause` and answers from `forge-prototype` that meet the three conditions land here.
