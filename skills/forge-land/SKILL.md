---
name: forge-land
description: Merge train and finishing — integrate completed issue branches, final verification, present integration options, clean up. Use when forge-run completes all issues, or when finished work on a branch needs integrating.
---

# Forge Land

Integration is where independently-green slices meet each other for the first time. Land assumes nothing carried over from run: every claim is re-verified against the integrated state.

## The merge train

1. **Integration branch.** Create `forge/land-prd-NNN` from the base the worktrees branched from.
2. **Merge in dependency order** — the same order the issues declared, blockers first. After EACH merge: build + affected tests. A conflict or red suite stops the train at that car: fix it there (`forge-rootcause` for genuine breakage — cross-slice interaction bugs found here are normal and are exactly what the train exists to catch), then continue.
3. **Full gate on the assembled train:** complete suite, typecheck/lint, and `forge-verify`'s behavioral drive of the PRD's primary user stories — end-to-end, on the integrated branch. Slices that each worked alone and break together are a land finding, not a reopened issue; fix on the integration branch.

## Integration options

Verification green → present exactly these options, recommendation first based on repo context (remote exists? user's review habits?):

1. **Merge to main locally** — solo/local projects, default when no remote.
2. **Push + PR** — repos with a remote and review flow (offer babysit-style follow-up if available). For PRs to public repos or repos with other maintainers, two extra gates: an `## AI Disclosure` section in the PR body stating AI assistance, and the submitter's **line-by-line self-review of the full diff** before it goes up — an AI-assisted PR is a PR from an AI with human assistance; the human must understand every line they put their name on.
3. **Keep the branch** — user wants manual inspection first.
4. **Discard** — requires the user to type `discard` literally; irreversible deletions never ride on an ambiguous "yes".

## Cleanup (after integration, never before)

- Remove worktrees this run created under `.forge/wt/` (provenance rule: never touch worktrees you didn't create), delete merged `forge/issue-NNN` branches.
- Bus bookkeeping: PRD `status: done`; any surviving `blocked` issues stay on the bus with a one-line note on why they didn't land.
- Residue pass: glossary terms or ADR-worthy decisions that crystallized during integration → `forge-glossary`. Process friction during the whole L run → `forge-retro` capture while it's fresh.

## Partial lands

Landing a subset (some issues blocked) is legitimate: the train takes only `done` issues whose dependencies are all aboard. State explicitly what shipped and what remains — a partial land honestly reported beats a full land falsely implied.
