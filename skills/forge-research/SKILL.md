---
name: forge-research
description: Delegate an external-knowledge question to a background research agent that produces a cited note. Use when design or implementation hits a question about library behavior, API limits, ecosystem practice, or any fact outside the repo.
---

# Forge Research

Questions about the world outside the repo (library semantics, API quotas, protocol details, ecosystem conventions) get delegated to a background agent so the main line of work keeps moving. The deliverable is a **cited note**, not a chat answer that evaporates.

## Dispatch

- One research agent per question; phrase the question falsifiably ("does X guarantee Y under Z?" not "tell me about X").
- Run in the background while the interview/implementation continues on branches that don't depend on the answer.
- The agent's brief: primary sources only — official docs, source code, changelogs, issue threads by maintainers. **Follow every claim back to the source that owns it**; a blog post citing a blog post is not a source. Version-sensitive claims must name the version checked.

## The note

Written to the repo, matching whatever notes convention already exists (else `docs/notes/YYYY-MM-DD-<slug>.md`):

```markdown
# <Question>
**Answer:** the one-paragraph verdict, stated plainly.
**Confidence:** high/medium/low + what would change it.
**Evidence:** claim → source URL/file, one per line.
**Version context:** libraries/versions the answer was verified against.
```

## The write-back law

Same as prototypes: **research without write-back never happened.** Link the note from the artifact that spawned the question (PRD's Allowed APIs, issue Notes, ADR, design summary) the moment it lands. An unanswered-question placeholder in the PRD is better than a note nobody can find; a linked note is better than both.

## Trust discipline

The main session treats the note's Answer as testimony, not ground truth: before an implementation bets a one-way door on it, spot-check the top citation. Research agents summarize honestly but read hastily — the citation trail exists so verification costs seconds.
