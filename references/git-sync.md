# Git Safety & Cross-Machine Memory Sync

**Applies only when the workspace or memory store uses Git, symlinks, or Windows junctions.**

---

## 1. Session-Start Git Verification

Inside the workspace or memory repository:

```bash
pwd
git rev-parse --show-toplevel
git branch --show-current
git status --short
git remote -v
```

- Confirm the repo root, branch, and remote match the intended target.
- Before assuming local files are up to date, run `git fetch` (if network/permissions allow) and compare local vs. remote HEAD. **Only run `git pull --ff-only` when the working tree is clean and on the expected branch.**
- If offline or lacking remote permissions, state which local commit snapshot you are reading—**never claim "synced with remote."**
- If uncommitted work exists, never force a pull/rebase/reset over it.

---

## 2. Symlink & Junction Health Check (Preventing Split-Brain Memory)

Symptoms of a broken link: the agent writes a memory card, but `git status` in the memory repo shows nothing; two machines see different card counts; or OS reinstallation turned a symlink/junction into a plain local folder.

**macOS / Linux:**

```bash
ls -ld memory
readlink memory                 # if memory is a symlink
realpath memory                 # verify physical target path
```

**Windows PowerShell:**

```powershell
Get-Item -Force .\memory | Format-List FullName,LinkType,Target
Test-Path .\memory\MEMORY.md
```

**If a link is broken or memory has split into two divergent directories:**
1. **Halt writes** to both locations immediately; do not delete, move, or overwrite either folder.
2. Record both physical paths, file modification times, and Git commit SHAs.
3. Back up both sides, diff file-by-file, and reconcile conflicts based on evidence.
4. Only after verifying the merged canonical store, recreate the symlink/junction and verify with a read-after-write check.

**Never run `rm -rf` on an unmerged memory directory to recreate a symlink.**

---

## 3. Banned Bulk Staging & Destructive Commands

In shared or multi-agent workspaces, **never run**:

```bash
git add -A
git add .
git commit -am "..."
git reset --hard
git checkout -- <file>
git restore <file>
git clean -fd
git push --force
```

Why: `git add -A` absorbs half-written files saved by another agent running concurrently in the same directory. `git checkout -- <file>` permanently destroys uncommitted WIP that may have been sitting in the working tree awaiting deployment or review. If you need to temporarily mutate a file to test a failure mode, copy it first (`cp file file.tmp_bak`) and restore from your copy.

---

## 4. Stage Explicitly Within Scope

When your task modifies specific files (e.g., two memory files):

```bash
git status --short
git diff --name-only
git add -- memory/MEMORY.md memory/feedback-source-verification.md
git diff --cached --name-only
git diff --cached
git diff --cached --check
```

- **Check `git status --short` immediately before `git add`**—never rely on a status check from several minutes ago (before a build or test run).
- If another agent's files are already staged in the index, **do not commit**; isolate your work in a separate `git worktree` or coordinate with the owner.
- Commit with explicit agent attribution:
  ```bash
  git commit -m "[Claude] Record source-verification lesson"
  ```
- Remember: **`git push` is not deployment.** Never report changes as live in production unless a verified deployment step was authorized and completed.
