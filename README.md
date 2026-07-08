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

## Token & cost: the problem, and what this cuts

When you run coding agents on a repo all day, the bill is driven by **tokens** — the chunks of text
the model reads (input) and writes (output). ([What's a token?](https://platform.openai.com/tokenizer)
Output tokens are the pricey side — with current Claude tiers, roughly **5× the price of input**.)
Four everyday habits quietly run the meter up. This skill installs the counter-habit for each:

| The challenge (what runs the meter up) | What init-norms installs | Rough saving on the affected work* |
|---|---|---|
| **Re-reading big files.** An agent re-opens the same 800-line module (~10k tokens) to answer "what does this export?" — 30×/week = ~300k tokens on *one* file. | `docs/HOT-FILES.md` cheat-sheet + a canonical `SYSTEM.md`: agents read a ~40-line map (~600 tokens) instead of the file. | ~**94%** fewer tokens on those lookups (600 vs 10k per read). |
| **Top-tier model on routine turns.** Running the most expensive model for `git status`, a one-line edit, or a lookup. | `.claude/settings.json` pins a **mid-tier** default; you escalate per-session only for hard work. | Mid tier is ~**5× cheaper per token** than top tier — so routine turns cost ~1/5. |
| **Verbose output.** Chatty prose burns output tokens (the 5×-priced side) with no added correctness. | The token/cost playbook points at a terse-output mode (e.g. the caveman plugin) for chatty turns. | ~**75%** fewer *output* tokens on those turns (technical content unchanged). |
| **Wide reads bloat the main thread.** Sweeping 40 files (~400k tokens) to answer one question leaves all 400k in context, inflating every later turn. | The playbook delegates wide reads to a **subagent** that returns just the ~500-token conclusion. | Main-thread context stays lean; the 400k never compounds across the rest of the session. |

*\*Illustrative order-of-magnitude estimates, not a benchmark — real savings depend on repo size,
file sizes, and how you work. The point is the **mechanism** and that these habits **compound**: a
long-running repo pays for them every single day.* The full playbook lives in §9 of the generated
`CLAUDE.md`.

## Advanced usage: large codebases

On a big repo (or a monorepo), two habits dominate the bill: **re-reading source** and **dumping raw
command output**. The companion skill **`init-norms-scale`** installs the counter-habit for each. Both
lean on optional, user-installed tools — swap in any equivalent; keep the norm.

- **Query a code-graph instead of re-reading files.** Build a persistent knowledge graph of the repo
  once, rebuild it incrementally on a SessionStart hook, then answer "how does X work / what calls Y"
  by *querying the graph* — not by opening thousands of lines each session. The graph's most-connected
  "god nodes" also seed `docs/HOT-FILES.md` with the repo's real hot files.
  (`graphify` is one such tool; the norm is what matters, not the tool.)
- **Compress high-volume browsing output.** Wrap noisy, low-stakes commands (`git log`, `ls`, dep
  installs, long greps) in an output-compressing CLI proxy so they return a fraction of the tokens.
  Because such proxies are **lossy** (truncate / dedup / group), the rule is strict: **browsing only —
  NEVER wrap diagnostics** (tests, migrations, deploys, stack traces, `git diff`/`git status` before a
  commit), and never a global auto-rewrite hook. A lossy filter can eat the one line that is the
  signal. (`rtk`, the Rust Token Killer, is one such tool.)

Why it compounds at scale: a 2k-line core module is ~25k tokens; reopened a few times a day across a
team, that's millions of tokens a week re-deriving what a graph query answers in a few hundred. The
graph pays back its build cost within a day.

Install the advanced skill the same way as init-norms (it's a sibling folder in this repo):
```
git clone https://github.com/sanjeevnair/claude-init-norms /tmp/claude-init-norms
cp -r /tmp/claude-init-norms/init-norms-scale ~/.claude/skills/init-norms-scale   # or copy on Windows
```
Then, in a repo already set up with init-norms: *"Use init-norms-scale to add the large-codebase
tooling."*

## Install

Clone (or copy) this repo into your Claude Code skills directory as `init-norms`.

macOS / Linux / WSL / Git Bash:
```
# personal (all your projects)
git clone https://github.com/sanjeevnair/claude-init-norms ~/.claude/skills/init-norms

# or per-project (shared with the team via the repo)
git clone https://github.com/sanjeevnair/claude-init-norms <repo>/.claude/skills/init-norms
```

Windows (PowerShell):
```powershell
# personal (all your projects)
git clone https://github.com/sanjeevnair/claude-init-norms "$HOME\.claude\skills\init-norms"

# or per-project (shared with the team via the repo)
git clone https://github.com/sanjeevnair/claude-init-norms "<repo>\.claude\skills\init-norms"
```

The skill name is `init-norms` (from `SKILL.md`), so the destination folder must be named `init-norms`.
Update it later with `git -C ~/.claude/skills/init-norms pull` (`$HOME\.claude\...` on Windows).

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
scripts/setup.sh    ← safe scaffolder, macOS/Linux/WSL/Git Bash (no overwrite)
scripts/setup.ps1   ← safe scaffolder, Windows PowerShell (identical behavior)
templates/          ← everything it drops into a repo, all {{PLACEHOLDER}}-tokenized
init-norms-scale/   ← OPTIONAL companion skill: advanced token tooling for large codebases
                      (code-graph query workflow + compressed-output CLI proxy)
```

## Unfamiliar with a term?

This skill leans on standard software-delivery vocabulary. If any of it is new, here are neutral,
vendor-generic explainers:

| Term | In one line | Learn more |
|---|---|---|
| **SDLC** | Software Development Life Cycle — the stages code goes through from idea to production. | [Wikipedia](https://en.wikipedia.org/wiki/Systems_development_life_cycle) |
| **CI (continuous integration)** | Automatically build + test every change so breakage is caught early. | [GitHub docs](https://docs.github.com/en/actions/automating-builds-and-tests/about-continuous-integration) |
| **Pull request (PR)** | A proposed change others review before it merges. | [GitHub docs](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests) |
| **Branch protection** | Rules that stop direct/force pushes to a branch and require review + passing CI. | [GitHub docs](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches) |
| **CODEOWNERS** | A file listing who must review changes to given paths. | [GitHub docs](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners) |
| **Release / staging environment** | Staging is a prod-like environment to verify a change before it goes live. | [Wikipedia](https://en.wikipedia.org/wiki/Deployment_environment) |
| **Trunk-based vs feature-branch** | Two common branching models; init-norms works with either. | [Trunk-based](https://trunkbaseddevelopment.com/) · [Feature-branch](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow) |
| **Linting** | Automated checks for style/mistakes; house rules can be encoded as lint rules that fail CI. | [Wikipedia](https://en.wikipedia.org/wiki/Lint_(software)) |
| **Unit / integration / e2e tests** | The "test pyramid" — narrow fast tests up to broad real-flow ones. | [Fowler](https://martinfowler.com/articles/practical-test-pyramid.html) |
| **Regression test** | A test that proves a fixed bug stays fixed. | [Wikipedia](https://en.wikipedia.org/wiki/Regression_testing) |
| **BRD / spec** | Business Requirements Document — writes down what a feature must do before you build it. | [Requirements doc](https://en.wikipedia.org/wiki/Product_requirements_document) |
| **Definition of Done** | The agreed checklist a change must meet before it counts as "done". | [Scrum.org](https://www.scrum.org/resources/what-definition-done) |
| **Responsive design** | UI that renders correctly at every screen width. | [MDN](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Responsive_Design) |
| **Design tokens / design system** | One source of truth for colors/spacing so code never hard-codes raw values. | [Material 3](https://m3.material.io/foundations/design-tokens/overview) |
| **Token (LLM)** | The unit of text a model reads/writes; you're billed per token. | [Anthropic pricing](https://www.anthropic.com/pricing) |

## Principle
If a norm matters, make CI fail when it's broken. A lint rule or a required check beats a doc line.

## License
MIT — use, fork, share.
