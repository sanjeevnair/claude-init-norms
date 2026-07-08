<!-- Keep this short and honest. Unchecked boxes = not ready to merge. -->

## What + why

<!-- One or two lines. Link the spec or issue. -->

## Definition of Done

- [ ] **Test added** — feature has a test asserting the new behavior; bug fix has a regression test that fails before / passes after.
- [ ] **`{{VERIFY_SCRIPT}}` passes locally** (typecheck + lint + test + build).
- [ ] **Docs updated in this PR** — `docs/SYSTEM.md` (if an actor/route/data store/service/flow changed) and any hot-files / spec docs.
- [ ] **Responsive verified** at 320 / 768 / 1024 / 1440px (if UI changed) — checked, not assumed.
- [ ] **Design primitives used** — no raw hex / magic values; no duplicate components.
- [ ] **Copy style** followed (if user-facing copy changed).
- [ ] **Spec advanced** — moved to the right stage folder (if a substantial feature).

## Staging proof (required for anything user-facing before promotion)

<!--
Mock-green != works. State what you drove on the DEPLOYED staging env and the observable outcome.
Genuinely-unreachable path? Say which e2e covers it instead.
-->

## Notes / risk

<!-- Anything a reviewer should look at hard. Delete if none. -->
