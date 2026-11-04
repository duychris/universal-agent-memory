<div align="center">

# 🧠 Universal Agent Memory (v3.0)

**Persistent Working Discipline, Shared Memory & Multi-Agent Handoff Skill for Claude Code, OpenAI Codex, Gemini CLI & Antigravity**

[![Version](https://img.shields.io/badge/version-v3.0.0-blue.svg)](RELEASE-NOTES.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Type: Agent Skill](https://img.shields.io/badge/Type-Markdown_Agent_Skill-purple.svg)](SKILL.md)
[![Dependencies: Zero](https://img.shields.io/badge/Dependencies-Zero_(No_DB_%2F_No_Server)-brightgreen.svg)](#what-is-this)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-orange.svg)](TEST-CASES.md)

🌐 **Languages:** [**English**](README.md) | [**Tiếng Việt (README)**](README.vi.md) | [**Hướng Dẫn Sử Dụng Chi Tiết (VI)**](HDSD.md)

</div>

---

## ⚡ What Is This?

**Universal Agent Memory (`universal-agent-memory`)** is a lightweight, **zero-dependency Agent Skill + Global Rules anchor** distilled from a production multi-agent repository (~1,400 project files and operational records, including 110+ atomic memory cards) where Claude, Codex, and Gemini collaborated daily.

It is **NOT** a vector database, SaaS wrapper, MCP server, or CLI daemon. It is a **pure Markdown behavioral contract** that teaches your AI agents how to:
1. **Read context leanly before acting** (`AGENTS.md` → `memory/MEMORY.md` index → only relevant atomic cards).
2. **Checkpoint mid-session** after verified milestones and before high-risk steps to minimize lost state if a session hits quota limits, compacts context, or interrupts early *(note: unrecorded in-flight work before a crash still requires workspace verification on resume)*.
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
│ & before risky actions            │ │ + CHANGELOG.md                    │
└───────────────────────────────────┘ └───────────────────────────────────┘
```

---

## 🚀 Quick Install

> **Security Note:** Piping any remote script directly from `main` executes the latest branch contents. For maximum safety, we recommend **downloading and inspecting the script first** (or pinning the immutable release tag `v3.0.0`) and running `--dry-run` to preview changes. Both installers automatically back up existing Global Rules and modified Skill files before updating.

### Option A: Inspect-First or Pinned Automated Installer (macOS / Linux / WSL)

**Recommended (Download, inspect, preview with `--dry-run`, then install):**
```bash
curl -fsSLO https://raw.githubusercontent.com/duychris/universal-agent-memory/v3.0.0/install.sh
less install.sh
bash install.sh --ref v3.0.0 --dry-run
bash install.sh --ref v3.0.0
```

**One-Line Install (Pinned to `v3.0.0`):**
```bash
curl -fsSL https://raw.githubusercontent.com/duychris/universal-agent-memory/v3.0.0/install.sh | bash -s -- --ref v3.0.0
```

**Useful Flags (`install.sh`):**
- `--lang vi`: Install the complete Vietnamese edition (`SKILL.md`, `references/`, `rules/`, `templates/`, `HDSD.md`).
- `--platform claude,codex`: Only install for specific platforms (`all`, `claude`, `codex`, `gemini`, `antigravity`).
- `--dry-run`: Preview all target paths and backups without modifying any files.

### Option B: Automated Installer (Windows PowerShell)

**Recommended (Download, inspect, preview with `-DryRun`, then install):**
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/duychris/universal-agent-memory/v3.0.0/install.ps1" -OutFile "install.ps1"
Get-Content .\install.ps1
.\install.ps1 -Ref v3.0.0 -DryRun
.\install.ps1 -Ref v3.0.0
```

**Install Vietnamese edition or specific platforms on Windows:**
```powershell
.\install.ps1 -Ref v3.0.0 -Lang vi -Platform claude,codex
```

**One-Line PowerShell Install (Pinned to `v3.0.0`):**
```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/duychris/universal-agent-memory/v3.0.0/install.ps1))) -Ref v3.0.0
```

### Option C: Let Your AI Agent Install It For You (Copy-Paste Prompt)

Clone or download this repository, then paste this prompt into Claude Code, Codex, or Antigravity:

> Read `README.md` and `rules/README.md` from this `universal-agent-memory` repository. Install the skill directory into the canonical user-level skills folder for the AI agents on my machine (`~/.claude/skills/universal-agent-memory`, `~/.agents/skills/universal-agent-memory`, `~/.gemini/config/skills/universal-agent-memory`). Back up my existing Global Rules files before safely merging the `UAM-V3` marker block from `rules/` without overwriting existing content or duplicating blocks. Then run the 4-layer health check (`RULES LOADED`, `SKILL LOADED`, `MEMORY READABLE`, `PERSISTENCE VERIFIED`) and report the exact paths.

---

## 📂 Manual Installation Paths

If you prefer manual setup, copy this folder as `universal-agent-memory` into:

| AI Agent | Canonical Global Skill Path (macOS / Linux) | Global Rule Anchor File | Rule Snippet |
|---|---|---|---|
| **Claude Code** | `~/.claude/skills/universal-agent-memory/` | `~/.claude/CLAUDE.md` | [`rules/claude-code.md`](rules/claude-code.md) |
| **OpenAI Codex** | `~/.agents/skills/universal-agent-memory/` | `~/.codex/AGENTS.md` | [`rules/codex.md`](rules/codex.md) |
| **Gemini CLI** | `~/.agents/skills/universal-agent-memory/` *(shared with Codex)* | `~/.gemini/GEMINI.md` | [`rules/gemini.md`](rules/gemini.md) |
| **Antigravity** | `~/.gemini/config/skills/universal-agent-memory/` | `~/.gemini/GEMINI.md` *(shared)* or `~/.gemini/config/AGENTS.md` | [`rules/antigravity-alternative.md`](rules/antigravity-alternative.md) |

> **Avoiding Duplicate Skill Detection in Codex:** OpenAI Codex discovers user skills from `~/.agents/skills/`. Do not install a second copy inside `~/.codex/skills/universal-agent-memory/`, as having both can cause duplicate skill entries.

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
├── install.sh                           # Automated installer for macOS / Linux / WSL
├── install.ps1                          # Automated installer for Windows PowerShell
├── RELEASE-NOTES.md                     # v3.0 changelog, verification status & boundaries
├── TEST-CASES.md                        # 28 designed behavioral acceptance test scenarios
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

## ✅ Verify Installation & Verification Matrix

Open a **new session** in your AI agent and paste:

> Check Universal Agent Memory across all 4 layers: (1) Which Global Rules file was loaded (`RULES LOADED`)? (2) Which exact `SKILL.md` path was loaded (`SKILL LOADED`)? (3) Where is the canonical `MEMORY.md` in this workspace and is it readable (`MEMORY READABLE`)? (4) Has persistence been verified (`PERSISTENCE VERIFIED` or `NOT VERIFIED`)? Do not create files outside an authorized test folder. Report concrete evidence for each layer.

### Current Verification Status
- **Static Validation (`PASS`):** Markdown relative links (repo + installed EN/VI trees), YAML frontmatter, `UAM-V3` marker blocks, and zero-dependency compliance.
- **macOS/Linux Installer (`install.sh` — `PASS`):** Verified in isolated `$HOME` sandboxes across clean EN/VI installs, idempotency on re-runs, pre-existing Global Rules preservation + automatic backup creation, custom file preservation inside Skill directories, unbalanced/duplicate marker rejection, and missing dependency preflight failure.
- **Windows PowerShell Installer (`install.ps1` — `STATIC VALIDATED` / `NOT TESTED` at runtime on Windows):** Audited for feature and link parity with `install.sh`; runtime execution on a Windows host is marked `NOT TESTED` in this environment.
- **Behavioral Acceptance Suite ([`TEST-CASES.md`](TEST-CASES.md)):** 28 designed evaluation scenarios for testing agent compliance; 4-layer health check and 2-session continuity (`examples/DEMO-README.md`) verified on Antigravity/Gemini.

---

## 🤝 Contributing & License

Contributions, translations, and new platform adapters are welcome! Please run through the scenarios in [`TEST-CASES.md`](TEST-CASES.md) when proposing behavioral changes.

Licensed under the [MIT License](LICENSE).
