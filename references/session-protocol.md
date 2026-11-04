# Session Lifecycle Protocol

Applies to any stateful task—technical or non-technical.

---

## A. Session Start / Resume

1. Confirm the **current task**, expected deliverables, allowed write scope, approval gates, and agent identity.
2. Read active workspace instructions (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md` if present) and canonical docs. Flag any contradiction between canonical docs and older memory cards; trust current verified state and owner instructions over stale memory.
3. Locate `memory/MEMORY.md` (or the workspace's canonical index). If absent, do not spawn a parallel memory store unprompted.
4. If memory uses Git or symlinks/junctions, verify link target and repo status per [`git-sync.md`](git-sync.md).
5. Scan `memory/MEMORY.md` and open **only the cards relevant to the current task** plus the latest checkpoint/handoff.
6. Check for uncommitted WIP by other agents (`git status --short`). Never overwrite or absorb foreign WIP.

---

## B. During the Session

- Stay strictly within scope; log out-of-scope findings separately (`no-unscoped-delete`).
- Separate `observed`, `inferred`, `proposed`, `decided`, `completed`, `verified`, and `published`.
- Checkpoint progress to `handoffs/latest.md` ([`../templates/checkpoint.md`](../templates/checkpoint.md)) after verified milestones, key decisions, or right before risky operations.
- Halt at approval gates before deploying, publishing, or performing irreversible actions.

---

## C. Session Close / Handoff

- [ ] Original request compared against actual deliverables.
- [ ] `Completed`, `Verified`, `Pending`, and `Proposed` items clearly separated.
- [ ] Verification commands and empirical results cited with exact paths.
- [ ] Durable lessons/decisions saved to atomic cards and indexed in `memory/MEMORY.md` (without duplication).
- [ ] `CHANGELOG.md` updated with agent attribution, rationale, verification results, and real commit SHA.
- [ ] Staged diff inspected (`git diff --cached`) before committing; sync status reported truthfully.
- [ ] Handoff leaves a concrete next step so the next session needs zero chat history.
