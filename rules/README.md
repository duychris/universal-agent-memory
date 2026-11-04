# Global Rules — Startup Anchors for Cross-Session Activation

**These are not background hooks.** They are concise instruction blocks designed to be **safely merged** into each AI platform's global instruction file so the agent remembers to activate `universal-agent-memory` on stateful tasks. Never overwrite your existing global file.

| Platform | Rule Snippet File | Global File Location |
|---|---|---|
| **Claude Code** | [`claude-code.md`](claude-code.md) | `~/.claude/CLAUDE.md` |
| **OpenAI Codex** | [`codex.md`](codex.md) | `~/.codex/AGENTS.md` |
| **Gemini CLI** | [`gemini.md`](gemini.md) | `~/.gemini/GEMINI.md` |
| **Antigravity** *(standalone)* | [`antigravity-alternative.md`](antigravity-alternative.md) | `~/.gemini/config/AGENTS.md` or Global Rules UI |

> **Important when using both Gemini CLI and Antigravity on the same machine:** Both tools may read `~/.gemini/GEMINI.md`. **Install `gemini.md` into `~/.gemini/GEMINI.md` once** and do not duplicate `antigravity-alternative.md` into another file unless Antigravity does not load `GEMINI.md` in your setup.

Each snippet uses `<!-- UAM-V3:BEGIN -->` and `<!-- UAM-V3:END -->` markers so upgrades only replace the block between markers while preserving all your personal rules above or below it.
