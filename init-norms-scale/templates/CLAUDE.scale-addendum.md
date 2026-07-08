<!--
Append this to CLAUDE.md as a subsection of the token/cost section (§9 in the init-norms template).
Fill {{PLACEHOLDER}}s. Delete the half you don't use (code-graph OR output-proxy).
-->

## 9a. Advanced: large-codebase tooling

At scale, re-reading source and dumping raw command output are the two biggest token sinks. Two
optional tools cut them. Both are examples — keep the *norm*, swap the tool.

### Query the code-graph, don't re-read source

This repo has a persistent knowledge graph (built with `{{GRAPH_TOOL}}`, e.g. graphify) that a
SessionStart hook rebuilds incrementally. **Answer structure/relationship questions by querying it,
not by opening files.**

- "How does X work / what calls Y / trace the flow through Z" → `{{GRAPH_TOOL}} query "<question>"`
  first. Only open the specific file the query points you to.
- The graph's most-connected "god nodes" are the repo's real hot files — they seed
  [docs/HOT-FILES.md](docs/HOT-FILES.md). Read the map, then the one file, not the whole subtree.
- The graph is a derived artifact (`graphify-out/` is git-ignored); the hook keeps it current, so you
  never need a manual rebuild before querying.

### Compress high-volume command output — browsing ONLY

An output-compressing CLI proxy (`{{OUTPUT_PROXY}}`, e.g. rtk) can cut noisy command output to a
fraction of the tokens. It is **lossy** (truncate / dedup / group), so it is safe on high-volume
low-stakes browsing and dangerous on anything you reason about.

- **DO wrap** (completeness irrelevant): `git log`, `ls`, `tree`, dependency installs, long `grep`/`rg`
  sweeps you're skimming.
- **NEVER wrap** (fidelity is the whole point): test runs, DB migrations, deploy/health verification,
  stack traces / error output, and `git diff` / `git status` before a commit. Lossy filtering can eat
  the one line that is the actual signal (the lone failing assert, the 404→422 transition).
- **Never install the global auto-rewrite hook** — invisible filtering leads to confident-wrong
  conclusions ("tests pass" read off a compressed view). Opt in per command, not globally.
