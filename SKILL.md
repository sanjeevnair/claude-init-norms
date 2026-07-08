---
name: init-norms
description: Bootstrap a repository with SDLC norms + Claude Code config — branch discipline (branch model left to the user), a merge/release gate, a test policy, a feature/BRD process, design-system + responsive rules, a docs-never-drift contract, a hot-files cheat-sheet, the Claude token/cost playbook, and the machine-enforcement scaffolding (CI required check, PR template, CODEOWNERS) that makes the norms bite. Use when the user wants to set up project norms, standardize a repo, add a CLAUDE.md + governance, onboard a new project to their standards, or says "init-norms", "set up norms", "scaffold standards", or "bootstrap this repo".
---

# init-norms

Scaffold a repo with a reusable norms contract + the enforcement that backs it. Machine-enforced
beats convention: anything that can be a lint rule or a required CI check SHOULD be; reserve human
review for judgment CI can't make.

## What it drops in
- `CLAUDE.md` — the norms contract agents read every session (branch discipline, merge/release gate,
  test policy, feature process, design system, responsive, copy style, hot-files, token/cost playbook).
- `.claude/settings.json` — project model tier (defaults to a mid model; escalate per-session).
- `.github/workflows/ci.yml` — the required verify check.
- `.github/pull_request_template.md` — a Definition-of-Done checklist.
- `.github/CODEOWNERS` — routes critical-path review to `@{{ORG}}/{{TEAM}}`.
- `docs/SYSTEM.md`, `docs/HOT-FILES.md`, `docs/features/PROCESS.md` + BRD/decisions templates.

All templates live in `templates/` next to this file and use `{{PLACEHOLDER}}` tokens.

## How to run it

Do these in order. Infer what you can from the repo; ask the user only for genuine forks.

### 1. Scaffold (never overwrites existing files)

macOS / Linux / WSL / Git Bash:
```
bash scripts/setup.sh <REPO_ROOT>
```
Windows — PowerShell 7+ (`pwsh`):
```
pwsh -File scripts\setup.ps1 <REPO_ROOT>
```
Windows — built-in Windows PowerShell 5.1 (no `pwsh` installed):
```
powershell -ExecutionPolicy Bypass -File scripts\setup.ps1 <REPO_ROOT>
```
`-ExecutionPolicy Bypass` avoids a "running scripts is disabled" block on machines with a restrictive
policy; it applies to this one invocation only. Both scripts do the same thing (identical copy list,
no-overwrite, same NEXT steps). Pick by the user's shell — check the environment platform. If a target
file already exists, the script skips it and reports — reconcile by hand rather than clobbering.

### 2. Fill placeholders
Replace every `{{PLACEHOLDER}}` across `CLAUDE.md`, `.github/*`, and `docs/*`:

Infer from the repo:
- `{{PROJECT_NAME}}` — package.json / dir name.
- `{{PACKAGE_MANAGER}}` — lockfile (`pnpm-lock.yaml`→pnpm, `package-lock.json`→npm, `yarn.lock`→yarn).
- `{{VERIFY_SCRIPT}}` — a `verify` script in package.json; if absent, propose one (typecheck + lint +
  test + build) and add it. That command IS the gate.
- `{{PROD_BRANCH}}` — the release branch that ships to production (usually the default branch; confirm).
- `{{DEV_BRANCH}}` — only if the user runs a dev/staging branch. Ask which branch model they want
  (trunk-based, feature-branch, or a dev→prod split); don't assume a staging split. If single-branch,
  drop `{{DEV_BRANCH}}` / `{{PROMOTE_COMMAND}}` and delete the promotion note in §1.
- Critical-files table + `docs/HOT-FILES.md` — from the actual code (biggest / most-imported modules).

Ask the user (can't infer):
- `{{ORG}}` and `{{TEAM}}` — the GitHub org + the team slug that owns reviews (CODEOWNERS).
- `{{PROMOTE_COMMAND}}` — only if they run a promotion workflow (workflow dispatch? manual? none).
- Which sections don't apply (delete them — e.g. no design system, single-branch repo, no promotion).

### 3. Wire the verify script
If no `verify` script exists, add one so the CI check and the PR checklist reference the same command.

### 4. Tell the user the manual GitHub steps (can't be scripted)
- Create the `@{{ORG}}/{{TEAM}}` team, or CODEOWNERS is silently ignored.
- Branch protection on the release branch: require PR + CI status check + review + **code-owner
  review**, block force-push. If they run a promotion workflow, restrict who can trigger it.

### 5. Commit
Follow the repo's branch model (feature/dev branch, PR to the release branch). Commit the scaffold;
don't push to the release branch directly.

## Notes
- Two layers: this skill is the **per-repo** layer. The **global** layer (`~/.claude/CLAUDE.md`,
  `~/.claude/settings.json`) is set once per machine and follows the user across all repos — out of
  scope here; mention it if they haven't set it.
- Keep `CLAUDE.md` short enough that people actually read it; push detail into `docs/`.
