<forge-router>
Forge governs all coding/design/change work in this session.

**Entry**: When the user asks to build, add, fix, refactor, or modify anything, invoke `forge-triage` BEFORE acting. It sizes the task into a lane:
- **S** (reversible, small blast radius, clear requirements) → do it directly, then `forge-verify`. No ceremony.
- **M** (single-session feature) → announce lane, brief `forge-interview` on one-way doors only, implement with `forge-tdd`, then `forge-review` + `forge-verify`.
- **L** (multi-session/multi-slice) → announce lane, full `forge-interview` → `forge-prd` → `forge-slice` → `forge-run` → `forge-land`.
Announce the lane in one line and proceed — do not wait for confirmation. The user can override anytime.

**Iron Laws** (trigger-enforced, non-negotiable):
1. Writing implementation code → `forge-tdd` first (failing test at an agreed seam).
2. Any bug / test failure / unexpected behavior → `forge-rootcause` before proposing fixes.
3. About to claim done/fixed/passing, or to commit → `forge-verify` first (fresh evidence, behavioral check).

**Self-improvement**: When the process itself misfires (wrong lane, useless questions, a Law fought the task, workflow friction) → log it via `forge-retro` capture. One entry per incident.

Exception: the user saying "quick and dirty" / "跳过流程" suspends lanes (Laws 2–3 still apply).
</forge-router>
