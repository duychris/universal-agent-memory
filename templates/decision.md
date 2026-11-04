---
id: "decision-<YYYY-MM-DD>-<slug>"
name: "<decision title>"
scope: "<workspace/topic>"
kind: decision
status: proposed
created: "<YYYY-MM-DD>"
updated: "<YYYY-MM-DD>"
observed_at: "<YYYY-MM-DD or unknown>"
last_verified: "unknown"
review_after: null
source:
  - "<document / review / confirming session>"
owner: "<decision maker>"
agent: "<agent-id>"
confidence: supported
supersedes: []
---

# Decision: <Title>

## Question / Objective

<What is being decided and why?>

## Options & Trade-Offs

| Option | Benefits | Risks | Evidence |
|---|---|---|---|
| A | ... | ... | ... |
| B | ... | ... | ... |

## Outcome

- **Status:** `proposed` | `active` | `blocked` | `superseded`
- **Approved by:** `<owner or committee>`
- **Effective from:** `<date or pending>`
- **Chosen option:** `<option if active; "pending" if proposed>`
- **Rationale:** `<evidence and constraints>`

## Revisit / Rollback Conditions

<What new data or failure condition would trigger revisiting or rolling back this decision?>

## Related

<Links to research packs, reviews, or superseded decisions.>
