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

**Next up: T-005 — `lefthook.yml` pre-commit gate.**

- Deps: T-004 (folder skeleton + main.dart placeholder) — **selesai**
- Est: S · Zona: runtime (advisor-only — agent usul, developer eksekusi)
- Spec penuh: `docs/MVP.md#M0`

Setelah T-005: T-006 (CI GitHub Actions).

## Blocker

- Belum ada.

## Keputusan pending

- Lihat "Pertanyaan terbuka" di `docs/DECISIONS.md` (hex warna, font,
  daftar badge, nama model Gemini).

## Session Log

Format: tanggal + tujuan singkat; task disentuh (✓ selesai, ~ in-progress,
! blocked); learning/keputusan; next action. Terbaru di atas.

### 2026-09-25 — T-004: folder skeleton + main.dart placeholder

- **T-004 ✓** — `lib/main.dart` diganti dari template counter default →
  `SanguApp` (root widget, `ProviderScope` dibungkus di `runApp`, siap
  Riverpod untuk T-012/T-013). `test/widget_test.dart` diganti smoke
  test placeholder (R100.13, R100.11, ADR-001, ADR-002). 17 folder
  skeleton (`lib/core/{db,ai,router,theme,utils}`, `lib/shared/widgets`,
  `lib/features/{dashboard,transactions,receipts,insights,gamification}/
  {presentation,data}`) dibuat sesuai `docs/ARCHITECTURE.md`, ditandai
  `.gitkeep`.
- Verifikasi: `flutter analyze` → 0 issues (6 info sebelumnya di
  `main.dart` template hilang total). `flutter test` → 1/1 passed.
- **Next:** commit T-004, lalu T-005 (`lefthook.yml` pre-commit gate).

### 2026-09-24 — Fix `flutter doctor`/`pub` permission + T-002

- **Blocker environment (di luar T-###) ✓** — `~/.pub-cache` ter-owned
  `root:staff` (bukan user), sebabkan `Permission denied errno=13` di
  `flutter upgrade`/`doctor`. Fix: `sudo chown -R $(whoami):staff
  ~/.pub-cache`. `flutter doctor` bersih, Flutter 3.47.5 stable.
- **T-002 ✓** — `analysis_options.yaml`: include
  `package:very_good_analysis/analysis_options.yaml` (ganti
  `flutter_lints`), `analyzer.exclude` untuk `*.g.dart`/`*.freezed.dart`
  (R100.1, R100.14, ADR-014). `pubspec.yaml`: dev_dependency
  `very_good_analysis: ^7.0.0` (ganti `flutter_lints`), `dependencies`
  diurutkan alfabetis (`cupertino_icons` sebelum `flutter`).
- **Insiden apply diff:** dua kali proposal di-apply tidak presisi oleh
  developer — (1) indentasi `very_good_analysis` sempat lepas dari
  `dev_dependencies:` (jadi top-level key, bikin `include_file_not_found`),
  (2) `cupertino_icons` sempat hilang total saat re-order. Keduanya
  terdeteksi lewat `flutter analyze`/`pub get` output dan diperbaiki via
  proposal susulan. **Hasil akhir:** `flutter analyze` → 6 issues, semua
  level **info** (bukan warning/error) di `lib/main.dart` template default
  (`public_member_api_docs`, `always_put_required_named_parameters_first`)
  — sesuai R100.1 (nol error, nol warning) sudah lolos; info ini akan
  hilang otomatis saat T-004 mengganti `main.dart`.
- **Next:** T-003 (pubspec dependency inti).

### 2026-09-24 — T-003: pubspec dependency inti + generator

- **T-003 ✓** — `flutter pub add` untuk dependencies runtime
  (`flutter_riverpod`, `riverpod_annotation`, `drift`, `drift_flutter`,
  `go_router`, `dio`, `flutter_animate`, `freezed_annotation`,
  `json_annotation`; ADR-002, ADR-003, ADR-004, ADR-005, ADR-006,
  ADR-010) dan `--dev` untuk generator (`riverpod_generator`,
  `drift_dev`, `freezed`, `json_serializable`, `build_runner`).
  Dipilih via `pub add` (bukan pin versi manual) supaya resolusi versi
  otomatis kompatibel — pelajaran dari insiden pin `very_good_analysis`
  di T-002.
- Verifikasi: `flutter analyze` tetap 6 issues (semua info, sama seperti
  T-002, di `lib/main.dart` template default) — tidak ada
  error/warning baru dari dependency baru.
- **Next:** T-004 (folder skeleton feature-first + `main.dart`
  placeholder).

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
