# R200 — Commit & Git Conventions

Konvensi commit dan git untuk Sangu. Tujuan: riwayat yang bisa dibaca,
di-scan otomatis, dan aman untuk Ratchet Principle.

## R200.1 — Format Conventional Commits

Tiap commit MUST mengikuti:

```
<type>(<scope>): <subject>

<body opsional>

<footer opsional>
```

Contoh valid:
- `feat(transactions): tambah form input manual`
- `fix(db): perbaiki migrasi tabel category`
- `docs(harness): tambah rule R500 AI integration`

Contoh invalid:
- `update stuff` (tanpa type)
- `Feat: X` (type kapital)
- `feat: .` (subject kosong)

## R200.2 — Whitelist type

Type yang diizinkan: **feat, fix, docs, refactor, test, chore, perf,
build, ci**. MUST NOT pakai type di luar daftar ini.

| Type | Kapan |
|---|---|
| feat | fitur baru yang tampak ke user |
| fix | perbaikan bug |
| docs | dokumentasi (docs/, .harness/, README, learning_docs) |
| refactor | ubah kode tanpa ubah perilaku |
| test | tambah/ubah test saja |
| chore | tugas pemeliharaan (deps, config) |
| perf | peningkatan performa |
| build | sistem build / dependency (`pubspec`) |
| ci | pipeline CI (`.github/**`) |

## R200.3 — Whitelist scope

Scope yang diizinkan (area/fitur): **transactions, dashboard,
receipts, insights, gamification, db, ai, theme, core, shared,
harness, deps**. Scope opsional tapi SHOULD diisi bila jelas.

## R200.4 — Aturan subject

- Imperatif, huruf kecil di awal (`tambah`, bukan `Menambahkan`).
- MUST NOT diakhiri titik.
- SHOULD ≤ 72 karakter.
- Jelaskan **apa**, bukan **bagaimana**.

## R200.5 — Aturan body

- Dipisah baris kosong dari subject.
- Jelaskan **kenapa**, bukan mengulang subject.
- Cite ADR/rule bila relevan (`per ADR-016`, `melanggar sebelumnya R100.3`).
- Wrap ~72 karакter.

## R200.6 — Aturan footer

- `BREAKING CHANGE: <deskripsi>` untuk perubahan tak kompatibel.
- Referensi issue bila ada (`Refs #12`).

## R200.7 — Breaking changes

Perubahan yang memutus kompatibilitas (mis. skema Drift yang butuh
migrasi merusak) MUST ditandai `BREAKING CHANGE:` di footer atau `!`
setelah type (`feat(db)!: ...`).

## R200.8 — Commit atomik

Satu commit = satu perubahan logis. MUST NOT mencampur fitur + refactor
+ format dalam satu commit. Doc-zone dan runtime-zone SHOULD di commit
terpisah kecuali memang satu unit logis (R900.8).

## R200.9 — Penamaan branch

Format: `<type>/<deskripsi-singkat>` (mis. `feat/transaction-form`,
`docs/adopt-harness`). MUST NOT commit fitur langsung ke `main` bila
perubahan besar; buat branch dulu.

## R200.10 — Signed commits (opsional)

Commit SHOULD ditandatangani (SSH/GPG) agar GitHub menampilkan
"Verified". Ini SHOULD, bukan MUST, untuk project personal.

## R200.11 — Commit doc-zone oleh agent

Saat agent mengedit zona dokumentasi langsung (R900.8), commit MUST
type `docs` atau `docs(<scope>)` dan body MUST cite ADR/rule yang
memotivasi editan.
