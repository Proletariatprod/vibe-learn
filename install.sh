#!/usr/bin/env bash
# vibe-learn installer: copies the skill into ~/.claude/skills/ (personal skills,
# available in every project). Safe to re-run; overwrites the previous version.
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)/vibe-learn"
DEST="$HOME/.claude/skills/vibe-learn"

if [ ! -f "$SRC/SKILL.md" ]; then
  echo "❌ Couldn't find vibe-learn/SKILL.md next to this script." >&2
  exit 1
fi

mkdir -p "$HOME/.claude/skills"
rm -rf "$DEST"
cp -R "$SRC" "$DEST"

echo "✅ vibe-learn installed to $DEST"
echo ""
echo "Next steps:"
echo "  • In any project:        say 'Set up vibe-learn in this project'"
echo "  • For existing projects: say 'Run vibe-learn baseline on this project'"
echo "  • If skills were added while Claude Code was running and it doesn't"
echo "    see the skill, restart the session."
