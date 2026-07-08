# init-norms — scaffold SDLC norms + Claude config into a repo.
# Usage:  pwsh scripts/setup.ps1 [-Target <TARGET_REPO_DIR>]   (defaults to current dir)
# Safe: never overwrites an existing file; prints what it wrote + what it skipped.
# Runs on PowerShell 7+ (pwsh, cross-platform) and Windows PowerShell 5.1.
[CmdletBinding()]
param(
  [Parameter(Position = 0)]
  [string]$Target = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
# Two-arg Join-Path for Windows PowerShell 5.1 compatibility (3-arg needs PS 6+).
$Src  = Join-Path (Join-Path $ScriptDir '..') 'templates'
$Dest = $Target

if (-not (Test-Path -LiteralPath $Src -PathType Container)) {
  Write-Error 'templates/ not found next to the skill'; exit 1
}
if (-not (Test-Path -LiteralPath $Dest -PathType Container)) {
  Write-Error "Target dir not found: $Dest"; exit 1
}

Write-Host "Scaffolding norms into: $Dest"
Write-Host ''

$script:wrote = 0
$script:skipped = 0
function Copy-Template([string]$SrcRel, [string]$DestRel) {   # copy SRC_REL -> DEST_REL (no overwrite)
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

Copy-Template 'CLAUDE.template.md'                    'CLAUDE.md'
Copy-Template '.claude/settings.json'                 '.claude/settings.json'
Copy-Template '.github/workflows/ci.yml'              '.github/workflows/ci.yml'
Copy-Template '.github/pull_request_template.md'      '.github/pull_request_template.md'
Copy-Template '.github/CODEOWNERS'                    '.github/CODEOWNERS'
Copy-Template 'docs/SYSTEM.md'                        'docs/SYSTEM.md'
Copy-Template 'docs/HOT-FILES.md'                     'docs/HOT-FILES.md'
Copy-Template 'docs/features/PROCESS.md'              'docs/features/PROCESS.md'
Copy-Template 'docs/features/_template/BRD.md'        'docs/features/_template/BRD.md'
Copy-Template 'docs/features/_template/decisions.md'  'docs/features/_template/decisions.md'

Write-Host ''
Write-Host "Done. Wrote $script:wrote file(s), skipped $script:skipped existing."
Write-Host ''
Write-Host 'NEXT (fill placeholders + wire enforcement):'
Write-Host '  1. Replace every {{PLACEHOLDER}} - incl. {{ORG}}/{{TEAM}} in CODEOWNERS.'
Write-Host "  2. Ensure a 'verify' script exists (typecheck + lint + test + build) so CI + PR checklist match."
Write-Host '  3. GitHub UI: create the @{{ORG}}/{{TEAM}} team, then branch-protect the release branch'
Write-Host '     (require CI + review + code-owner review, block force-push; restrict promotion if you run one).'
