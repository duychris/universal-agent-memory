# Verification, Decisions & Error Correction

## 1. Precision in Status Language

| Phrase | Condition Required Before Using It |
|---|---|
| `I think / hypothesis` | Unverified hypothesis; state how to test it |
| `According to source X` | You actually read source X in full; cite path/line and scope |
| `Completed / Edited` | Changes were written and saved, but not necessarily verified |
| `Verified` | Independent check, test suite, or ground-truth comparison passed with traceable evidence |
| `Reviewed` | Structured inspection of raw diff/evidence completed with an explicit verdict |
| `Synced` | Read-after-write or remote push confirmed at the canonical destination |
| `Published / Deployed` | Live release verified at the production endpoint—never equated with `git commit` or `git push` |

---

## 2. Two Orthogonal State Axes — Never Conflate Them

- **Task State:** `assumption` → `pending` → `completed` → `verified` → `approved` → `published` (tracks execution progress).
- **Memory State:** `proposed` → `active` → `superseded` → `retracted` → `archived` (tracks rule/decision validity).

A task that is `completed` may not be `verified`. A technically `verified` change may not be `approved`. An `active` decision card does not prove the feature is `published`.

---

## 3. The Evidence Loop

1. State the **claim** to test and what evidence would falsify it.
2. Check **primary sources** (live code, raw data, official docs) rather than relying on memory summaries.
3. Test against known **ground-truth cases** and counterexamples; verify zero regression on previously passing cases.
4. Conclude strictly within the bounds of evidence; attach `confidence` and `status`.

---

## 4. Domain-Agnostic Verification Examples

- **Software Engineering:** Reproduce the bug, run tests before and after, verify cross-layer parity (e.g., server ↔ web ↔ mobile) and cache version bumps, inspect `git diff --cached`.
- **Research & Data Analysis:** Check primary datasets, sample sizes, time horizons, and holdout slices; never confuse correlation or volume with independent statistical proof.
- **Writing & Operations:** Verify names, numbers, constraints, and owner sign-off; separate drafts from approved publications.
