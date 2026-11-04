# Antigravity (Standalone Alternative — DO NOT INSTALL IF ALREADY USING `~/.gemini/GEMINI.md`)

<!-- UAM-V3:BEGIN -->
## Universal Agent Memory v3 — Persistent Working Discipline
- For multi-step or stateful work across sessions: activate/load Skill `universal-agent-memory` from `~/.gemini/config/skills/universal-agent-memory/SKILL.md` (via host skill activation or direct file read if permitted).
- Before acting: read workspace instructions (`AGENTS.md`/`GEMINI.md`), `memory/MEMORY.md` (or the configured canonical store), and the latest handoff/checkpoint; verify sources and scope. If no memory store exists, DO NOT spawn a parallel store unprompted.
- During long tasks: update a checkpoint after verified milestones, key decisions, or before handoff/risky steps—do not wait until session end. Strictly separate `VERIFIED`, `COMPLETED_UNVERIFIED`, `PENDING`, and `ASSUMPTION`.
- At close of substantive work: update durable memory cards, index, and changelog/handoff when valuable; verify persistence. Do not create files for trivial one-off questions (`LIGHT` mode).
- Never delete out-of-scope files (`no-unscoped-delete`), never overwrite another agent's WIP, never run `git add -A` or destructive git resets on shared worktrees, and never merge/publish/deploy without explicit owner approval.
- If the Skill cannot be loaded, memory is unreachable, or persistence/sync is unverified: report the exact status (`SKILL UNAVAILABLE`, `MEMORY UNAVAILABLE`, `NOT VERIFIED`)—never fabricate read, write, or sync completion.
<!-- UAM-V3:END -->
