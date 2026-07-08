#!/usr/bin/env bash
# init-norms — scaffold SDLC norms + Claude config into a repo.
# Usage:  bash scripts/setup.sh [TARGET_REPO_DIR]   (defaults to current dir)
# Safe: never overwrites an existing file; prints what it wrote + what it skipped.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$SCRIPT_DIR/../templates"
DEST="${1:-$(pwd)}"

if [ ! -d "$SRC" ]; then echo "templates/ not found next to the skill" >&2; exit 1; fi
if [ ! -d "$DEST" ]; then echo "Target dir not found: $DEST" >&2; exit 1; fi

echo "Scaffolding norms into: $DEST"
echo

wrote=0; skipped=0
copy() {          # copy SRC_REL -> DEST_REL (no overwrite)
  local src="$SRC/$1" dst="$DEST/$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ]; then echo "  skip (exists): $2"; skipped=$((skipped+1));
  else cp "$src" "$dst"; echo "  wrote:         $2"; wrote=$((wrote+1)); fi
}

copy "CLAUDE.template.md"                    "CLAUDE.md"
copy ".claude/settings.json"                 ".claude/settings.json"
copy ".github/workflows/ci.yml"              ".github/workflows/ci.yml"
copy ".github/pull_request_template.md"      ".github/pull_request_template.md"
copy ".github/CODEOWNERS"                     ".github/CODEOWNERS"
copy "docs/SYSTEM.md"                        "docs/SYSTEM.md"
copy "docs/HOT-FILES.md"                     "docs/HOT-FILES.md"
copy "docs/features/PROCESS.md"              "docs/features/PROCESS.md"
copy "docs/features/_template/BRD.md"        "docs/features/_template/BRD.md"
copy "docs/features/_template/decisions.md"  "docs/features/_template/decisions.md"

echo
echo "Done. Wrote $wrote file(s), skipped $skipped existing."
echo
echo "NEXT (fill placeholders + wire enforcement):"
echo "  1. Replace every {{PLACEHOLDER}} — incl. {{ORG}}/{{TEAM}} in CODEOWNERS."
echo "  2. Ensure a 'verify' script exists (typecheck + lint + test + build) so CI + PR checklist match."
echo "  3. GitHub UI: create the @{{ORG}}/{{TEAM}} team, then branch-protect the release branch"
echo "     (require CI + review + code-owner review, block force-push; restrict promotion if you run one)."
