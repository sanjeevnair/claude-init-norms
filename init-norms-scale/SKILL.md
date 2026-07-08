---
name: init-norms-scale
description: Advanced token/cost tier for LARGE codebases — layers a code-graph query workflow (e.g. graphify) and a compressed-output CLI proxy (e.g. rtk) onto a repo so agents query a knowledge graph instead of re-reading files and read compressed command output on high-volume browsing. Companion to init-norms. Use when the user wants to optimize a big/monorepo for agents, mentions "large codebase", "token blowup at scale", "graphify", "rtk", "code graph", or "scale the norms".
---

# init-norms-scale

The **advanced tier** for repos big enough that re-reading files and raw command output dominate token
spend. It assumes the base norms are already in place (run `init-norms` first) and adds two levers:

1. **Query a code-graph, don't re-read source.** Build a persistent knowledge graph of the repo once,
   rebuild it incrementally on a SessionStart hook, and answer "how does X work / what calls Y" by
   querying the graph — not by opening thousands of lines every session. (`graphify` is one such tool.)
2. **Compress high-volume command output.** Wrap noisy, low-stakes browsing commands in an
   output-compressing CLI proxy so `git log`, `ls`, dep installs, and long greps return a fraction of
   the tokens. ([rtk](https://github.com/rtk-ai/rtk), the Rust Token Killer, is one such tool.)

Both tools are **optional** and user-installed — if they're absent, install-or-skip and say so; the
base init-norms token playbook still stands without them.

## Why it matters at scale

On a small repo, re-reads are cheap. On a large one they compound: a 2k-line core module is ~25k
tokens; if agents reopen it a few times a day across a team, that's millions of tokens a week spent
re-deriving what a graph query or a hot-files map answers in a few hundred. The graph pays for its
build cost within a day; the output proxy pays for itself on the first noisy `git log`.

## What it drops in

- **A graphify SessionStart hook** merged into `.claude/settings.json` — rebuilds the graph
  incrementally each session so queries are always current. Guarded: if the tool isn't installed the
  hook is a no-op, never blocks session start.
- **A CLAUDE.md addendum** (`templates/CLAUDE.scale-addendum.md`) — the graph-query-first rule and the
  **rtk safety rule**: compress browsing output only; NEVER wrap diagnostics (tests, migrations,
  deploys, `git diff`/`git status` before a commit, stack traces) — the proxy is lossy and can eat the
  one line that is the signal. Never install a global auto-rewrite hook.

## How to run it

Do these in order. Infer what you can; ask only for genuine forks.

### 1. Preconditions
- Confirm base norms exist (a `CLAUDE.md` from init-norms). If not, run `init-norms` first.
- Detect the tools:
  ```
  command -v graphify   # code-graph tool
  command -v rtk        # output-compressing proxy
  ```
  For any that's missing: tell the user where to get it and mark that lever **skipped** (don't fake it).

### 2. Merge the graphify SessionStart hook
Merge `templates/settings.graphify-hook.json` into the repo's `.claude/settings.json` (deep-merge the
`hooks.SessionStart` array — do NOT clobber existing hooks or other keys). The command self-guards:
it runs only if `graphify` is on PATH and exits 0 regardless, so a missing tool never blocks startup.

### 3. Build the initial graph + populate HOT-FILES
- Build once: `graphify . --no-viz` (or `--mode deep` on a gnarly repo).
- Use the graph's most-connected "god nodes" to fill `docs/HOT-FILES.md` (from init-norms) with the
  files agents will hit most — so the cheat-sheet reflects the real dependency structure, not a guess.

### 4. Append the CLAUDE.md addendum
Append `templates/CLAUDE.scale-addendum.md` to the repo's `CLAUDE.md` (a new "Advanced: large-codebase
tooling" section under the token/cost section). Fill any `{{PLACEHOLDER}}`. Delete the rtk half if the
user doesn't use an output proxy; delete the graph half if they don't use a code-graph tool.

### 5. Commit
Follow the repo's branch model (feature/dev branch, PR to the release branch). Don't push to the
release branch directly.

## Notes
- The graph is a **derived artifact** — add `graphify-out/` (and any vault dir) to `.gitignore` unless
  the team wants it versioned; the SessionStart hook rebuilds it anyway.
- rtk/graphify are examples, not requirements. Any equivalent code-graph or output-compression tool
  plugs into the same two slots — keep the norm (query-don't-reread, compress-browsing-only), swap the
  tool.
