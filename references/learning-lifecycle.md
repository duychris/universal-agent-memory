# Learning Lifecycle — Learn from Mistakes Without Memory Bloat

This is a **natural-language protocol executed by the agent**. It requires no vector database, embedding server, transcript scraper, or background daemon.

---

## 1. Signal → Candidate → Durable Memory

| Signal | Initial Action | When to Persist as Durable Memory |
|---|---|---|
| Direct user correction | Fix behavior in the current session first; identify scope | Instruction is clear, reusable in future sessions, and permitted |
| AI error / operational mistake | Record root cause and evidence | Likely to recur or high impact; keep `proposed` if unconfirmed |
| Disagreement between two agents | Compare primary sources and methods | Once verified which side is right, or record as an open question |
| Effective repeatable method | Extract reusable steps and boundary conditions | Proven across cases with known edge conditions |
| Decision | Record options, trade-offs, and rationale | Approved by owner (`active`); otherwise keep `proposed` |
| In-progress task state | Update checkpoint / handoff | Needed for session continuity—**never store as a permanent memory card** |

**Never write memory cards just to look productive.**

---

## 2. Semantic Deduplication (Before Creating Any Card)

1. Search `memory/MEMORY.md` for cards sharing the same **action, failure mode, trigger, or topic**.
2. Compare content, scope, exceptions, approver, and timestamps.
3. Classify as one of:
   - `DUPLICATE`: Do not create a new file; append new evidence to the existing card and update `updated`.
   - `RELATED`: Keep both cards if their trigger conditions or scopes differ, and cross-link them.
   - `CONTRADICTORY`: Never resolve by `mtime` or agent confidence alone; check canonical sources/owner and flag the conflict.
   - `NEW`: Create the atomic card and add **one** concise line to `memory/MEMORY.md`.

---

## 3. Controlled Promotion Gate

`observed → candidate/proposed → confirmed-for-scope → durable → reviewed → superseded/retired`

- Do not apply mechanical "3 strikes = new global rule" heuristics. Frequency is a signal to review, not automatic approval; conversely, a single catastrophic error (like `git add -A` collision) merits immediate recording.
- Default to the narrowest accurate scope: `task` → `workspace` → `shared/team` → `global`.
- Promote to `global` only when the lesson is genuinely domain-agnostic, backed by evidence, and approved by the owner.

---

## 4. Context Budget & Index Hygiene

- Read the `MEMORY.md` index + directly relevant cards at session start; never preload every file in `memory/`.
- When `MEMORY.md` grows beyond ~100–150 lines, organize it into **Top Pinned (active rules/critical alerts)** → **Topic Sections** → **Superseded / Archive** at the bottom.
- **Never auto-delete memory cards based on age (TTL).** An old rule whose source is still valid remains law. Cards past `review_after` are flagged for review, never silently deleted.
