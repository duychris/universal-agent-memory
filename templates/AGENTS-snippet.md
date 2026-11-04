## Universal Agent Memory — Shared Workspace Convention

This workspace uses the `universal-agent-memory` Skill to standardize how AI agents read context, verify claims, checkpoint progress, and hand off work.

- **Canonical Memory Index:** `memory/MEMORY.md` (adjust path if your workspace differs).
- **Priority Order:** Current user instructions & workspace `AGENTS.md` → verified live state & `CHANGELOG.md` → approved decisions → `memory/` cards.
- **Session Start:** Read the latest handoff/checkpoint, verify symlink/Git sync health if applicable, and open only relevant memory cards.
- **During Session:** Respect scope boundaries (`no-unscoped-delete`), verify before concluding, and checkpoint after verified milestones or before risky steps.
- **Multi-Agent:** Record attribution (`[Claude]`, `[Codex]`, `[Gemini]`), protect other agents' WIP, and require independent cross-review for high-impact changes.
- **Git Safety (if using Git):** Never run `git add -A`, `git add .`, `git commit -am`, or destructive checkouts/resets on shared worktrees; stage explicit file paths only after checking `git status --short` and `git diff --cached`.
- **Session Close:** Update durable memory cards/index when lasting lessons emerge, update `CHANGELOG.md`/handoff for substantive work, and report actual persistence/sync status truthfully.
