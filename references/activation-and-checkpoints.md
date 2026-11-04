# Activation & Checkpoint Protocol (v3)

## 1. Never Conflate Status Labels

- **Discovered:** The host recognizes the `name`/`description` frontmatter; the Skill has not been executed yet.
- **Activated / Loaded:** The agent has read `SKILL.md` in the current session.
- **Memory Readable:** The agent can read the canonical memory index (`memory/MEMORY.md`), not merely see a directory path.
- **Persisted:** After writing, the content has been read back at the destination path or confirmed by a verified write tool.
- **Synced:** The shared canonical repository/store contains the verified revision; *this does not guarantee* another machine has fetched it yet.

Never collapse these five states into a single "on" claim.

---

## 2. Startup Anchor (Global Rules)

Global Rules contain only a **compact startup contract**—never copy the entire Skill into a global file. On multi-step or stateful work:

1. Locate and load `universal-agent-memory` (via host skill invocation or direct file read if permitted).
2. Identify the workspace and canonical memory store; never spawn a duplicate store. Read active workspace instructions, the memory index, and the latest handoff/checkpoint.
3. Verify current live state, permissions, and scope. Never treat a stale memory card as an overriding law.
4. If any source is unreachable, state the limitation explicitly—**never pretend context was fully restored**.

For `LIGHT` tasks (one-off questions), do not force skill loading or file writes.

---

## 3. When to Checkpoint Mid-Session

Checkpoint at natural transition points—**not on an arbitrary timer**:

- Immediately after a verified milestone or passing test with concrete evidence.
- Right before and after a high-risk, multi-step, or resource-heavy operation (record only what has actually happened).
- When a key decision or durable owner correction is locked in.
- Before handing off to another agent, branch, or machine.
- When context compaction, quota exhaustion, or session termination is imminent.

Maintain **one latest checkpoint snapshot** (e.g., `handoffs/latest.md`) rather than creating a new file on every chat turn. Durable history belongs in `CHANGELOG.md` and `memory/*.md`.

---

## 4. Minimum Checkpoint Contents

- `task`, `scope`, `owner/agent`, `workspace`, `last_updated`.
- `VERIFIED` items + source, verification command/method, and result.
- `COMPLETED_UNVERIFIED`, `PENDING`, `ASSUMPTION`, and `BLOCKED` items.
- Single concrete `next_action` and exact files to open next.
- `sync_status`: `LOCAL_ONLY`, `PERSISTED`, `SYNC_PENDING`, `SYNC_VERIFIED`, or `UNKNOWN` with evidence.

Use [../templates/checkpoint.md](../templates/checkpoint.md).

---

## 5. Restart-Safe Recovery After Interruption

1. Read the latest checkpoint/handoff and relevant memory cards; check whether status is `FINAL` or `IN_PROGRESS`/`INTERRUPTED`.
2. Cross-check **actual live state**: `git status --short`, current file contents, test outputs, and permissions.
3. Treat planned steps without completion evidence as `PENDING`/`UNKNOWN`—**never re-run transactions, deployments, deletions, or external messages** merely because a checkpoint listed them as in progress.
4. If another agent modified files in the meantime or two checkpoints conflict: **preserve both**, report the conflict, and verify sources before acting.
5. Resume from the verified next step and update the checkpoint after the next milestone.
