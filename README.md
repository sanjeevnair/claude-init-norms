# init-norms — a Claude Code skill

Bootstrap any repository with SDLC norms + Claude Code config and the machine-enforcement that makes
them stick: branch discipline (branch model left to you), a merge/release gate, a test policy, a
feature/BRD process, design-system + responsive rules, a docs-never-drift contract, a hot-files
cheat-sheet (cuts token re-reads), the Claude token/cost playbook, plus a CI required check, PR
template, and CODEOWNERS.

Everything is generic and templated with `{{PLACEHOLDER}}` tokens — no org- or project-specific
references.

## Why it helps

The payoff is that decisions get made once and then enforced by machines, not re-argued in every PR.
Concretely:

- **Bad code can't reach prod.** Whatever branch model you pick, the release branch is protected: it
  moves only through a reviewed PR that a passing CI check gates. No direct pushes, no force-pushes,
  no "works on my machine" merges.
- **Regressions stay fixed.** The test policy (no feature without a test, no bug fix without a
  regression test, same PR) turns every fix into a permanent guard instead of a fix that quietly
  breaks again three months later.
- **Docs never drift.** The docs-in-the-same-change contract + a canonical `SYSTEM.md` mean the
  architecture explainer is trustworthy — so humans and agents onboard from docs instead of reverse-
  engineering the code every time.
- **Agents cost less and hallucinate less.** The token/cost playbook (right-sized model tier, a
  hot-files cheat-sheet, subagent delegation, terse mode) cuts spend on a long-running repo daily,
  and a shorter context means fewer wrong turns.
- **New contributors (and their agents) start configured.** A committed `.claude/settings.json` +
  `CLAUDE.md` travel with the repo, so everyone's first session runs with the same model, plugins,
  hooks, and rules — zero setup drift across a team.
- **Norms have teeth.** Anything expressible as a lint rule or required check becomes one, so
  violations fail CI instead of relying on a reviewer to notice. Human review is reserved for the
  judgment calls a machine can't make.
- **Features ship on rails.** The BRD/spec process (grill → spec → approve → build test-first →
  verify → done) forces the hard decisions up front and makes "done" mean done — status is literally
  the folder the spec lives in.
- **No prescribed branch model.** Trunk-based, feature-branch, or a dev→staging→prod split — the
  norms hold either way. The gate is about a protected release branch + CI + a real proof, not a
  specific staging setup.
- **Zero lock-in.** Everything is `{{PLACEHOLDER}}`-tokenized and section-optional — delete what
  doesn't apply (no design system, single-branch repo, no promotion workflow) and the rest still stands.

## Install

Clone (or copy) this repo into your Claude Code skills directory as `init-norms`:

```
# personal (all your projects)
git clone https://github.com/sanjeevnair/claude-init-norms ~/.claude/skills/init-norms

# or per-project (shared with the team via the repo)
git clone https://github.com/sanjeevnair/claude-init-norms <repo>/.claude/skills/init-norms
```

The skill name is `init-norms` (from `SKILL.md`), so the destination folder must be named `init-norms`.
Update it later with `git -C ~/.claude/skills/init-norms pull`.

## Use

In any repo, ask Claude Code:

> "Use the init-norms skill to set up this repo — infer what you can, ask me only what you can't."

Claude runs the scaffolder (never overwrites existing files), fills placeholders from the repo, asks
you for the few unknowns (`{{ORG}}`/`{{TEAM}}`, your branch model, promote command if any), wires a
`verify` script, and lists the manual GitHub steps (create the team, set branch protection).

## Layout
```
SKILL.md            ← skill entry point (how the agent runs it)
README.md           ← this file
LICENSE             ← MIT
scripts/setup.sh    ← safe scaffolder (no overwrite)
templates/          ← everything it drops into a repo, all {{PLACEHOLDER}}-tokenized
```

## Principle
If a norm matters, make CI fail when it's broken. A lint rule or a required check beats a doc line.

## License
MIT — use, fork, share.
