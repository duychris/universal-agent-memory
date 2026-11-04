# Engineering Provenance & Design Traceability

This document records the real-world engineering lessons that shaped **Universal Agent Memory v3**.

## 1. Distilled from Production Multi-Agent Workflows

Universal Agent Memory was extracted from a private production repository (`1,400+` files, `110+` atomic memory cards, and daily multi-agent handoffs between Claude, OpenAI Codex, and Gemini across macOS, Windows, and cloud containers). All domain-specific business logic was stripped out, preserving only the universal operational guardrails that prevented real incidents:

| Operational Rule in This Skill | Real-World Incident That Created It | Where Enforced |
|---|---|---|
| 1-line `memory/MEMORY.md` index + atomic cards | Loading all notes into context wasted tokens; a 1-line index with status icons (`⭐`, `🔴`, `🚫`, `✅`) let new sessions locate exact context in seconds | `SKILL.md` §3, `memory-model.md` |
| Owner corrections saved as `feedback-*.md` with *Why / How to apply* | Verbal corrections in chat were forgotten in the next session until codified with the triggering incident and concrete check | `templates/feedback.md`, `learning-lifecycle.md` |
| Canonical docs (`AGENTS.md`, `CHANGELOG.md`) outrank old memory cards | Memory notes occasionally lagged behind recent code commits; trusting old memory over live files caused regressions | `SKILL.md` §1, `session-protocol.md` |
| Strict `no-unscoped-delete` | An agent fixing a bug deleted an "unused" file that was actually reserved for another module | `SKILL.md` §1, `security-and-scope.md` |
| Independent cross-review (`Claude` ↔ `Codex`) | One agent's linear interpolation across step tiers caused a mid-tier ground-truth regression that was caught only when a second agent ran the benchmark independently | `multi-agent.md`, `templates/review.md` |
| Ban on `git add -A` & `git checkout -- <file>` | Concurrent agents sharing a working tree accidentally committed each other's half-saved files via `git add -A`, and wiped uncommitted patches via `git checkout --` | `git-sync.md`, `SKILL.md` §1 & §6 |
| Symlink / Junction split-brain detection | After an OS reinstall, a directory junction silently turned into a plain folder, splitting memory into two diverging stores for 3 weeks | `git-sync.md`, `SKILL.md` §3 |
| Mid-session checkpoints (`handoffs/latest.md`) | Long sessions hitting quota or context limits lost unrecorded progress when handoffs were only written at the end of a session | `SKILL.md` §7, `activation-and-checkpoints.md` |

---

## 2. Cross-Comparison with Public Agent Skill Architectures

When designing v2 and v3, we also audited public open-source agent memory and handoff skills to adopt best practices while keeping zero runtime dependencies:

| Public Reference | Key Insight Adopted | How Applied in v3 | Intentionally Omitted |
|---|---|---|---|
| `vvnocode/AGENTS.md` (`agent-memory-setup`) | Verify link targets, shared root, and read-after-write | 4-layer health check & symlink verification | Platform-specific binary hooks |
| `affaan-m/ECC` (`unified-memory`) | Treat memory as fallible claims; enforce scope & prompt-injection defense | Two-axis state model & untrusted-data rules | External Memory Vault / npm CLI |
| `phnx-labs/.agents` (`learn`) | Avoid overfitting on a single session; gate rule promotion | Controlled promotion gate in `learning-lifecycle.md` | Full transcript scraping / auto-editing `SKILL.md` |
| `gitstq/awesome-ai-agent-skills` (`self-evolver-pro`) | Signal classification & semantic deduplication | `DUPLICATE` / `RELATED` / `CONTRADICTORY` / `NEW` workflow | Automatic TTL deletion / strike counters |
| `whaojie797-design/agent-handoff-kit` | Separate `Verified` from `Completed` and `Assumption` | Checkpoint & handoff templates | Mandatory 4-file state overhead on small tasks |
| `WeirdSky924/agent-handoff-skill` | Single consistent checkpoint file (`handoffs/latest.md`) | Mid-session checkpoint protocol & non-destructive Global Rule markers | Python bootstrap scripts |
