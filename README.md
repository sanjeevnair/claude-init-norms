<div align="center">

# 🛡️ init-norms

**Bootstrap any repo with SDLC norms + Claude Code config — and the CI teeth that make them stick.**

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Claude Code skill](https://img.shields.io/badge/Claude%20Code-skill-8A2BE2)](https://docs.anthropic.com/en/docs/claude-code)
[![Platforms](https://img.shields.io/badge/platforms-macOS%20%7C%20Linux%20%7C%20Windows-blue)](#-install)
[![PRs welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](#-license)

*Decisions made once, enforced by machines — not re-argued in every PR.*

</div>

---

One command drops a full norms contract into a repo — branch discipline, a merge/release gate, a test
policy, a feature/BRD process, design-system + responsive rules, a docs-never-drift contract, a
hot-files cheat-sheet, and the Claude token/cost playbook — plus the machine-enforcement that backs it
(a required CI check, a PR template, and CODEOWNERS). Everything is generic and `{{PLACEHOLDER}}`-tokenized
— no org- or project-specific references.

> [!NOTE]
> **What's a "skill"?** A folder Claude Code reads to learn a repeatable task. Drop this in your skills
> directory and Claude can scaffold a repo for you on request — no manual copying.

## ⚡ Quick start

```bash
# 1. Install the skill (macOS/Linux — Windows below)
git clone https://github.com/sanjeevnair/claude-init-norms ~/.claude/skills/init-norms
```
Then, in any repo, tell Claude Code:
> *"Use the init-norms skill to set up this repo — infer what you can, ask me only what you can't."*

That's it. Claude runs the scaffolder, fills in what it can read from the repo, and asks you for the
handful it can't.

## 🎯 Why it helps

The payoff: decisions get made once and then enforced by machines, not re-argued in every PR.

| | |
|---|---|
| 🚫 **Bad code can't reach prod** | Whatever branch model you pick, the release branch is protected — it moves only through a reviewed PR that a passing CI check gates. No direct pushes, no force-pushes, no "works on my machine" merges. |
| 🔁 **Regressions stay fixed** | No feature without a test, no bug fix without a regression test, same PR. Every fix becomes a permanent guard instead of a bug that quietly returns in three months. |
| 📚 **Docs never drift** | The docs-in-the-same-change contract + a canonical `SYSTEM.md` keep the architecture explainer trustworthy — humans and agents onboard from docs instead of reverse-engineering the code. |
| 💸 **Agents cost less, hallucinate less** | The token/cost playbook (right-sized model, hot-files map, subagent delegation, terse mode) cuts spend daily — and a leaner context means fewer wrong turns. |
| 👥 **Everyone starts configured** | A committed `.claude/settings.json` + `CLAUDE.md` travel with the repo, so every contributor's first session runs the same model, hooks, and rules — zero setup drift. |
| 🦷 **Norms have teeth** | Anything expressible as a lint rule or required check becomes one — violations fail CI, not "the reviewer's memory." Human review is reserved for judgment a machine can't make. |
| 🚄 **Features ship on rails** | grill → spec → approve → build test-first → verify → done. The hard decisions happen up front, and "done" actually means done — status is literally the folder the spec lives in. |
| 🔓 **Zero lock-in** | Every value is `{{PLACEHOLDER}}`-tokenized and every section is optional. Delete what doesn't apply (no design system, single-branch repo, no promotion workflow) — the rest still stands. |

## 💸 Token & cost: the problem, and what this cuts

When you run coding agents on a repo all day, the bill is driven by **tokens** — the chunks of text
the model reads (input) and writes (output). ([What's a token?](https://platform.openai.com/tokenizer)
Output is the pricey side — roughly **5× the price of input** on current Claude tiers.) Four everyday
habits quietly run the meter up. This skill installs the counter-habit for each:

| 🔥 The challenge | 🧯 What init-norms installs | 📉 Rough saving\* |
|---|---|---|
| **Re-reading big files** — an agent reopens the same 800-line module (~10k tokens) to answer "what does this export?"; 30×/week = ~300k tokens on *one* file. | `docs/HOT-FILES.md` + a canonical `SYSTEM.md`: agents read a ~40-line map (~600 tokens), not the file. | ~**94%** fewer tokens per lookup (600 vs 10k). |
| **Top-tier model on routine turns** — the most expensive model for `git status`, a one-line edit, a lookup. | `.claude/settings.json` pins a **mid-tier** default (Sonnet); escalate to **Opus** per-session only for architecture, design, hard debugging. | Mid tier ~**5× cheaper/token** — routine turns cost ~⅕. |
| **Verbose output** — chatty prose burns output tokens (the 5×-priced side) for no added correctness. | A terse-output mode (e.g. the [caveman](https://github.com/JuliusBrussee/caveman) plugin) on chatty turns. | ~**75%** fewer *output* tokens (content unchanged). |
| **Wide reads bloat the thread** — sweeping 40 files (~400k tokens) for one answer leaves all 400k in context, inflating every later turn. | Delegate wide reads to a **subagent** that returns just the ~500-token conclusion. | The 400k never compounds across the session. |

> [!IMPORTANT]
> \*Illustrative order-of-magnitude estimates, **not a benchmark** — real savings depend on repo size,
> file sizes, and how you work. The point is the **mechanism**, and that these habits **compound**: a
> long-running repo pays for them every single day. Full playbook: §9 of the generated `CLAUDE.md`.

## 🚀 Install

Clone (or copy) this repo into your Claude Code skills directory as `init-norms`.

<details open>
<summary><b>macOS / Linux / WSL / Git Bash</b></summary>

```bash
# personal (all your projects)
git clone https://github.com/sanjeevnair/claude-init-norms ~/.claude/skills/init-norms

# or per-project (shared with the team via the repo)
git clone https://github.com/sanjeevnair/claude-init-norms <repo>/.claude/skills/init-norms
```
</details>

<details>
<summary><b>Windows (PowerShell)</b></summary>

```powershell
# personal (all your projects)
git clone https://github.com/sanjeevnair/claude-init-norms "$HOME\.claude\skills\init-norms"

# or per-project (shared with the team via the repo)
git clone https://github.com/sanjeevnair/claude-init-norms "<repo>\.claude\skills\init-norms"
```
</details>

The skill name is `init-norms` (from `SKILL.md`), so the destination folder **must** be named `init-norms`.
Update it later:
- **macOS/Linux** — `git -C ~/.claude/skills/init-norms pull`
- **Windows** — `git -C "$HOME\.claude\skills\init-norms" pull`

## 🧭 Use

In any repo, ask Claude Code:

> *"Use the init-norms skill to set up this repo — infer what you can, ask me only what you can't."*

Claude runs the scaffolder (never overwrites existing files), fills placeholders from the repo, asks
you for the few unknowns (`{{ORG}}`/`{{TEAM}}`, your branch model, promote command if any), wires a
`verify` script, and lists the manual GitHub steps (create the team, set branch protection).

## 🐘 Advanced: large codebases

On a big repo (or a monorepo), two habits dominate the bill: **re-reading source** and **dumping raw
command output**. The companion skill **`init-norms-scale`** installs the counter-habit for each. Both
lean on optional, user-installed tools — swap in any equivalent; keep the norm.

- 🕸️ **Query a code-graph instead of re-reading files.** Build a persistent knowledge graph once,
  rebuild it incrementally on a SessionStart hook, then answer "how does X work / what calls Y" by
  *querying the graph* — not by opening thousands of lines each session. The graph's most-connected
  "god nodes" also seed `docs/HOT-FILES.md` with the repo's real hot files.
  ([graphify](https://pypi.org/project/graphifyy/) is one such tool; the norm is what matters.)
- 🗜️ **Compress high-volume browsing output.** Wrap noisy, low-stakes commands (`git log`, `ls`, dep
  installs, long greps) in an output-compressing CLI proxy so they return a fraction of the tokens.
  ([rtk](https://github.com/rtk-ai/rtk), the Rust Token Killer, is one such tool.)

> [!WARNING]
> Output proxies like rtk are **lossy** (truncate / dedup / group). Use them on **browsing only** —
> **NEVER on diagnostics**: tests, migrations, deploys, stack traces, or `git diff`/`git status` before
> a commit. A lossy filter can eat the one line that is the signal (the lone failing assert, the
> 404→422 transition). And never install a global auto-rewrite hook.

**Why it compounds:** a 2k-line core module is ~25k tokens; reopened a few times a day across a team,
that's millions of tokens a week re-deriving what a graph query answers in a few hundred. The graph
pays back its build cost within a day.

### Step 1 — install the optional tools you'll use

`init-norms-scale` wires these in but doesn't ship them — install whichever levers you want (skip the
rest; the setup self-guards if a tool is absent):

| Tool | What it does | Install | Link |
|---|---|---|---|
| **graphify** | The code-graph you query instead of re-reading files. Command is `graphify`; the pip package is `graphifyy`. | `uv tool install graphifyy` — or `pip install graphifyy` (macOS/Linux/Windows) | [PyPI](https://pypi.org/project/graphifyy/) |
| **rtk** | Compresses high-volume browsing output (Rust Token Killer). | macOS/Linux: `brew install rtk` · Windows: a release binary from the repo | [GitHub](https://github.com/rtk-ai/rtk) |

### Step 2 — install the companion skill

It's a sibling folder in this repo, so once init-norms is installed you copy the subfolder up into its
own skill directory (skills can't be nested):

```bash
# macOS / Linux / WSL / Git Bash
cp -r ~/.claude/skills/init-norms/init-norms-scale ~/.claude/skills/init-norms-scale
```
```powershell
# Windows (PowerShell)
Copy-Item -Recurse "$HOME\.claude\skills\init-norms\init-norms-scale" "$HOME\.claude\skills\init-norms-scale"
```

### Step 3 — run it

In a repo already set up with init-norms: *"Use init-norms-scale to add the large-codebase tooling."*
It detects which tools you installed, merges a self-guarding graphify SessionStart hook into
`.claude/settings.json`, seeds `docs/HOT-FILES.md` from the graph, and appends the rtk/graph rules to
`CLAUDE.md`.

## 🗂️ Layout

```
SKILL.md            ← skill entry point (how the agent runs it)
README.md           ← this file
LICENSE             ← MIT
scripts/setup.sh    ← safe scaffolder, macOS/Linux/WSL/Git Bash (no overwrite)
scripts/setup.ps1   ← safe scaffolder, Windows PowerShell (identical behavior)
templates/          ← everything it drops into a repo, all {{PLACEHOLDER}}-tokenized
init-norms-scale/   ← OPTIONAL companion skill: advanced token tooling for large codebases
```

## 📖 New to the jargon?

<details>
<summary><b>Glossary — neutral, vendor-generic explainers for every term this skill leans on</b></summary>

<br>

| Term | In one line | Learn more |
|---|---|---|
| **SDLC** | Software Development Life Cycle — the stages code goes through from idea to production. | [Wikipedia](https://en.wikipedia.org/wiki/Systems_development_life_cycle) |
| **CI (continuous integration)** | Automatically build + test every change so breakage is caught early. | [GitHub docs](https://docs.github.com/en/actions/automating-builds-and-tests/about-continuous-integration) |
| **Pull request (PR)** | A proposed change others review before it merges. | [GitHub docs](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests) |
| **Branch protection** | Rules that stop direct/force pushes to a branch and require review + passing CI. | [GitHub docs](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches) |
| **CODEOWNERS** | A file listing who must review changes to given paths. | [GitHub docs](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners) |
| **Release / staging environment** | Staging is a prod-like environment to verify a change before it goes live. | [Wikipedia](https://en.wikipedia.org/wiki/Deployment_environment) |
| **Trunk-based vs feature-branch** | Two common branching models; init-norms works with either. | [Trunk-based](https://trunkbaseddevelopment.com/) · [Feature-branch](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow) |
| **Linting** | Automated checks for style/mistakes; house rules can be lint rules that fail CI. | [Wikipedia](https://en.wikipedia.org/wiki/Lint_(software)) |
| **Unit / integration / e2e tests** | The "test pyramid" — narrow fast tests up to broad real-flow ones. | [Fowler](https://martinfowler.com/articles/practical-test-pyramid.html) |
| **Regression test** | A test that proves a fixed bug stays fixed. | [Wikipedia](https://en.wikipedia.org/wiki/Regression_testing) |
| **BRD / spec** | Business Requirements Document — writes down what a feature must do before you build it. | [Requirements doc](https://en.wikipedia.org/wiki/Product_requirements_document) |
| **Definition of Done** | The agreed checklist a change must meet before it counts as "done". | [Scrum.org](https://www.scrum.org/resources/what-definition-done) |
| **Responsive design** | UI that renders correctly at every screen width. | [MDN](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Responsive_Design) |
| **Design tokens / design system** | One source of truth for colors/spacing so code never hard-codes raw values. | [Material 3](https://m3.material.io/foundations/design-tokens/overview) |
| **Token (LLM)** | The unit of text a model reads/writes; you're billed per token. | [Anthropic pricing](https://www.anthropic.com/pricing) |

</details>

## 🧠 Principle

> **If a norm matters, make CI fail when it's broken.** A lint rule or a required check beats a doc line.

## 📄 License

MIT — use, fork, share.
