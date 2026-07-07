# Forge

**A lane-based agentic coding workflow for Claude Code** — 17 skills and one ~300-token session hook that route every coding task through the right amount of process: trivial fixes stay frictionless, one-way-door decisions get interviewed, multi-session builds get sliced, isolated, verified, and landed.

---

## 中文导读

Forge 是一套 Claude Code 工作流生态:任务进来先**定档**(S 小事直接干 / M 单会话功能 / L 多会话工程)并定**绳长**(监督密度:在用户的专业领域默认紧绳——逐阶段呈现 diff、领域问题路由给人;其余领域放行自流),三条**铁律**(先有失败测试、先查根因、先验证再声称完成)只在触发点咬合而不全程挡路;设计访谈的产出沉淀为仓库级词汇表与 ADR,大工程用本地 markdown 总线切片、worktree 隔离并行执行;还有一个 **retro 自我进化环**——流程失误被记录为语料,积累后驱动 Forge 修订自身规则。

它诞生于对 [superpowers](https://github.com/obra/superpowers)(纪律机器,但仪式一刀切)与 [mattpocock/skills](https://github.com/mattpocock/skills)(可组合原语,但全靠手动串联)两套生态的完整审计:两者的强弱项几乎互为镜像,Forge 取两者之长,并补上双方共同的盲区(分级强度、运行时行为验证、强制回写、自我进化)。

**安装**:`git clone` 本仓库 → `./install.sh` → 把 README 下方 Install 节的 hook 片段合并进 `~/.claude/settings.json` → 重启会话。或者更省事:让你的 Claude Code 读这个仓库,说"帮我装上"。

---

## Why Forge exists

Forge was born from a side-by-side audit of two excellent but opposite ecosystems:

- **[obra/superpowers](https://github.com/obra/superpowers)** is a *discipline machine*: an always-on router, hard approval gates, Iron Laws ("no production code without a failing test"), evidence-based completion claims. Its cost: **every task pays full ceremony** — a config tweak walks the same 9-step pipeline as a subsystem rewrite — and everything it learns evaporates when the session ends.
- **[mattpocock/skills](https://github.com/mattpocock/skills)** is a *box of composable primitives*: thin user-invoked wrappers over shared model-invoked disciplines, durable repo knowledge (glossary + ADRs), an issue tracker as cross-session memory. Its cost: **nothing advances by itself** — every stage transition is typed by hand — and nothing verifies that the built thing actually runs.

Their strengths and gaps are nearly mirror images. Forge is the synthesis, plus the pieces *both* were missing:

1. **Graduated intensity** — process scaled to risk, decided automatically, announced, never waited on.
2. **Behavioral verification** — drive the real surface (CLI, endpoint, page), not just test exit codes.
3. **Write-back as law** — both parents already ask you to save prototype/research answers; Forge hardens this into law: backlink to the artifact that asked the question, and a ban on absorbing prototype code into production (the parents' genuinely shared blind spot is runtime verification, not write-back).
4. **Runtime self-evolution** — process failures and escaped defects become a training corpus that revises Forge's own rules while it runs (superpowers self-improves too, but at design time — skill-TDD and an eval framework; Forge closes the loop on live usage).
5. **The leash** (v0.2, after [Slepak's Short Leash method](https://blog.okturtles.org/2026/07/short-leash-ai-method/)) — oversight density as a second knob, orthogonal to lanes and scaled to the *expertise gradient*: in domains where the user out-knows the model (where code can run fine yet be subtly wrong), the chain stops at every stage boundary for diff inspection and routes domain questions to the human; elsewhere it flows. Announce-and-go governs process transitions; the leash governs content checkpoints.

## How it compares

| Dimension | superpowers | mattpocock/skills | Forge |
|---|---|---|---|
| Intensity control | one-size-fits-all gates | manual skill picking | two knobs: lanes (process) + leash (oversight) |
| Discipline (TDD/debug/verify) | ✅ Iron Laws, always | opt-in, siloed | Iron Laws at trigger points |
| Durable knowledge | committed specs/plans, but no glossary/ADR | ✅ CONTEXT.md + ADR | ✅ same, updated inline |
| Cross-session coordination | ❌ | issue tracker (GitHub) | local markdown bus (offline-first) |
| Isolation & parallelism | worktrees, serial only | ❌ collides on worktree | worktree per slice, parallel |
| Runtime behavior check | ❌ test-exit-code centric | ❌ diff-review centric | ✅ behavioral drive in verify |
| Chain advancement | forced, always | fully manual | announce-and-go, user can veto |
| Self-improvement | design-time (skill-TDD + eval framework) | manual (.changeset design log) | ✅ runtime: escaped-defect corpus → rule diffs |

## Architecture

```
SessionStart hook (~300 tokens: lane rules + Iron Law triggers)
        │
   forge-triage ── S ──▶ just do it ──▶ forge-verify
        │
        ├────── M ──▶ forge-interview (one-way doors only)
        │             └▶ forge-tdd ▶ forge-review(lite) ▶ forge-verify
        │
        └────── L ──▶ forge-interview (full) ▶ forge-prd ▶ forge-slice
                      └▶ forge-run (worktree per issue, 2-stage review, parallel)
                         └▶ forge-land (merge train ▶ options ▶ cleanup)

Iron Laws (any lane, trigger-enforced):
  I.  implementation code  → forge-tdd        (failing test first, at agreed seams)
  II. bug / unexpected     → forge-rootcause  (red loop before any fix)
  III. "done" / commit     → forge-verify     (fresh evidence + behavioral drive)

Cross-cutting: forge-glossary (CONTEXT.md + ADRs) · forge-prototype / forge-research
(side-quests with mandatory write-back) · forge-retro (capture → evolve)
```

**The 17 skills**

| Skill | Role |
|---|---|
| forge-triage | entry point: size into lane, announce, go |
| forge-interview | design-tree interview, recommended answer per question |
| forge-glossary | CONTEXT.md glossary + 3-condition ADRs |
| forge-tdd | Iron Law I — seam-first red/green |
| forge-rootcause | Iron Law II — red-capable loop, ranked hypotheses |
| forge-verify | Iron Law III — fresh evidence + behavioral drive |
| forge-review | two-axis review: standards ∥ spec fidelity |
| forge-prd | conversation → PRD, with Allowed-APIs discovery |
| forge-slice | PRD → vertical-slice issues on the local bus |
| forge-run | controller: worktree per issue, subagent implement + 2-stage review |
| forge-land | merge train, integration options, provenance cleanup |
| forge-prototype | throwaway code answers one design question |
| forge-research | background cited research notes |
| forge-retro | the evolution loop: capture misfires, revise Forge from corpus |
| forge-handoff | cross-session baton: checkpoint task state to the bus, verified resume |
| forge-arch | proactive architecture health: defect-gravity-driven, candidates only |
| forge-experiment | hypothesis-driven campaigns: approved metric, calibrated measurement, negative results first-class |

**File conventions**: PRDs/issues live on the in-repo bus `docs/forge/{prd,issues}/` (frontmatter state machine, offline-first, greppable). Glossary at `CONTEXT.md`, ADRs in `docs/adr/`. Worktrees under `.forge/wt/`. The retro corpus is machine-local at `~/.claude/forge/retro/`.

## Install

Requires Claude Code with skills + hooks support, on any OS (paths below assume Linux/WSL/macOS).

```bash
git clone https://github.com/erra-yg/forge.git && cd forge
./install.sh
```

Then add two hooks to `~/.claude/settings.json` (merge into your existing `hooks` — don't overwrite the file): the router injection, and the invocation-fidelity ledger (deterministic telemetry that forge-retro's evolve pass audits to catch skills that should have fired but didn't):

```json
{
  "hooks": {
    "SessionStart": [
      { "hooks": [ { "type": "command", "command": "cat /home/<user>/.claude/forge/L0-router.md" } ] }
    ],
    "PostToolUse": [
      { "matcher": "Skill", "hooks": [ { "type": "command", "command": "/home/<user>/.claude/forge/bin/log-skill.sh" } ] }
    ]
  }
}
```

Restart your Claude Code session. Verify: mention a small change task — the agent should open with a lane call ("S lane: …").

> Shortcut: point your Claude Code at this repo and say *"read the README and install Forge"*. The hook merge is exactly the kind of judgment-required edit an agent does better than a script.

**Uninstall**: remove `~/.claude/skills/forge-*`, `~/.claude/forge/`, and the hook entry.

> Note: Forge assumes it owns the workflow. Running it alongside superpowers (or other auto-triggering workflow plugins) makes two routers fight over the same tasks — disable one.

## Status

**v0.1 — design-complete, entering battle-testing** (founded 2026-07-04). The skill set was written in one pass from a full audit of both parent ecosystems, then installed as the author's daily driver. Expect rules to change: that's the design. Forge revises itself through `forge-retro` — process misfires are logged as a corpus, and rule changes require ≥2 independent entries pointing at the same root cause. See [forge-home/CHANGELOG.md](./forge-home/CHANGELOG.md) for the revision trail.

Syncing a live install back into this repo: `./pack.sh` (treats `~/.claude` as the single source of truth; the repo is a snapshot).

## Acknowledgements

Forge stands on two ecosystems it studied closely and borrows from shamelessly, with gratitude:

- [obra/superpowers](https://github.com/obra/superpowers) — the Iron Law formulation, anti-rationalization tables, verification-as-evidence, worktree finishing discipline.
- [mattpocock/skills](https://github.com/mattpocock/skills) — the grilling interview primitive, domain-modeling (glossary/ADR) discipline, vertical-slice issues, thin-wrapper-over-primitive architecture.
- [thedotmack/claude-mem](https://github.com/thedotmack/claude-mem) — the documentation-discovery ("Allowed APIs") defense against API hallucination, adopted in forge-prd.
- Greg Slepak's [Short Leash method](https://blog.okturtles.org/2026/07/short-leash-ai-method/) — the expertise-gradient argument behind the leash knob, commit-per-green, and the AI-disclosure PR gates (v0.2).

## License

[MIT](./LICENSE)
