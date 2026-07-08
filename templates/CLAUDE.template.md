<!--
GENERIC CLAUDE.md TEMPLATE
Copy into a repo root as CLAUDE.md, fill every {{PLACEHOLDER}}, delete sections that
don't apply. This encodes SDLC norms + Claude token/cost practices distilled from a
real shipped project. It is the CONTRACT every human and agent on the repo follows.
Keep it short enough that people actually read it; link out to docs/ for detail.
-->

# {{PROJECT_NAME}} — CLAUDE.md

## Project

{{One paragraph: what it is, who it's for, the core value.}}
**Status:** {{built? live? what's shipped, what's gated, what's next — one line.}}
**How it works:** [docs/SYSTEM.md](docs/SYSTEM.md) is the canonical actor/flow/data explainer.
**Update it in the same change** as any feature touching an actor, route, data store, external
service, or flow — docs must never drift from code (enforced in Definition of Done).

---

## 1. Branch discipline

Pick the branch model that fits the project (trunk-based, feature-branch, or a dev→prod split) and
write it here. Whatever you pick, these hold:
- **Protect the release branch.** The branch that ships to production (`{{PROD_BRANCH}}`) changes only
  through a reviewed, CI-passing PR — never a direct push, never a force-push.
- **Don't develop on the release branch.** Work on a feature/dev branch, open a PR, merge when green.
- **Gate on CI, not vibes.** Nothing merges to the release branch that doesn't pass the verify check.

{{Optional — if you run a staging→prod (or dev→main) split with a promotion workflow, document it
here: how to promote (`{{PROMOTE_COMMAND}}`), and any per-branch config that must NOT be merged across
branches. If you're single-branch / trunk-based, delete this note.}}

## 2. Merge / release gate

Mock-green ≠ works. Before a user-facing change lands on the release branch, it needs BOTH:
1. **An integration/e2e test** driving the real flow against a real (emulated) backend — real writes, real session, real handlers.
2. **A real proof it works** — drive the actual flow and confirm the *observable* outcome (row written, page rendered, email delivered), not just unit-green. If you have a deployed staging env, prove it there on the live commit; otherwise prove it locally end-to-end.

State the proof (what you drove + observed) in the PR. Genuinely-unreachable paths
(admin SSO, real-inbox clicks) → cover with the e2e and say so; never silently skip.

## 3. Testing policy

**No feature without a test. No bug fix without a regression test.** Same PR, always.
- Feature → test asserting the new behavior.
- Bug fix → a test that FAILS before the fix and PASSES after (prove it).
- Pure data/config → assert the shape/routing relied on.
- Server code hitting a datastore → mock the boundary; don't call live services.
- Integration/funnel flows → prefer a real-backend e2e; mock-heavy unit tests hide integration bugs.
- Genuinely untestable → say so explicitly and why; don't silently skip.

**Local gate = CI gate.** One command (`{{VERIFY_COMMAND}}` = typecheck + lint + test + build)
reproduces CI. Nothing merges that doesn't pass it.

## 4. Feature process (substantial work)

No code on a substantial feature before an approved spec. Trivial fixes (copy, styling, one-line
bug + its regression test, dep bumps, docs) skip the spec but still need a test when behavior changes.

1. **Intake + grilling** — interrogate every branch of the decision tree; resolve real forks with
   the user (don't guess decisions the user owns). Mandatory even when they're in a hurry.
2. **Write the spec** (`docs/features/proposed/FEAT-00X-slug/`), log locked decisions + rejected
   options. Flag cross-cutting work (touches another feature's data/auth, new dependency, new contract)
   and complete a design/integration-contract gate before any code.
3. **Approval**, then build **test-first** (red → green → refactor).
4. **Verify** locally + exercise the real flow, commit on a feature/dev branch (never straight to the release branch).
5. **Definition of Done** before "complete": tests pass, docs updated, real-flow proof stated.

**Status = the folder.** `proposed/ → building/ → shipped/ (→ archived/)`. Spec is source of
truth; the roadmap is just the dashboard.

## 5. Design system — build from primitives, never raw values

- **One primitive per need** (one Button, one Card…). Never add a second component that does the
  same job; extend the variant instead.
- **No raw hex / magic values** in code. Colors + tokens come from one source of truth, enforced by
  a lint rule. Fix a violation by reaching for the token, not by allowlisting.
- **Refactors are not restyles.** Swapping inline values for primitives = zero visual change; prove it.

## 6. Responsive (hard requirement)

Every page/component renders correctly at every viewport. Mobile-first, fluid units (rem/%/vw/fr +
flex/grid), not fixed px. No overflow/overlap/horizontal-scroll at any width. **Verify before "done"**
at {{320 / 768 / 1024 / 1440}}px with the preview tooling — don't ask the user to check.

## 7. Copy / content style

{{Project voice in one or two rules, e.g.: no em-dashes in user-facing copy (reads AI-generated) —
use a spaced hyphen or rephrase.}} Applies to all user-facing strings, emails, and marketing docs.

## 8. Critical files — touch with care

| File | Why critical |
|---|---|
| {{lib/constants or config}} | {{single source of X}} |
| {{state machine / core}} | {{all logic lives here}} |
| … | … |

Maintain a **hot-files cheat-sheet** ([docs/HOT-FILES.md](docs/HOT-FILES.md)) mapping the most-read
files' exports/shapes, linked from here so sessions read the map instead of re-opening full files.

---

## 9. Claude token & cost optimization

These cut spend without cutting rigor. They compound — a long-running repo pays for them daily.

**Right-size the model — top tier for hard thinking, mid tier for the rest.** Default the project to a
mid model in a committed `.claude/settings.json` (`"model": "sonnet"`) and escalate per-session
(`/model opus`) ONLY for the hard-task categories below. The top tier is ~5× the per-token cost, so
running it on routine coding is money lit on fire.

| Use the **top tier** (Opus) for | Use the **mid tier** (Sonnet, default) for |
|---|---|
| Architecture + system design | Feature coding to an agreed design |
| Hard debugging / subtle correctness | Routine edits, refactors, renames |
| Security-sensitive or concurrency logic | Tests, boilerplate, config |
| Ambiguous specs / trade-off calls | Git, lookups, docs, small fixes |

Rule of thumb: if the task is "decide *what* to build or *why* it's wrong," reach for Opus; if it's
"build the thing we already decided," Sonnet. Drop back to the default the moment the hard part is done.

**Don't re-read what's already summarized.** Keep a hot-files cheat-sheet (§8) and a canonical
SYSTEM.md so agents read one map, not thousands of lines of source every session. If a file is being
opened dozens of times a week, that's a signal to summarize it, not to keep re-reading.

**Delegate wide reads to subagents.** For "sweep many files to answer one question," spawn an Explore
/ general-purpose subagent — it burns its own context and returns just the conclusion, keeping the
main thread lean. Run independent searches in parallel in one message.

**Compress the register.** A terse-output mode (e.g. the caveman plugin) drops filler/articles/
pleasantries while keeping all technical substance and exact code/errors — ~75% fewer output tokens
on chatty turns. Turn it OFF while debugging hard problems where nuance matters.

**Persistent structure over re-derivation.** A code-graph tool (e.g. graphify) and a memory dir let
agents query relationships and recall prior decisions instead of re-exploring. Rebuild the graph on a
SessionStart hook so it's always current. On a large codebase this is the single biggest lever — see
the advanced tier (init-norms-scale) for the graph-query-first workflow.

**Compress high-volume browsing output.** An output-compressing CLI proxy (e.g. rtk) can cut noisy
command output — `git log`, `ls`, dep installs, long greps — to a fraction of the tokens. It is lossy,
so use it ONLY where completeness is irrelevant; NEVER on diagnostics (tests, migrations, deploys,
stack traces, `git diff`/`git status` before a commit). Never a global auto-rewrite hook.

**Use dedicated tools, not shell.** Prefer the file/search/edit tools over `cat`/`sed`/`grep` shells —
cheaper, and they don't dump whole files into context. Read only the slice you need (offset/limit).

**Act when you have enough.** Don't re-derive established facts, re-litigate settled decisions, or
narrate options you won't take. Recommend, don't survey.

**Scope tests + builds.** Run the quick verify (typecheck + lint + test) in the loop; run the full
build only before push. Don't rebuild to check a type error.

---

## 10. Enforcing the norms (machine first, humans second)

Conventions in a doc get ignored; put teeth where you can. Ranked by strength:

**Machine-enforced (can't be skipped):**
- **CI required check** — `{{VERIFY_COMMAND}}` (typecheck + lint + test + build) on every PR; deploy
  only what passes. This is the backbone.
- **Branch protection** on `{{PROD_BRANCH}}` — require PR + passing CI + review; block direct pushes
  and force-pushes. If you run a promotion workflow, restrict who can trigger it.
- **Custom lint rules** — encode house rules as ESLint rules (no-raw-hex, no-second-button, banned
  imports) so violations fail CI, not code review.
- **Committed `.claude/settings.json`** — model tier, enabled plugins, and SessionStart hooks travel
  with the repo, so every contributor's agent starts configured the same way.
- **Pre-commit hook** (optional) — run the quick verify locally so failures surface before push.
- **CODEOWNERS** — require an owner's review on critical files/dirs.

**Convention-enforced (needs buy-in, but make it easy):**
- **This CLAUDE.md** — the contract. Agents read it every session; humans read it in the PR template.
- **PR template with a Definition-of-Done checklist** — test added? docs updated? real-flow proof stated?
  responsive verified? Reviewers refuse to approve unchecked boxes.
- **Spec-folder workflow** — status = folder; a feature isn't "done" until its spec is in `shipped/`.
- **Onboarding one-pager** — point new contributors (and their agents) at CLAUDE.md first.

Rule of thumb: if a norm matters, try to make CI fail when it's broken. Everything that can be a lint
rule or a required check should be. Reserve human review for judgment CI can't make.
