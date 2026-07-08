# Feature Development Process

Every **substantial** feature follows this. Trivial fixes (copy, styling, one-line bug + its
regression test, dep bumps, docs) skip the spec but still need a test when behavior changes.

1. **Intake + grilling** — interrogate every branch of the decision tree. Resolve real forks WITH
   the user; never guess a decision the user owns. Mandatory even under time pressure.
2. **Write the BRD** from `_template/BRD.md` into `proposed/FEAT-00X-slug/`. Log locked decisions +
   rejected options in `decisions.md`.
   - **Cross-cutting?** (touches another feature's data/auth, a new external dependency, or a new
     collection/contract) → complete a design gate first: a sequence/data-flow diagram + the
     integration contract (shape/auth/lifetime of what crosses the boundary). Get it approved before code.
3. **Approval**, then `git mv` the folder to `building/`. Build **test-first** (red → green → refactor).
4. **Verify** locally (`{{VERIFY_SCRIPT}}`) + exercise the real flow. Commit staging-first.
5. **Definition of Done** → `git mv` to `shipped/`:
   - Tests added + passing; `{{VERIFY_SCRIPT}}` green.
   - `docs/SYSTEM.md` + hot-files updated in the same change.
   - Responsive verified (if UI).
   - Staging proof stated (if user-facing).

**Status = the stage folder:** `proposed/ → building/ → shipped/ (→ archived/)`.
BRD is source of truth; the roadmap is just the dashboard.
