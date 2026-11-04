#!/usr/bin/env bash
# Universal Agent Memory v3.0 — Automated Installer (macOS / Linux / WSL)
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/duychris/universal-agent-memory/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/duychris/universal-agent-memory/main/install.sh | bash -s -- --lang vi

set -euo pipefail

LANG_CHOICE="en"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --lang)
      LANG_CHOICE="${2:-en}"
      shift 2
      ;;
    --lang=*)
      LANG_CHOICE="${1#*=}"
      shift
      ;;
    *)
      shift
      ;;
  esac
done

REPO_URL="https://github.com/duychris/universal-agent-memory.git"
SKILL_NAME="universal-agent-memory"

# Determine source directory (local checkout vs. curl | bash)
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
  TMP_DIR="$(mktemp -d)"
  echo "⬇️  Downloading Universal Agent Memory v3.0 from $REPO_URL ..."
  git clone --depth 1 "$REPO_URL" "$TMP_DIR/$SKILL_NAME" >/dev/null 2>&1
  SRC_ROOT="$TMP_DIR/$SKILL_NAME"
fi

if [[ "$LANG_CHOICE" == "vi" && -d "$SRC_ROOT/i18n/vi" ]]; then
  SKILL_SRC="$SRC_ROOT/i18n/vi"
  echo "🇻🇳 Installing Vietnamese edition (--lang vi)..."
else
  SKILL_SRC="$SRC_ROOT"
  echo "🌐 Installing International English edition (--lang en)..."
fi

# Target skill directories across Claude Code, OpenAI Codex, Gemini CLI, and Antigravity
TARGETS=(
  "$HOME/.claude/skills/$SKILL_NAME"
  "$HOME/.agents/skills/$SKILL_NAME"
  "$HOME/.codex/skills/$SKILL_NAME"
  "$HOME/.gemini/config/skills/$SKILL_NAME"
)

for dest in "${TARGETS[@]}"; do
  mkdir -p "$dest"
  cp "$SKILL_SRC/SKILL.md" "$dest/SKILL.md"
  cp -R "$SKILL_SRC/references" "$dest/"
  cp -R "$SKILL_SRC/templates" "$dest/"
  cp -R "$SKILL_SRC/rules" "$dest/"
  if [[ -f "$SRC_ROOT/HDSD.md" ]]; then
    cp "$SRC_ROOT/HDSD.md" "$dest/HDSD.md"
  fi
  if [[ -f "$SRC_ROOT/README.md" ]]; then
    cp "$SRC_ROOT/README.md" "$dest/README.md"
  fi
  echo "✅ Installed Skill -> $dest"
done

# Safely inject or update <!-- UAM-V3:BEGIN --> ... <!-- UAM-V3:END --> in Global Rules
upsert_marker_block() {
  local rule_file="$1"
  local template_file="$2"

  if [[ ! -f "$template_file" ]]; then
    return 0
  fi

  mkdir -p "$(dirname "$rule_file")"
  touch "$rule_file"

  python3 - "$rule_file" "$template_file" <<'PY'
import re
import sys

rule_path, tpl_path = sys.argv[1], sys.argv[2]
with open(tpl_path, "r", encoding="utf-8") as f:
    tpl = f.read()

m = re.search(r"(<!-- UAM-V3:BEGIN -->.*?<!-- UAM-V3:END -->)", tpl, flags=re.S)
if not m:
    sys.exit(0)
block = m.group(1)

with open(rule_path, "r", encoding="utf-8") as f:
    content = f.read()

pattern = re.compile(r"<!-- UAM-V3:BEGIN -->.*?<!-- UAM-V3:END -->", flags=re.S)
if pattern.search(content):
    new_content = pattern.sub(block, content)
else:
    sep = "\n\n" if content and not content.endswith("\n\n") else ("\n" if content and not content.endswith("\n") else "")
    new_content = content + sep + block + "\n"

with open(rule_path, "w", encoding="utf-8") as f:
    f.write(new_content)
PY
  echo "⚓ Anchored Global Rules -> $rule_file"
}

upsert_marker_block "$HOME/.claude/CLAUDE.md" "$SKILL_SRC/rules/claude-code.md"
upsert_marker_block "$HOME/.codex/AGENTS.md" "$SKILL_SRC/rules/codex.md"
upsert_marker_block "$HOME/.gemini/GEMINI.md" "$SKILL_SRC/rules/gemini.md"

echo ""
echo "🎉 Universal Agent Memory v3.0 installed successfully!"
echo "   Open a new AI session and ask it to run the 4-layer health check (RULES LOADED, SKILL LOADED, MEMORY READABLE, PERSISTENCE VERIFIED)."
