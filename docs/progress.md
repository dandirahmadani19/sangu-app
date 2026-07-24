# progress.md — Sangu

**Tujuan:** sumber kebenaran tunggal untuk "di mana kita sekarang".
Tiap sesi dimulai dengan `/session-start` (baca file ini), diakhiri
dengan `/session-end` (update file ini). Model apa pun bisa lanjut.

## Current Phase

**M0 — Setup & Harness** (sedang berjalan).

- Harness governance (`.harness/` + migrasi ADR/T-###): **hampir selesai**
  (lihat `docs/plans/adopt-contractiq-harness.md`).
- Bootstrap Flutter (`analysis_options`, `pubspec`, folder, lefthook,
  CI): **belum** (lihat `docs/plans/week-0-setup-harness.md`).
- Health: CI belum ada (project Flutter belum di-bootstrap).

## Current Task

**Next up: T-002 — `analysis_options.yaml` (very_good_analysis + exclude generated).**

- Deps: T-001 (adopsi harness) — hampir selesai
- Est: S · Zona: runtime (advisor-only — agent usul, developer eksekusi)
- Spec penuh: `docs/MVP.md#M0`

Setelah T-002: T-003 (pubspec dependency inti) → T-004 (folder skeleton).

## Blocker

- Belum ada.

## Keputusan pending

- Lihat "Pertanyaan terbuka" di `docs/DECISIONS.md` (hex warna, font,
  daftar badge, nama model Gemini).

## Session Log

Format: tanggal + tujuan singkat; task disentuh (✓ selesai, ~ in-progress,
! blocked); learning/keputusan; next action. Terbaru di atas.

### 2026-07-24 — Adopsi harness pola ContractIQ (T-001)

- **T-001 ~** — Bangun `.harness/` (README + 10 rule R000..R900 +
  6 prompt + 3 checklist + 2 contoh), `.sangu-project`.
- Migrasi `docs/DECISIONS.md` D-01..19 → **ADR-001..018** penuh;
  `ARCHITECTURE.md` berhenti menomori ADR sendiri (rujuk register).
- **ADR-016** (model-agnostik) *supersedes* D-18/D-19 (dual-model
  Claude/DeepSeek). **ADR-017** (adopsi `.harness/` + doc-zone
  auto-edit). **ADR-018** (learning_docs repo terpisah).
- `CLAUDE.md` ditulis ulang: netral-model, advisor-only,
  MANDATORY READS, UNDERSTAND→PLAN→PROPOSE→WAIT.
- `docs/MVP.md` + backlog **T-001..044** (M0 penuh; M1–M6 shape ringkas).
- `scripts/*.sh` (profil model opsional + `use_custom.sh`) &
  `.claude/commands/*.md` (selaras harness) sudah di-apply (R900
  ditangguhkan sesaat atas izin user). Memory disinkron.
- **Tersisa di T-001:** git setup `learning_docs/` sebagai repo terpisah
  + tambah `learning_docs/` ke `.gitignore` repo utama (T-008, aksi git
  developer).
- **Next:** tuntaskan git `learning_docs`, lalu T-002 (analysis_options).

### 2026-07-04 — Planning awal

- Buat 6 file konteks (CLAUDE.md, ARCHITECTURE, DESIGN, MVP, DECISIONS,
  progress). Semua keputusan besar terkunci (kala itu format D-##).
- Buat `docs/plans/week-0-setup-harness.md` (bootstrap Flutter).

---

## Cara pakai file ini

- **Mulai sesi:** `/session-start` → agent baca file ini, ringkas
  posisi, usul langkah.
- **Akhir sesi:** `/session-end` → update Current Phase, Current Task,
  tambah entri Session Log di atas.
- **Baca cepat (agent):** Current Phase → Current Task → 1–2 entri
  Session Log teratas. Jangan baca seluruh log kecuali menyelidiki
  riwayat.
