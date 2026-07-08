# init-norms — a Claude Code skill

Bootstrap any repository with SDLC norms + Claude Code config and the machine-enforcement that makes
them stick: staging-first branch discipline, a promotion gate, a test policy, a feature/BRD process,
design-system + responsive rules, a docs-never-drift contract, a hot-files cheat-sheet (cuts token
re-reads), the Claude token/cost playbook, plus a CI required check, PR template, and CODEOWNERS.

Everything is generic and templated with `{{PLACEHOLDER}}` tokens — no org- or project-specific
references.

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
you for the few unknowns (`{{ORG}}`/`{{TEAM}}`, promote command), wires a `verify` script, and lists
the manual GitHub steps (create the team, set branch protection).

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
