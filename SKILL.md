---
name: init-norms
description: Bootstrap a repository with SDLC norms + Claude Code config — staging-first branch discipline, a promotion gate, a test policy, a feature/BRD process, design-system + responsive rules, a docs-never-drift contract, a hot-files cheat-sheet, the Claude token/cost playbook, and the machine-enforcement scaffolding (CI required check, PR template, CODEOWNERS) that makes the norms bite. Use when the user wants to set up project norms, standardize a repo, add a CLAUDE.md + governance, onboard a new project to their standards, or says "init-norms", "set up norms", "scaffold standards", or "bootstrap this repo".
---

# init-norms

Scaffold a repo with a reusable norms contract + the enforcement that backs it. Machine-enforced
beats convention: anything that can be a lint rule or a required CI check SHOULD be; reserve human
review for judgment CI can't make.

## What it drops in
- `CLAUDE.md` — the norms contract agents read every session (branch discipline, promotion gate,
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
```
bash scripts/setup.sh <REPO_ROOT>
```
If a target file already exists, the script skips it and reports — reconcile by hand rather than
clobbering.

### 2. Fill placeholders
Replace every `{{PLACEHOLDER}}` across `CLAUDE.md`, `.github/*`, and `docs/*`:

Infer from the repo:
- `{{PROJECT_NAME}}` — package.json / dir name.
- `{{PACKAGE_MANAGER}}` — lockfile (`pnpm-lock.yaml`→pnpm, `package-lock.json`→npm, `yarn.lock`→yarn).
- `{{VERIFY_SCRIPT}}` — a `verify` script in package.json; if absent, propose one (typecheck + lint +
  test + build) and add it. That command IS the gate.
- `{{DEV_BRANCH}}` / `{{PROD_BRANCH}}` — from `git branch` + the default branch (confirm; typical is
  a staging→main split).
- Critical-files table + `docs/HOT-FILES.md` — from the actual code (biggest / most-imported modules).

Ask the user (can't infer):
- `{{ORG}}` and `{{TEAM}}` — the GitHub org + the team slug that owns reviews (CODEOWNERS).
- `{{PROMOTE_COMMAND}}` — how prod deploys (workflow dispatch? manual? none yet?).
- Which sections don't apply (delete them — e.g. no design system, no promotion gate, single-branch repo).

### 3. Wire the verify script
If no `verify` script exists, add one so the CI check and the PR checklist reference the same command.

### 4. Tell the user the manual GitHub steps (can't be scripted)
- Create the `@{{ORG}}/{{TEAM}}` team, or CODEOWNERS is silently ignored.
- Branch protection on the prod branch: require PR + CI status check + review + **code-owner review**,
  block force-push, restrict who can run the promotion workflow.

### 5. Commit
Follow the repo's branch discipline (start on the dev branch). Commit the scaffold; don't push to
prod directly.

## Notes
- Two layers: this skill is the **per-repo** layer. The **global** layer (`~/.claude/CLAUDE.md`,
  `~/.claude/settings.json`) is set once per machine and follows the user across all repos — out of
  scope here; mention it if they haven't set it.
- Keep `CLAUDE.md` short enough that people actually read it; push detail into `docs/`.
