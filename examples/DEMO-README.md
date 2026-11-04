# Two-Session Continuity Demo (No Coding Required)

**Goal:** Verify cross-session memory and mid-session checkpoint continuity with a single AI agent on a non-technical task.

### Session 1

Create a clean test folder and give your AI agent this prompt:

> I am preparing a 10-minute presentation for a non-technical audience. In this test workspace, initialize Universal Agent Memory from `templates/` if no memory store exists yet; record the 10-minute non-technical constraint as an active decision card. Draft a short outline and save a checkpoint in `handoffs/latest.md`.

Verify that the workspace now contains `memory/MEMORY.md`, a decision card, and `handoffs/latest.md` with accurate dates, sources, and status.

### Session 2 (Open a brand-new chat WITHOUT mentioning the 10-minute constraint)

> Continue working on the presentation outline in this folder. Read Universal Agent Memory and the latest checkpoint; state the active constraints we locked in, what is still pending, and the next concrete step. Do not modify files outside this test workspace.

- **PASS:** The agent reads the files, cites the 10-minute non-technical constraint from the decision card, and accurately reports verified vs. pending items.
- **FAIL:** The agent guesses without reading the files, claims "I remember" without citing file paths, or creates a duplicate memory store.
