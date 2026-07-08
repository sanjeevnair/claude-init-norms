# init-norms — scaffold SDLC norms + Claude config into a repo.
# Usage:  pwsh scripts/setup.ps1 [-Target <TARGET_REPO_DIR>]   (defaults to current dir)
# Safe: never overwrites an existing file; prints what it wrote + what it skipped.
# Runs on PowerShell 7+ (pwsh, cross-platform) and Windows PowerShell 5.1.
#
# Reading guide (each block is labelled below, mirrors setup.sh):
#   1. SETTINGS   — where templates come from, where they go.
#   2. GUARDRAILS — bail early if paths are wrong.
#   3. COPY HELPER — the no-overwrite copy function used for every file.
#   4. FILE LIST  — the actual "template -> repo path" mapping. Edit this to add/remove files.
#   5. SUMMARY    — what happened + the manual steps a script can't do.
[CmdletBinding()]
param(
  [Parameter(Position = 0)]
  [string]$Target = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'

# ── 1. SETTINGS ──────────────────────────────────────────────────────────────
# ScriptDir = folder this script lives in. Src = the templates/ next to it.
# Dest = target repo (the -Target arg, or the current directory if none given).
# $PSScriptRoot is the script's own directory (PowerShell 3+); robust across pwsh
# and Windows PowerShell 5.1, and correct even when invoked with a relative path.
$ScriptDir = $PSScriptRoot
# Two-arg Join-Path for Windows PowerShell 5.1 compatibility (3-arg needs PS 6+).
$Src  = Join-Path (Join-Path $ScriptDir '..') 'templates'
$Dest = $Target

# ── 2. GUARDRAILS ────────────────────────────────────────────────────────────
# Stop before touching anything if the templates or the target are missing.
if (-not (Test-Path -LiteralPath $Src -PathType Container)) {
  Write-Error 'templates/ not found next to the skill'; exit 1
}
if (-not (Test-Path -LiteralPath $Dest -PathType Container)) {
  Write-Error "Target dir not found: $Dest"; exit 1
}

Write-Host "Scaffolding norms into: $Dest"
Write-Host ''

# ── 3. COPY HELPER ───────────────────────────────────────────────────────────
# Copy-Template SrcRel DestRel: create the destination folder, then copy ONLY if
# the destination doesn't already exist (never clobbers your files). Tallies results.
$script:wrote = 0
$script:skipped = 0
function Copy-Template([string]$SrcRel, [string]$DestRel) {
  $srcPath = Join-Path $Src $SrcRel
  $dstPath = Join-Path $Dest $DestRel
  $dstDir  = Split-Path -Parent $dstPath
  if (-not (Test-Path -LiteralPath $dstDir)) { New-Item -ItemType Directory -Path $dstDir -Force | Out-Null }
  if (Test-Path -LiteralPath $dstPath) {
    Write-Host "  skip (exists): $DestRel"; $script:skipped++
  } else {
    Copy-Item -LiteralPath $srcPath -Destination $dstPath
    Write-Host "  wrote:         $DestRel"; $script:wrote++
  }
}

# ── 4. FILE LIST (template path  ->  path inside the repo) ────────────────────
Copy-Template 'CLAUDE.template.md'                    'CLAUDE.md'                              # norms contract agents read every session
Copy-Template '.claude/settings.json'                 '.claude/settings.json'                 # per-repo Claude config (model tier, hooks)
Copy-Template '.github/workflows/ci.yml'              '.github/workflows/ci.yml'              # the required CI check
Copy-Template '.github/pull_request_template.md'      '.github/pull_request_template.md'      # Definition-of-Done checklist on every PR
Copy-Template '.github/CODEOWNERS'                    '.github/CODEOWNERS'                     # who must review critical paths
Copy-Template 'docs/SYSTEM.md'                        'docs/SYSTEM.md'                        # canonical architecture explainer
Copy-Template 'docs/HOT-FILES.md'                     'docs/HOT-FILES.md'                     # cheat-sheet of most-read files (cuts token re-reads)
Copy-Template 'docs/features/PROCESS.md'              'docs/features/PROCESS.md'              # how a feature goes from idea to shipped
Copy-Template 'docs/features/_template/BRD.md'        'docs/features/_template/BRD.md'        # blank spec template
Copy-Template 'docs/features/_template/decisions.md'  'docs/features/_template/decisions.md'  # blank decision-log template

# ── 5. SUMMARY + MANUAL STEPS ────────────────────────────────────────────────
Write-Host ''
Write-Host "Done. Wrote $script:wrote file(s), skipped $script:skipped existing."
Write-Host ''
Write-Host 'NEXT (fill placeholders + wire enforcement):'
Write-Host '  1. Replace every {{PLACEHOLDER}} - incl. {{ORG}}/{{TEAM}} in CODEOWNERS.'
Write-Host "  2. Ensure a 'verify' script exists (typecheck + lint + test + build) so CI + PR checklist match."
Write-Host '  3. GitHub UI: create the @{{ORG}}/{{TEAM}} team, then branch-protect the release branch'
Write-Host '     (require CI + review + code-owner review, block force-push; restrict promotion if you run one).'
