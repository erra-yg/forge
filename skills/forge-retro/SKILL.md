---
name: forge-retro
description: Forge's self-improvement loop — capture process failures as structured entries, and evolve the forge skills from the accumulated corpus. Use to log any workflow misfire (wrong lane, useless questions, an Iron Law fought the task, ceremony friction), and when the user asks to review or improve Forge itself.
---

# Forge Retro

Forge treats its own process failures the way `forge-rootcause` treats bugs: evidence first, then a fix in the right place. The corpus this skill accumulates is the training data for every future revision of Forge — an unlogged misfire is a lesson thrown away.

## Mode 1 — capture (cheap, in the moment)

When the PROCESS misfires — not the code. Signals: lane misjudged (either direction), interview asked questions whose answers didn't change anything, an Iron Law's letter fought the task's spirit, a stage produced an artifact nobody consumed, the user overrode or bypassed a step, ceremony visibly slowed a simple thing.

Append one entry to `~/.claude/forge/retro/YYYY-MM.md` (create monthly file as needed):

```markdown
## YYYY-MM-DD <one-line title>
- project: <name>  lane: <S/M/L>  stage: <skill name>
- what happened: 1-3 sentences, concrete (中文 fine)
- root cause: why the PROCESS produced this — rule too broad/narrow,
  missing trigger, wrong default. Never "user was wrong" or "model was lazy".
- proposed change: the specific rule/threshold/wording to adjust, if visible now
```

Capture costs one minute and happens inline — do not batch to session end, do not skip because the incident feels small. Two small entries about the same rule ARE the signal.

## Mode 2 — evolve (deliberate, user-initiated)

When the user asks to improve/review Forge:

1. **Read the corpus** (`~/.claude/forge/retro/*.md`) + `~/.claude/forge/CHANGELOG.md` for what was already tried.
2. **Cluster by root cause**, not by symptom. The bar: **≥2 independent entries pointing at the same rule = actionable signal; 1 entry = watch item** (unless severe). Resist redesigning Forge around a single bad day.
3. **Propose concrete diffs** to specific skill files — quoted current wording → proposed wording → which entries justify it. Rule changes beat rule additions; Forge accretes discipline, it must not accrete bureaucracy. Prefer: adjust a threshold, sharpen a trigger, delete a step that never fired.
4. Apply approved diffs to `~/.claude/skills/forge-*/SKILL.md` (and `~/.claude/forge/L0-router.md` — keep it ≤300 tokens, something must leave if something enters).
5. **Log to CHANGELOG.md**: date, files touched, one-line rationale, entry references. Mark consumed entries `[addressed: <date>]` in place — never delete corpus.

## The meta-rule

Retro follows its own law: an evolve pass that changes nothing is a legitimate outcome and gets logged as such. Changes without corpus evidence are speculation — that is what this skill exists to replace.
