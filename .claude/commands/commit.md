Buat pesan commit Conventional Commits (R200) dari perubahan staged.

Format: <type>(<scope>): <subject>
- Type (R200.2): feat, fix, docs, refactor, test, chore, perf, build, ci
- Scope (R200.3): transactions, dashboard, receipts, insights,
  gamification, db, ai, theme, core, shared, harness, deps
- Subject (R200.4): imperatif, huruf kecil, tanpa titik, ≤72 char

Aturan:
- Commit doc-zone (docs/, .harness/, learning_docs) pakai type `docs:`
  + cite ADR/rule di body (R900.8, R200.11).
- Commit atomik: satu perubahan logis (R200.8).
- Bila breaking (mis. migrasi Drift): footer `BREAKING CHANGE:` (R200.7).

Berikan 1-2 pilihan pesan commit paling tepat.
