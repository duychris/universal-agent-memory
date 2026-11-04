# Platform Setup Across AI Agents

These paths reflect official documentation for Claude Code, OpenAI Codex, Gemini CLI, and Google Antigravity.

## 1. Recommended Installation Locations

| Environment | Workspace / Project Scope | Personal / Global Scope |
|---|---|---|
| **Claude Code** | `.claude/skills/universal-agent-memory/SKILL.md` | `~/.claude/skills/universal-agent-memory/SKILL.md` |
| **OpenAI Codex** | `.agents/skills/universal-agent-memory/SKILL.md` | `~/.agents/skills/universal-agent-memory/SKILL.md` *(and `~/.codex/skills/`)* |
| **Gemini CLI** | `.gemini/skills/universal-agent-memory/SKILL.md` or `.agents/skills/universal-agent-memory/SKILL.md` | `~/.agents/skills/universal-agent-memory/SKILL.md` or `~/.gemini/skills/universal-agent-memory/SKILL.md` |
| **Google Antigravity** | `.agents/skills/universal-agent-memory/SKILL.md` | `~/.gemini/config/skills/universal-agent-memory/SKILL.md` |

Keep the entire skill directory (`SKILL.md`, `references/`, `rules/`, `templates/`) intact.

---

## 2. Anchoring Startup Activation via Global Rules

Because most hosts load Skills **on-demand**, add the compact `UAM-V3` marker block from [`../rules/`](../rules/README.md) into your global instruction file (`~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, `~/.gemini/GEMINI.md`) or workspace `AGENTS.md` ([`../templates/AGENTS-snippet.md`](../templates/AGENTS-snippet.md)).

---

## 3. Post-Install Verification Checklist

1. The agent can read `SKILL.md` and at least one file under `references/`.
2. The agent accurately identifies the canonical `memory/MEMORY.md` path in the workspace (or states that none is configured yet).
3. The agent refuses blind `git add -A`, refuses out-of-scope deletions (`no-unscoped-delete`), separates `completed` from `verified`, and writes a checkpoint/handoff on multi-step tasks.
4. Official docs:
   - Claude Code Skills: https://code.claude.com/docs/en/skills
   - OpenAI Codex Skills: https://learn.chatgpt.com/docs/build-skills
   - Gemini CLI Skills: https://github.com/google-gemini/gemini-cli/blob/main/docs/cli/skills.md
   - Google Antigravity Skills: https://antigravity.google/docs/skills
