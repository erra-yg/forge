# Forge Changelog

Revision log for the Forge workflow ecosystem. Each entry: date, files touched, rationale, retro-entry refs.

## 2026-07-04 — v0.1 initial forge
- Created 14 skills (forge-triage/interview/glossary/verify/tdd/rootcause/review/prd/slice/run/land/prototype/research/retro) + L0 router hook.
- Design decisions from the founding grill: superpowers disabled (uninstall at full maturity); lightweight hook L0; model-decides lanes, announce-and-go; local markdown bus (docs/forge/); English skill bodies; forge- prefix; retro self-improvement loop added at user request.

## 2026-07-04 — v0.1.1 forge-handoff
- Added 15th skill forge-handoff (cross-session baton on the bus); triage resume check; L0 continuity trigger. Retro ref: 2026-07 design-gap #1 (audit taxonomy lacked an "interruption" row).

## 2026-07-05 — v0.2 the leash (Short Leash absorption)
- Source: Greg Slepak, "The Short Leash AI Coding Method For Beating Fable" (blog.okturtles.org, 2026-07-02). Synthesis: leash = oversight density as a second knob orthogonal to lanes; announce-and-go restated as governing process transitions only, content checkpoints belong to the leash.
- forge-triage: leash section (tight/loose, expertise-gradient + plausibly-wrong criteria, ~/.claude/forge/leash.md config, ask-once onboarding for new users); universal stage-boundary diff digest.
- forge-tdd: COMMIT-the-green step (ratchet against silent unwinding).
- forge-review: human-judgment queue (domain questions routed to human, never auto-resolved).
- forge-land: outward-PR gates (AI Disclosure section + submitter line-by-line self-review).
- L0 router: leash announcement wired into Entry.
- Rejected: auto-logging user interruptions as leash-misjudgment retro entries — interruptions are ambiguous (often the user correcting their own prompt, not the agent); retro capture stays deliberate, never inferred.
