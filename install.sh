#!/usr/bin/env bash
# Universal Agent Memory v3.0 — Automated Installer (macOS / Linux / WSL)
# Usage:
#   bash install.sh [--lang en|vi] [--platform all|claude,codex,gemini,antigravity] [--ref v3.0.0] [--dry-run]
#   curl -fsSL https://raw.githubusercontent.com/duychris/universal-agent-memory/v3.0.0/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/duychris/universal-agent-memory/v3.0.0/install.sh | bash -s -- --lang vi

set -euo pipefail

LANG_CHOICE="en"
PLATFORM_CHOICE="all"
GIT_REF="main"
DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: install.sh [OPTIONS]

Options:
  --lang <en|vi>                  Language edition to install (default: en)
  --platform <list>               Comma-separated platforms: all,claude,codex,gemini,antigravity (default: all)
  --ref <git-ref>                 Git tag/branch to clone when running remotely (default: main, e.g. v3.0.0)
  --dry-run                       Preview all actions without modifying any files
  -h, --help                      Show this help message
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --lang)
      if [[ $# -lt 2 ]]; then
        echo "❌ ERROR: --lang requires a value (en or vi)." >&2
        exit 1
      fi
      LANG_CHOICE="$2"
      shift 2
      ;;
    --lang=*)
      LANG_CHOICE="${1#*=}"
      shift
      ;;
    --platform)
      if [[ $# -lt 2 ]]; then
        echo "❌ ERROR: --platform requires a value (all, claude, codex, gemini, antigravity)." >&2
        exit 1
      fi
      PLATFORM_CHOICE="$2"
      shift 2
      ;;
    --platform=*)
      PLATFORM_CHOICE="${1#*=}"
      shift
      ;;
    --ref)
      if [[ $# -lt 2 ]]; then
        echo "❌ ERROR: --ref requires a branch or tag name." >&2
        exit 1
      fi
      GIT_REF="$2"
      shift 2
      ;;
    --ref=*)
      GIT_REF="${1#*=}"
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "❌ ERROR: Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ "$LANG_CHOICE" != "en" && "$LANG_CHOICE" != "vi" ]]; then
  echo "❌ ERROR: Unsupported --lang '$LANG_CHOICE'. Allowed values: en, vi." >&2
  exit 1
fi

# Parse and validate platforms
WANT_CLAUDE=0
WANT_CODEX=0
WANT_GEMINI=0
WANT_ANTIGRAVITY=0

IFS=',' read -r -a PLAT_ARR <<< "$PLATFORM_CHOICE"
for p in "${PLAT_ARR[@]}"; do
  case "$p" in
    all)
      WANT_CLAUDE=1
      WANT_CODEX=1
      WANT_GEMINI=1
      WANT_ANTIGRAVITY=1
      ;;
    claude)
      WANT_CLAUDE=1
      ;;
    codex)
      WANT_CODEX=1
      ;;
    gemini)
      WANT_GEMINI=1
      ;;
    antigravity)
      WANT_ANTIGRAVITY=1
      ;;
    *)
      echo "❌ ERROR: Unsupported platform '$p'. Allowed values: all, claude, codex, gemini, antigravity." >&2
      exit 1
      ;;
  esac
done

# Preflight 1: Check required tools
if ! command -v python3 >/dev/null 2>&1; then
  echo "❌ ERROR: 'python3' is required by install.sh for safe marker validation and file updates, but was not found in PATH." >&2
  exit 1
fi

if [[ -z "${HOME:-}" || ! -d "$HOME" ]]; then
  echo "❌ ERROR: \$HOME is not set or does not exist." >&2
  exit 1
fi

if [[ "$DRY_RUN" -eq 0 && ! -w "$HOME" ]]; then
  echo "❌ ERROR: \$HOME ($HOME) is not writable." >&2
  exit 1
fi

REPO_URL="${UAM_REPO_URL:-https://github.com/duychris/universal-agent-memory.git}"
SKILL_NAME="universal-agent-memory"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

SCRIPT_DIR=""
if [[ -n "${BASH_SOURCE[0]:-}" && -f "${BASH_SOURCE[0]}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

TMP_DIR=""
cleanup() {
  if [[ -n "$TMP_DIR" && -d "$TMP_DIR" ]]; then
    rm -rf "$TMP_DIR"
  fi
}
trap cleanup EXIT

if [[ -n "$SCRIPT_DIR" && -f "$SCRIPT_DIR/SKILL.md" ]]; then
  SRC_ROOT="$SCRIPT_DIR"
else
  if ! command -v git >/dev/null 2>&1; then
    echo "❌ ERROR: 'git' is required to download Universal Agent Memory when running via curl, but was not found in PATH." >&2
    exit 1
  fi
  TMP_DIR="$(mktemp -d)"
  echo "⬇️  Downloading Universal Agent Memory ($GIT_REF) from $REPO_URL ..."
  if ! git clone --depth 1 --branch "$GIT_REF" "$REPO_URL" "$TMP_DIR/$SKILL_NAME" >/dev/null 2>&1; then
    echo "❌ ERROR: Failed to clone $REPO_URL (ref: $GIT_REF). Check network connectivity and git ref." >&2
    exit 1
  fi
  SRC_ROOT="$TMP_DIR/$SKILL_NAME"
fi

if [[ "$LANG_CHOICE" == "vi" ]]; then
  SKILL_SRC="$SRC_ROOT/i18n/vi"
  echo "🇻🇳 Selected Vietnamese edition (--lang vi)"
else
  SKILL_SRC="$SRC_ROOT"
  echo "🌐 Selected International English edition (--lang en)"
fi

# Preflight 2: Verify source integrity before touching any user files
REQUIRED_SRC_ITEMS=(
  "$SKILL_SRC/SKILL.md"
  "$SKILL_SRC/README.md"
  "$SKILL_SRC/HDSD.md"
  "$SKILL_SRC/RELEASE-NOTES.md"
  "$SKILL_SRC/TEST-CASES.md"
  "$SRC_ROOT/LICENSE"
  "$SKILL_SRC/references"
  "$SKILL_SRC/rules"
  "$SKILL_SRC/templates"
  "$SKILL_SRC/examples"
)

for item in "${REQUIRED_SRC_ITEMS[@]}"; do
  if [[ ! -e "$item" ]]; then
    echo "❌ ERROR: Source package is incomplete; missing required path: $item" >&2
    exit 1
  fi
done

# Build deduplicated target skill directories and global rule mappings
SKILL_TARGETS=()
RULE_FILES=()
RULE_TEMPLATES=()

add_skill_target() {
  local candidate="$1"
  local existing
  for existing in "${SKILL_TARGETS[@]:-}"; do
    if [[ "$existing" == "$candidate" ]]; then
      return 0
    fi
  done
  SKILL_TARGETS+=("$candidate")
}

add_rule_target() {
  local rfile="$1"
  local rtpl="$2"
  local existing
  for existing in "${RULE_FILES[@]:-}"; do
    if [[ "$existing" == "$rfile" ]]; then
      return 0
    fi
  done
  RULE_FILES+=("$rfile")
  RULE_TEMPLATES+=("$rtpl")
}

if [[ "$WANT_CLAUDE" -eq 1 ]]; then
  add_skill_target "$HOME/.claude/skills/$SKILL_NAME"
  add_rule_target "$HOME/.claude/CLAUDE.md" "$SKILL_SRC/rules/claude-code.md"
fi

if [[ "$WANT_CODEX" -eq 1 ]]; then
  add_skill_target "$HOME/.agents/skills/$SKILL_NAME"
  add_rule_target "$HOME/.codex/AGENTS.md" "$SKILL_SRC/rules/codex.md"
fi

if [[ "$WANT_GEMINI" -eq 1 ]]; then
  add_skill_target "$HOME/.agents/skills/$SKILL_NAME"
  add_rule_target "$HOME/.gemini/GEMINI.md" "$SKILL_SRC/rules/gemini.md"
fi

if [[ "$WANT_ANTIGRAVITY" -eq 1 ]]; then
  add_skill_target "$HOME/.gemini/config/skills/$SKILL_NAME"
  add_rule_target "$HOME/.gemini/GEMINI.md" "$SKILL_SRC/rules/gemini.md"
fi

# Preflight 3: Validate marker integrity in all target Global Rules files BEFORE modifying anything
validate_marker_file() {
  local rule_file="$1"
  local template_file="$2"
  python3 - "$rule_file" "$template_file" <<'PY'
import os
import sys

rule_path, tpl_path = sys.argv[1], sys.argv[2]
BEGIN = "<!-- UAM-V3:BEGIN -->"
END = "<!-- UAM-V3:END -->"

if not os.path.isfile(tpl_path):
    print(f"❌ ERROR: Missing rule template file: {tpl_path}", file=sys.stderr)
    sys.exit(1)

with open(tpl_path, "r", encoding="utf-8") as f:
    tpl = f.read()

if tpl.count(BEGIN) != 1 or tpl.count(END) != 1 or tpl.index(BEGIN) > tpl.index(END):
    print(f"❌ ERROR: Malformed UAM-V3 markers in template: {tpl_path}", file=sys.stderr)
    sys.exit(1)

if not os.path.exists(rule_path):
    sys.exit(0)

if not os.path.isfile(rule_path):
    print(f"❌ ERROR: Global Rules target is not a regular file: {rule_path}", file=sys.stderr)
    sys.exit(1)

with open(rule_path, "r", encoding="utf-8") as f:
    content = f.read()

b_count = content.count(BEGIN)
e_count = content.count(END)

if b_count != e_count:
    print(
        f"❌ ERROR: Unbalanced UAM-V3 markers in {rule_path} (BEGIN={b_count}, END={e_count}). "
        "Aborting without modifying any files. Please fix the markers manually first.",
        file=sys.stderr,
    )
    sys.exit(1)

if b_count > 1:
    print(
        f"❌ ERROR: Duplicate UAM-V3 marker blocks ({b_count} blocks) found in {rule_path}. "
        "Aborting without modifying any files. Please keep only one block.",
        file=sys.stderr,
    )
    sys.exit(1)

if b_count == 1 and content.index(BEGIN) > content.index(END):
    print(
        f"❌ ERROR: Inverted UAM-V3 markers (END appears before BEGIN) in {rule_path}. "
        "Aborting without modifying any files.",
        file=sys.stderr,
    )
    sys.exit(1)
PY
}

for idx in "${!RULE_FILES[@]}"; do
  validate_marker_file "${RULE_FILES[$idx]}" "${RULE_TEMPLATES[$idx]}"
done

# Step 1: Install Skill directories safely (preserving custom user files & backing up modified managed files)
install_skill_dir() {
  local dest="$1"
  python3 - "$SKILL_SRC" "$SRC_ROOT" "$dest" "$LANG_CHOICE" "$DRY_RUN" "$TIMESTAMP" <<'PY'
import filecmp
import os
import shutil
import sys

skill_src, src_root, dest, lang, dry_run_str, ts = sys.argv[1:7]
dry_run = dry_run_str == "1"

# Collect all managed relative paths -> source file paths
managed_files = {}
top_files = ["SKILL.md", "README.md", "HDSD.md", "RELEASE-NOTES.md", "TEST-CASES.md"]
if lang == "en" and os.path.isfile(os.path.join(skill_src, "README.vi.md")):
    top_files.append("README.vi.md")

for fname in top_files:
    managed_files[fname] = os.path.join(skill_src, fname)
managed_files["LICENSE"] = os.path.join(src_root, "LICENSE")

for folder in ["references", "rules", "templates", "examples"]:
    folder_src = os.path.join(skill_src, folder)
    for root, _, files in os.walk(folder_src):
        for fn in files:
            abs_src = os.path.join(root, fn)
            rel_path = os.path.relpath(abs_src, skill_src)
            managed_files[rel_path] = abs_src

dest_exists = os.path.isdir(dest)
modified_existing = []
custom_files = []

if dest_exists:
    for root, _, files in os.walk(dest):
        for fn in files:
            abs_dst = os.path.join(root, fn)
            rel_dst = os.path.relpath(abs_dst, dest)
            if rel_dst in managed_files:
                if not filecmp.cmp(managed_files[rel_dst], abs_dst, shallow=False):
                    modified_existing.append(rel_dst)
            else:
                custom_files.append(rel_dst)

if dry_run:
    if not dest_exists:
        print(f"🔍 [DRY-RUN] Would create and install Skill ({len(managed_files)} files) -> {dest}")
    elif modified_existing:
        backup_dir = f"{dest}.uam-backup-{ts}"
        print(
            f"🔍 [DRY-RUN] Would backup {len(modified_existing)} modified file(s) to {backup_dir} "
            f"and update Skill -> {dest}"
        )
    else:
        print(f"🔍 [DRY-RUN] Skill already up to date (0 file changes) -> {dest}")
    if custom_files:
        print(f"ℹ️  [DRY-RUN] Would preserve {len(custom_files)} custom user file(s) in {dest}")
    sys.exit(0)

if dest_exists and modified_existing:
    backup_dir = f"{dest}.uam-backup-{ts}"
    for rel_path in modified_existing:
        src_to_bak = os.path.join(dest, rel_path)
        dst_bak = os.path.join(backup_dir, rel_path)
        os.makedirs(os.path.dirname(dst_bak), exist_ok=True)
        shutil.copy2(src_to_bak, dst_bak)
    print(f"📦 Backed up {len(modified_existing)} modified Skill file(s) -> {backup_dir}")

for rel_path, abs_src in sorted(managed_files.items()):
    abs_dst = os.path.join(dest, rel_path)
    os.makedirs(os.path.dirname(abs_dst), exist_ok=True)
    if not os.path.exists(abs_dst) or not filecmp.cmp(abs_src, abs_dst, shallow=False):
        shutil.copy2(abs_src, abs_dst)

if not dest_exists:
    print(f"✅ Installed Skill ({len(managed_files)} files) -> {dest}")
elif modified_existing:
    print(f"✅ Updated Skill ({len(modified_existing)} file(s) updated) -> {dest}")
else:
    print(f"✅ Skill already up to date -> {dest}")

if custom_files:
    print(f"ℹ️  Preserved {len(custom_files)} custom user file(s) in {dest}")
PY
}

for dest in "${SKILL_TARGETS[@]}"; do
  install_skill_dir "$dest"
done

# Warn if legacy duplicate ~/.codex/skills/universal-agent-memory exists alongside ~/.agents/skills/universal-agent-memory
if [[ "$WANT_CODEX" -eq 1 && -d "$HOME/.codex/skills/$SKILL_NAME" ]]; then
  echo "⚠️  WARNING: Detected legacy duplicate skill directory at $HOME/.codex/skills/$SKILL_NAME."
  echo "   OpenAI Codex uses $HOME/.agents/skills/$SKILL_NAME as the canonical user skill path."
  echo "   To avoid duplicate skill entries in Codex, consider moving or removing $HOME/.codex/skills/$SKILL_NAME."
fi

# Step 2: Safely inject or update <!-- UAM-V3:BEGIN --> ... <!-- UAM-V3:END --> in Global Rules with backup
upsert_marker_block() {
  local rule_file="$1"
  local template_file="$2"

  python3 - "$rule_file" "$template_file" "$DRY_RUN" "$TIMESTAMP" <<'PY'
import os
import re
import shutil
import sys

rule_path, tpl_path, dry_run_str, ts = sys.argv[1:5]
dry_run = dry_run_str == "1"

with open(tpl_path, "r", encoding="utf-8") as f:
    tpl = f.read()

m = re.search(r"(<!-- UAM-V3:BEGIN -->.*?<!-- UAM-V3:END -->)", tpl, flags=re.S)
if not m:
    sys.exit(1)
block = m.group(1)

file_existed = os.path.isfile(rule_path)
content = ""
if file_existed:
    with open(rule_path, "r", encoding="utf-8") as f:
        content = f.read()

pattern = re.compile(r"<!-- UAM-V3:BEGIN -->.*?<!-- UAM-V3:END -->", flags=re.S)
if pattern.search(content):
    # Use lambda so backslashes inside block are never interpreted as regex escapes
    new_content = pattern.sub(lambda _: block, content, count=1)
else:
    if content:
        sep = "\n\n" if not content.endswith("\n\n") else ""
        if not content.endswith("\n"):
            sep = "\n\n"
        elif content.endswith("\n") and not content.endswith("\n\n"):
            sep = "\n"
        new_content = content + sep + block + "\n"
    else:
        new_content = block + "\n"

if file_existed and new_content == content:
    if dry_run:
        print(f"🔍 [DRY-RUN] Global Rules already up to date (no changes) -> {rule_path}")
    else:
        print(f"✅ Global Rules already up to date -> {rule_path}")
    sys.exit(0)

if dry_run:
    if file_existed and content.strip():
        print(f"🔍 [DRY-RUN] Would backup {rule_path} -> {rule_path}.uam-backup-{ts} and update UAM-V3 block")
    else:
        print(f"🔍 [DRY-RUN] Would create Global Rules with UAM-V3 block -> {rule_path}")
    sys.exit(0)

os.makedirs(os.path.dirname(rule_path), exist_ok=True)
if file_existed and content.strip():
    backup_path = f"{rule_path}.uam-backup-{ts}"
    shutil.copy2(rule_path, backup_path)
    print(f"📦 Backed up existing Global Rules -> {backup_path}")

with open(rule_path, "w", encoding="utf-8") as f:
    f.write(new_content)

print(f"⚓ Anchored Global Rules -> {rule_path}")
PY
}

for idx in "${!RULE_FILES[@]}"; do
  upsert_marker_block "${RULE_FILES[$idx]}" "${RULE_TEMPLATES[$idx]}"
done

echo ""
if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "✅ Dry-run complete. No files were created or modified."
else
  echo "🎉 Universal Agent Memory v3.0 setup complete!"
  echo "   Open a new AI session and ask it to run the 4-layer health check (RULES LOADED, SKILL LOADED, MEMORY READABLE, PERSISTENCE VERIFIED)."
fi
