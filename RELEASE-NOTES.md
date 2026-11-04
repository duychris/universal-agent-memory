# Release Notes — Universal Agent Memory v3.0

**2026-11-05** — Major upgrade from v2; preserves the human-first, zero-dependency, instruction-only architecture while adding bilingual (English + Vietnamese) support and hardened cross-platform installers.

## What's New in v3.0

1. **Global Rules Anchors (`rules/`)**: Ready-to-merge anchor snippets for Claude Code, OpenAI Codex, Gemini CLI, and Google Antigravity wrapped in `<!-- UAM-V3:BEGIN --> ... <!-- UAM-V3:END -->` markers so existing instructions are never overwritten.
2. **4-Layer Startup & Activation Contract**: Explicitly separates `RULES LOADED`, `SKILL LOADED`, `MEMORY READABLE`, and `PERSISTENCE VERIFIED`. Prevents agents from confusing skill discovery with active memory persistence.
3. **Mid-Session Checkpoints (`Mục 7` / `Section 7`)**: Saves progress right after verified milestones, key decisions, or before high-risk/multi-agent transitions instead of waiting until session close.
4. **Restart-Safe Interrupted Recovery**: Teaches incoming sessions how to audit an unclosed (`IN_PROGRESS` / `INTERRUPTED`) checkpoint against actual workspace state without blindly re-running side-effecting operations.
5. **Deduplicated Gemini CLI + Antigravity & Canonical Codex Paths**: Prevents double-loading Global Rules when Gemini CLI and Antigravity share `~/.gemini/GEMINI.md`, and installs Codex's user skill to its single canonical `~/.agents/skills/universal-agent-memory` path (warning if a legacy duplicate exists under `~/.codex/skills/`).
6. **Hardened Bilingual Installers (`install.sh` & `install.ps1`)**:
   - Complete package installation (`SKILL.md`, `README.md`, `HDSD.md`, `RELEASE-NOTES.md`, `TEST-CASES.md`, `LICENSE`, `references/`, `rules/`, `templates/`, `examples/`) with 100% relative link integrity in both `--lang en` and `--lang vi`.
   - Preflight dependency checks (`python3`, `git`), source completeness checks, and strict pre-validation of `UAM-V3` marker balance/uniqueness before writing any files.
   - Automatic timestamped backups before modifying existing non-empty Global Rules or modified Skill files, custom user file preservation inside Skill directories, `--dry-run` preview mode, `--platform` selection (`all`, `claude`, `codex`, `gemini`, `antigravity`), and `--ref` tag pinning.

## Retained from v2.0

- 1-line `memory/MEMORY.md` index + atomic cards (`feedback`, `decision`, `finding`, `lesson`, `procedure`), semantic deduplication, and owner-gated promotion.
- Strict separation of task state (`completed` vs. `verified` vs. `published`) from memory state (`proposed` vs. `active` vs. `superseded`).
- Scope boundaries (`no-unscoped-delete`), independent cross-review (`PASS` / `REQUEST_CHANGES` / `INCONCLUSIVE`), and path-specific Git staging (`git add -- <file>`).
- Four adaptive modes: `LIGHT`, `STANDARD`, `COLLAB`, and `LEARN`.

## Verification Status & Known Boundaries

- **Static Validation (`PASS`)**: All relative Markdown links (in repo and inside installed EN/VI skill directories), YAML frontmatter, and `UAM-V3` marker blocks verified.
- **macOS/Linux Installer (`install.sh` — `PASS`)**: Runtime-tested in isolated `$HOME` sandboxes across clean EN/VI installs, idempotent re-runs, pre-existing Global Rules preservation + backup creation, custom file preservation inside Skill directories, malformed/duplicate marker rejection, and missing dependency preflight failure.
- **Windows PowerShell Installer (`install.ps1` — `STATIC VALIDATED` / `NOT TESTED` at runtime on Windows)**: Code and logic aligned with `install.sh` (including `$LASTEXITCODE` checks and marker pre-validation), but not executed on a Windows host in this test environment.
- **Behavioral Test Suite (`TEST-CASES.md`)**: Contains 28 designed evaluation scenarios. The 4-layer health check (`RULES LOADED`, `SKILL LOADED`, `MEMORY READABLE`, `PERSISTENCE VERIFIED`) and 2-session continuity demo (`examples/DEMO-README.md`) were verified in Antigravity/Gemini; full 28-scenario runtime execution across all 4 host applications remains `NOT TESTED`.
