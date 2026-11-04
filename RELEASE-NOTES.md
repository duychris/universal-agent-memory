# Release Notes — Universal Agent Memory v3.0

**2026-11-05** — Major upgrade from v2; preserves the human-first, zero-dependency, instruction-only architecture while adding bilingual (English + Vietnamese) support and 1-command installers.

## What's New in v3.0

1. **Global Rules Anchors (`rules/`)**: Ready-to-merge anchor snippets for Claude Code, OpenAI Codex, Gemini CLI, and Google Antigravity wrapped in `<!-- UAM-V3:BEGIN --> ... <!-- UAM-V3:END -->` markers so existing instructions are never overwritten.
2. **4-Layer Startup & Activation Contract**: Explicitly separates `RULES LOADED`, `SKILL LOADED`, `MEMORY READABLE`, and `PERSISTENCE VERIFIED`. Prevents agents from confusing skill discovery with active memory persistence.
3. **Mid-Session Checkpoints (`Mục 7` / `Section 7`)**: Saves progress right after verified milestones, key decisions, or before high-risk/multi-agent transitions instead of waiting until session close.
4. **Restart-Safe Interrupted Recovery**: Teaches incoming sessions how to audit an unclosed (`IN_PROGRESS` / `INTERRUPTED`) checkpoint against actual workspace state without blindly re-running side-effecting operations.
5. **Deduplicated Gemini CLI + Antigravity Setup**: Prevents double-loading Global Rules when both tools share `~/.gemini/GEMINI.md`.
6. **Full Internationalization (EN + VI) & 1-Command Installers**: English-first default (`SKILL.md`, `references/`, `rules/`, `templates/`) plus complete Vietnamese edition (`i18n/vi/`, `README.vi.md`, `HDSD.md`) and automated `install.sh` / `install.ps1` scripts.

## Retained from v2.0

- 1-line `memory/MEMORY.md` index + atomic cards (`feedback`, `decision`, `finding`, `lesson`, `procedure`), semantic deduplication, and owner-gated promotion.
- Strict separation of task state (`completed` vs. `verified` vs. `published`) from memory state (`proposed` vs. `active` vs. `superseded`).
- Scope boundaries (`no-unscoped-delete`), independent cross-review (`PASS` / `REQUEST_CHANGES` / `INCONCLUSIVE`), and path-specific Git staging (`git add -- <file>`).
- Four adaptive modes: `LIGHT`, `STANDARD`, `COLLAB`, and `LEARN`.
