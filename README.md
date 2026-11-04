<div align="center">

# 🧠 Universal Agent Memory (v3.0)

**Persistent Working Discipline, Shared Memory & Multi-Agent Handoff Skill for Claude Code, OpenAI Codex, Gemini CLI & Antigravity**

[![Version](https://img.shields.io/badge/version-v3.0.0-blue.svg)](RELEASE-NOTES.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Type: Agent Skill](https://img.shields.io/badge/Type-Markdown_Agent_Skill-purple.svg)](SKILL.md)
[![Dependencies: Zero](https://img.shields.io/badge/Dependencies-Zero_(No_DB_%2F_No_Server)-brightgreen.svg)](#why-universal-agent-memory)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-orange.svg)](TEST-CASES.md)

🌐 **Languages:** [**English**](README.md) | [**Tiếng Việt (README)**](README.vi.md) | [**Hướng Dẫn Sử Dụng Chi Tiết (VI)**](HDSD.md)

</div>

---

## ⚡ What Is This?

**Universal Agent Memory (`universal-agent-memory`)** is a lightweight, **zero-dependency Agent Skill + Global Rules anchor** distilled from 1,400+ real-world memory artifacts and multi-agent sessions where Claude, Codex, and Gemini collaborated daily on production systems.

It is **NOT** a vector database, SaaS wrapper, MCP server, or CLI daemon. It is a **pure Markdown behavioral contract** that teaches your AI agents how to:
1. **Read context leanly before acting** (`AGENTS.md` → `memory/MEMORY.md` index → only relevant atomic cards).
2. **Checkpoint mid-session** so quota exhaustion, crashes, or context resets never wipe out unrecorded progress.
3. **Never destroy each other's Work-In-Progress (WIP)** (bans blind `git add -A`, `git checkout --`, and unscoped file deletions).
4. **Separate "Completed" from "Verified" and "Published"**—preventing AI hallucinations of "all tests pass / already deployed."
5. **Cross-review independently** across different models (`Claude` ↔ `Codex` ↔ `Gemini`) with strict attribution and provenance.
6. **Learn selectively** from user corrections (`feedback-*.md`) and decisions (`decision-*.md`) with semantic deduplication instead of dumping raw chat logs.

Works across **any domain**—software engineering, research, data analysis, writing, business operations, creative projects, and personal learning (Git rules only activate when the workspace actually uses Git).

---

## 🏗️ How the 4-Layer Architecture Works

Why do standard AI skills fail across sessions? Because **Skills are loaded on-demand**—if you type a short prompt in a new session, the AI often forgets to activate the skill.

**v3 solves this with a 4-layer architecture:**

```text
┌─────────────────────────────────────────────────────────────────────────┐
│ LAYER 1: GLOBAL RULES ANCHOR (Always-On, ~8 lines in CLAUDE.md/AGENTS)  │
│ Reminds the agent on every stateful task to load Universal Agent Memory │
└───────────────────────────────────┬─────────────────────────────────────┘
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│ LAYER 2: SKILL.md (4 Adaptive Modes: LIGHT · STANDARD · COLLAB · LEARN) │
│ Enforces verification, Git WIP safety, cross-review & learning gates    │
└─────────────────┬───────────────────────────────────┬───────────────────┘
                  ▼                                   ▼
┌───────────────────────────────────┐ ┌───────────────────────────────────┐
│ LAYER 3: MID-SESSION CHECKPOINT   │ │ LAYER 4: CANONICAL MEMORY STORE   │
│ handoffs/latest.md                │ │ memory/MEMORY.md (1-line index)   │
│ Saved right after verified steps  │ │ + feedback-*.md / decision-*.md   │
│ & before risky actions (crash-safe)│ │ + CHANGELOG.md                    │
└───────────────────────────────────┘ └───────────────────────────────────┘
```

---

## 🚀 Quick Install (30 Seconds)

### Option A: One-Line Automated Installer (macOS / Linux / WSL)

Installs the skill for **Claude Code**, **OpenAI Codex**, **Gemini CLI**, and **Google Antigravity**, and safely appends the `<!-- UAM-V3:BEGIN -->` anchor block to your global rule files without overwriting your existing instructions:

```bash
curl -fsSL https://raw.githubusercontent.com/duychris/universal-agent-memory/main/install.sh | bash
```

*(Prefer the Vietnamese skill edition? Run `curl -fsSL https://raw.githubusercontent.com/duychris/universal-agent-memory/main/install.sh | bash -s -- --lang vi`)*

### Option B: One-Line Automated Installer (Windows PowerShell)

```powershell
irm https://raw.githubusercontent.com/duychris/universal-agent-memory/main/install.ps1 | iex
```

### Option C: Let Your AI Agent Install It For You (Copy-Paste Prompt)

Clone or download this repository, then paste this prompt into Claude Code, Codex, or Antigravity:

> Read `README.md` and `rules/README.md` from this `universal-agent-memory` repository. Install the skill directory into the user-level skills folder for the AI agents on my machine (`~/.claude/skills/universal-agent-memory`, `~/.agents/skills/universal-agent-memory`, `~/.codex/skills/universal-agent-memory`, `~/.gemini/config/skills/universal-agent-memory`). Safely append the `UAM-V3` marker block from `rules/` into my global rule files without overwriting existing content or duplicating blocks. Then run the 4-layer health check (`RULES LOADED`, `SKILL LOADED`, `MEMORY READABLE`, `PERSISTENCE VERIFIED`) and report the exact paths.

---

## 📂 Manual Installation Paths

If you prefer manual setup, copy this folder as `universal-agent-memory` into:

| AI Agent | Global Skill Path (macOS / Linux) | Global Rule Anchor File | Rule Snippet |
|---|---|---|---|
| **Claude Code** | `~/.claude/skills/universal-agent-memory/` | `~/.claude/CLAUDE.md` | [`rules/claude-code.md`](rules/claude-code.md) |
| **OpenAI Codex** | `~/.agents/skills/universal-agent-memory/` *(and `~/.codex/skills/`)* | `~/.codex/AGENTS.md` | [`rules/codex.md`](rules/codex.md) |
| **Gemini CLI** | `~/.agents/skills/universal-agent-memory/` | `~/.gemini/GEMINI.md` | [`rules/gemini.md`](rules/gemini.md) |
| **Antigravity** | `~/.gemini/config/skills/universal-agent-memory/` | `~/.gemini/GEMINI.md` *(shared)* or `~/.gemini/config/AGENTS.md` | [`rules/antigravity-alternative.md`](rules/antigravity-alternative.md) |

---

## 🛡️ Battle-Tested Problems This Solves

| Real-World Failure Mode | How Universal Agent Memory v3 Prevents It |
|---|---|
| **Agent A runs `git add -A` and commits Agent B's half-written file** | Strictly bans `git add -A`, `git add .`, `git commit -am`. Enforces `git status --short` + path-specific `git add -- <file>` + `git diff --cached` right before commit. |
| **Agent runs `git checkout -- file` to undo a test and wipes 3 days of uncommitted WIP** | Bans destructive checkout/restore/reset on shared worktrees; requires temporary backup copies for destructive testing. |
| **Agent deletes "unused" files while fixing an unrelated bug** | Enforces `no-unscoped-delete`: out-of-scope dead code or files must be left untouched and reported separately. |
| **Session crashes or hits token/quota limit before writing handoff** | Enforces **mid-session Checkpoints** (`handoffs/latest.md`) after every verified milestone and before high-risk steps, with restart-safe `INTERRUPTED` recovery. |
| **Symlinked/Junction memory folder silently breaks after OS reinstall** | Detects split-brain links via `realpath`/`ReparsePoint` checks; halts writes to preserve both divergent copies until merged. |
| **Memory index grows into a 5,000-line token-wasting dump** | Enforces 1-line index entries in `memory/MEMORY.md` + atomic cards + semantic deduplication (`DUPLICATE`, `RELATED`, `CONTRADICTORY`, `NEW`). |
| **Reviewer AI rubber-stamps Implementer AI's summary without checking** | Requires independent verification of raw diffs/outputs and explicit verdicts (`PASS`, `REQUEST_CHANGES`, `INCONCLUSIVE`). |

---

## 📦 Repository Structure

```text
universal-agent-memory/
├── SKILL.md                             # Core operational instructions for AI agents (EN)
├── README.md                            # English documentation & quickstart
├── README.vi.md                         # Vietnamese documentation (Tài liệu Tiếng Việt)
├── HDSD.md                              # Non-technical user guide in Vietnamese
├── install.sh                           # 1-line installer for macOS / Linux / WSL
├── install.ps1                          # 1-line installer for Windows PowerShell
├── RELEASE-NOTES.md                     # v3.0 changelog & design boundaries
├── TEST-CASES.md                        # 28 behavioral acceptance test scenarios
├── references/                          # On-demand deep-dive protocols (progressive disclosure)
│   ├── activation-and-checkpoints.md    # 4-layer activation & mid-session checkpoint protocol
│   ├── session-protocol.md              # Session start, resume, and close lifecycle
│   ├── memory-model.md                  # File-based memory architecture & metadata schema
│   ├── learning-lifecycle.md            # Signal filtering, semantic dedup & promotion gates
│   ├── verification-and-decisions.md    # Task-state vs. memory-state & evidence loop
│   ├── multi-agent.md                   # Multi-agent coordination & independent cross-review
│   ├── git-sync.md                      # Git WIP safety, path-specific staging & symlink checks
│   ├── security-and-scope.md            # Scope boundaries, privacy & prompt-injection defense
│   ├── platform-setup.md                # Platform paths & verification guide
│   └── source-traceability.md           # Engineering provenance & public skill comparisons
├── rules/                               # Global Rule anchor snippets with UAM-V3 markers
│   ├── README.md
│   ├── claude-code.md
│   ├── codex.md
│   ├── gemini.md
│   └── antigravity-alternative.md
├── templates/                           # Ready-to-use Markdown templates
│   ├── MEMORY.md
│   ├── memory-card.md
│   ├── feedback.md
│   ├── decision.md
│   ├── checkpoint.md
│   ├── handoff.md
│   ├── changelog-entry.md
│   ├── review.md
│   └── AGENTS-snippet.md
├── examples/
│   └── DEMO-README.md                   # 2-session non-coding continuity test
└── i18n/
    └── vi/                              # Complete Vietnamese edition of SKILL.md, references, rules & templates
```

---

## ✅ Verify Installation (4-Layer Health Check)

Open a **new session** in your AI agent and paste:

> Check Universal Agent Memory across all 4 layers: (1) Which Global Rules file was loaded (`RULES LOADED`)? (2) Which exact `SKILL.md` path was loaded (`SKILL LOADED`)? (3) Where is the canonical `MEMORY.md` in this workspace and is it readable (`MEMORY READABLE`)? (4) Has persistence been verified (`PERSISTENCE VERIFIED` or `NOT VERIFIED`)? Do not create files outside an authorized test folder. Report concrete evidence for each layer.

---

## 🤝 Contributing & License

Contributions, translations, and new platform adapters are welcome! Please run through the scenarios in [`TEST-CASES.md`](TEST-CASES.md) when proposing behavioral changes.

Licensed under the [MIT License](LICENSE).
