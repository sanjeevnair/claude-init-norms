#!/usr/bin/env bash
# init-norms — scaffold SDLC norms + Claude config into a repo.
# Usage:  bash scripts/setup.sh [TARGET_REPO_DIR]   (defaults to current dir)
# Safe: never overwrites an existing file; prints what it wrote + what it skipped.
#
# Reading guide (each block is labelled below):
#   1. SETTINGS   — where templates come from, where they go.
#   2. GUARDRAILS — bail early if paths are wrong.
#   3. COPY HELPER — the no-overwrite copy function used for every file.
#   4. FILE LIST  — the actual "template → repo path" mapping. Edit this to add/remove files.
#   5. SUMMARY    — what happened + the manual steps a script can't do.
set -euo pipefail

# ── 1. SETTINGS ──────────────────────────────────────────────────────────────
# SCRIPT_DIR = folder this script lives in. SRC = the templates/ next to it.
# DEST = target repo (first CLI arg, or the current directory if none given).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$SCRIPT_DIR/../templates"
DEST="${1:-$(pwd)}"

# ── 2. GUARDRAILS ────────────────────────────────────────────────────────────
# Stop before touching anything if the templates or the target are missing.
if [ ! -d "$SRC" ]; then echo "templates/ not found next to the skill" >&2; exit 1; fi
if [ ! -d "$DEST" ]; then echo "Target dir not found: $DEST" >&2; exit 1; fi

echo "Scaffolding norms into: $DEST"
echo

# ── 3. COPY HELPER ───────────────────────────────────────────────────────────
# copy SRC_REL DEST_REL: create the destination folder, then copy ONLY if the
# destination doesn't already exist (never clobbers your files). Tallies results.
wrote=0; skipped=0
copy() {
  local src="$SRC/$1" dst="$DEST/$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ]; then echo "  skip (exists): $2"; skipped=$((skipped+1));
  else cp "$src" "$dst"; echo "  wrote:         $2"; wrote=$((wrote+1)); fi
}

# ── 4. FILE LIST (template path  →  path inside the repo) ─────────────────────
copy "CLAUDE.template.md"                    "CLAUDE.md"                                # norms contract agents read every session
copy ".claude/settings.json"                 ".claude/settings.json"                   # per-repo Claude config (model tier, hooks)
copy ".github/workflows/ci.yml"              ".github/workflows/ci.yml"                # the required CI check
copy ".github/pull_request_template.md"      ".github/pull_request_template.md"        # Definition-of-Done checklist on every PR
copy ".github/CODEOWNERS"                     ".github/CODEOWNERS"                       # who must review critical paths
copy "docs/SYSTEM.md"                        "docs/SYSTEM.md"                          # canonical architecture explainer
copy "docs/HOT-FILES.md"                     "docs/HOT-FILES.md"                       # cheat-sheet of most-read files (cuts token re-reads)
copy "docs/features/PROCESS.md"              "docs/features/PROCESS.md"                # how a feature goes from idea to shipped
copy "docs/features/_template/BRD.md"        "docs/features/_template/BRD.md"          # blank spec template
copy "docs/features/_template/decisions.md"  "docs/features/_template/decisions.md"    # blank decision-log template

# ── 5. SUMMARY + MANUAL STEPS ────────────────────────────────────────────────
echo
echo "Done. Wrote $wrote file(s), skipped $skipped existing."
echo
echo "NEXT (fill placeholders + wire enforcement):"
echo "  1. Replace every {{PLACEHOLDER}} — incl. {{ORG}}/{{TEAM}} in CODEOWNERS."
echo "  2. Ensure a 'verify' script exists (typecheck + lint + test + build) so CI + PR checklist match."
echo "  3. GitHub UI: create the @{{ORG}}/{{TEAM}} team, then branch-protect the release branch"
echo "     (require CI + review + code-owner review, block force-push; restrict promotion if you run one)."
