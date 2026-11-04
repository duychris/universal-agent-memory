# Multi-Agent & Cross-Account Coordination

## 1. Core Principle

A shared folder or repository **does not** create telepathic real-time memory across models. Each agent session only knows what it has actually read from an accessible store.

Every collaborative task must clarify:
- **Identity:** Recognizable agent label (`[Claude]`, `[Codex]`, `[Gemini]`, `[Antigravity]`).
- **Role:** `implementer`, `researcher`, `reviewer`, or `coordinator`.
- **Scope:** Explicit list of files, topics, or deliverables the agent is allowed to touch.
- **Permissions:** Read, draft, commit, push, approve, or publish (never inferred from role alone).

---

## 2. Independent Cross-Review Protocol (One Implements, Another Reviews)

Cross-review is **not** "one AI agreeing with another AI's summary."

1. **Implementer responsibilities:**
   - Work in an isolated branch or `git worktree` whenever possible.
   - Commit all changes cleanly before requesting review (never leave uncommitted WIP in a shared worktree).
   - Run all relevant tests/benchmarks against ground-truth cases before claiming completion.
2. **Reviewer responsibilities:**
   - Inspect the **raw diff, primary sources, and actual test outputs** independently—never rely on the implementer's prose summary.
   - Check for regressions (e.g., linear interpolation across old step tiers pulling mid-tier ground-truth values down, missing cross-platform parity, forgotten cache version bumps, or accidental secret leaks).
   - Return one of three explicit verdicts using [../templates/review.md](../templates/review.md):
     - `PASS`: All stated acceptance criteria verified independently; zero blockers in scope.
     - `REQUEST_CHANGES`: Concrete defects cited with `file:line`, evidence, impact, and reproduction steps.
     - `INCONCLUSIVE`: Missing source access, inability to run verification, or unresolved contradictory data.
   - If the same model reviews its own work, label it `self-review`—never independent review.
   - Report defects to the owner rather than silently overwriting the other agent's code and deploying.

---

## 3. Attribution Discipline

- Prefix commits with the acting agent's tag: `[Claude] ...`, `[Codex] ...`, `[Gemini] ...`.
- Add concise attribution comments only on non-obvious architectural or formula changes.
- **Never delete another agent's attribution tag** when reviewing or fixing their code; append your tag alongside theirs (e.g., `[Codex, fixed by Claude]`).
