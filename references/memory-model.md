# File-Based Memory Model (Zero Database Required)

## 1. Six Distinct Layers — Never Mix Them

| Layer | Role | When Used |
|---|---|---|
| **Instructions (`AGENTS.md`)** | Active workspace rules, architecture map, and hard constraints | Read before substantive work; never overridden by old memory guesses |
| **Index (`memory/MEMORY.md`)** | Concise 1-line-per-card directory linking to atomic cards | Read at session start to locate relevant knowledge |
| **Memory Cards (`memory/*.md`)** | One atomic rule, decision, finding, or lesson per file | Created/updated only when knowledge has lasting value |
| **Evidence (`docs/research/*`)** | Reproducible scripts, datasets, benchmarks, and raw outputs | Linked from cards; never duplicated inline in full |
| **Changelog (`CHANGELOG.md`)** | Chronological ledger of work batches, commits, and test results | Updated at the close of substantive work |
| **Checkpoint / Handoff (`handoffs/*`)** | Current in-progress state, verified steps, and next actions | Updated mid-session at milestones and at session close |

---

## 2. Card Types (`kind`)

- `feedback`: Owner correction of AI behavior (*Original failure / Rule from now on / Why / How to apply*).
- `decision`: Locked choice among alternatives (*Options / Trade-offs / Approver / Revisit conditions*).
- `finding`: Verified empirical or technical root cause with `file:line` or data provenance.
- `procedure`: Repeatable multi-step runbook and safety checks.
- `constraint`: Long-term boundary or permission limit.
- `lesson`: Post-mortem from a real incident or revert (`⛔ REVERTED`) so future agents never repeat a failed experiment.

---

## 3. Standard YAML Frontmatter

```yaml
---
id: decision-2026-11-05-example
name: Document Approval Gate
scope: workspace/example
kind: decision
status: active
created: 2026-11-05
updated: 2026-11-05
observed_at: 2026-11-05
last_verified: 2026-11-05
review_after: null
source:
  - "document:docs/policy.md#approval"
owner: project-owner
agent: codex
confidence: verified
supersedes: []
---
```

- `status`: `proposed` | `active` | `blocked` | `superseded` | `retracted` | `archived`.
- `confidence`: `verified` | `supported` | `tentative` | `unknown` (never upgrade to `verified` solely because multiple AIs agreed).
- Keep `status` of a memory card separate from **task state** (`completed` / `verified` / `published`).

---

## 4. Anatomy of a High-Signal Memory Card

1. **What:** Concise conclusion and current status.
2. **Why:** Real incident, user correction, or experiment that necessitated this card.
3. **Evidence:** Exact paths, metrics, dates, or test runs checked—plus known limitations.
4. **How to Apply:** Trigger condition, mandatory action, and prohibited action.
5. **Exceptions / Counterexamples:** Known edge cases.
6. **Related / Superseded By:** Relative links to related cards.
