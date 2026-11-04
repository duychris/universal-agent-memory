---
id: "feedback-<slug>"
name: "<rule the AI must not forget>"
scope: "<global or workspace/topic>"
kind: feedback
status: proposed  # set to active if directly instructed by the owner for this scope
created: "<YYYY-MM-DD>"
updated: "<YYYY-MM-DD>"
observed_at: "<YYYY-MM-DD or unknown>"
last_verified: "unknown"
review_after: null
source:
  - "<direct owner correction in an authorized session>"
owner: "<owner>"
agent: "<agent-id>"
confidence: supported  # set to verified when backed by explicit owner confirmation + source
supersedes: []
---

# <Feedback / Rule Name>

## Original Failure

<What did the AI do wrong? State objective facts, not guesses about motivation.>

## Rule From Now On

**Must:** <concrete action verb>.

**Must NOT:** <concrete prohibition>.

## Why

<Why the previous behavior caused harm and what failure will recur if ignored.>

## How to Apply

- **Trigger:** <when this situation arises>.
- **Pre-action check:** <mandatory verification before acting>.
- **Expected outcome:** <correct output or behavior>.
- **Exceptions:** <when different behavior is permitted, if any>.

## Evidence / Scope Boundary

<Link to the incident or commit; state clearly whether this applies globally or only to a specific workspace.>
