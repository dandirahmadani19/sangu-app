# Plan — Adopsi Harness Pola ContractIQ ke Sangu (Flutter, Model-Agnostic)

**Status:** Draft — menunggu approval untuk eksekusi.
**Disusun:** 2026-07-24 oleh Claude (Opus 4.8, effort: high).
**Referensi sumber:** `../contractiq/.harness/**`, `../contractiq/CLAUDE.md`, `../contractiq/DECISIONS.md`, `../contractiq/MVP.md`, `../contractiq/progress.md`, `../contractiq/learning_docs/README.md`.
**Referensi sangu:** `CLAUDE.md`, `docs/DECISIONS.md`, `docs/MVP.md`, `docs/ARCHITECTURE.md`, `docs/DESIGN.md`, `docs/progress.md`, `docs/plans/week-0-setup-harness.md`.

---

## 1. Tujuan

Menerapkan sistem harness engineering pola ContractIQ ke Sangu, **disesuaikan untuk Flutter**, dengan tiga karakter utama:

1. **Model-agnostic** — seluruh aturan & prompt ditulis netral ("the agent", bukan "Claude"). Semua fase (Plan/Execute/Verify) boleh pakai model apa pun (Claude, DeepSeek, Gemini, model lokal). Tidak ada aturan keras "fase X harus model Y".
2. **Advisor-only + doc auto-edit** — untuk **kode aplikasi** agent hanya mengusulkan diff (developer yang ketik & jalankan → sejalan tujuan belajar Flutter dari nol). Untuk **dokumentasi** (docs/, .harness/, learning_docs/, README, CLAUDE.md) agent boleh langsung edit tanpa propose.
3. **Right-sized** — semua kategori rule di-port, tapi dipangkas ke kebutuhan app Flutter offline-first personal (bukan SaaS multi-tenant).

## 2. Keputusan yang sudah dikonfirmasi user (2026-07-24)

| # | Keputusan | Konsekuensi |
|---|---|---|
| K-1 | **Full model-agnostic** | D-18/D-19 direvisi jadi rekomendasi (bukan aturan keras). Memory "Plan wajib Opus" diubah jadi rekomendasi. Harness netral model. |
| K-2 | **Advisor-only + doc-zone auto-edit** | Adopsi R900 gaya ContractIQ, diadaptasi ke zona Flutter. |
| K-3 | **Migrasi penuh ke ADR-###** | Semua D-## di `DECISIONS.md` dikonversi ke ADR lengkap. ADR jadi register tunggal. |
| K-4 | **Rules right-sized** | Port semua kategori, dipangkas ke app personal offline (R400 ringan, R300 realistis). |
| K-5 | **Tambah `learning_docs/`** | Repo terpisah & private untuk catatan belajar, pola ContractIQ. |

## 3. Prinsip adaptasi Flutter (pengganti asumsi web ContractIQ)

- **Bahasa:** TS/Node/Next.js → **Dart/Flutter**. Prisma/Postgres → **Drift/SQLite**. Tailwind/Radix → **Material 3 + M3E manual**. Provider abstraction Node → **Firebase AI Logic + Gemini client-side**.
- **Bahasa dokumen:** dokumen committed **tetap Bahasa Indonesia** (konvensi Sangu yang sudah ada; beda dari ContractIQ yang English). Komentar kode: English. Chat: Bahasa Indonesia. → lihat Keputusan kecil #A.
- **Keamanan:** tanpa multi-tenancy, RLS, auth server, session/CSRF. Fokus: App Check, tidak ada API key di client/repo, data finansial lokal, minimalkan data ke Gemini, prompt-injection dasar untuk konten struk/share yang untrusted.
- **Testing:** bukan full pyramid. Sesuai `MVP.md` — unit untuk logika kritis (saldo/budget, mapper parse AI, aturan kategori lokal), widget test untuk form transaksi, parse-safety test untuk output Gemini.

## 4. Peta perubahan (before → after)

| Area | Sekarang | Setelah plan |
|---|---|---|
| Folder `.harness/` | ❌ tidak ada | ✅ README + rules + prompts + checklists + examples |
| Rules R### | ❌ | ✅ R000, R100, R200, R300, R400, R500, R600–R602, R900 (Flutter, right-sized) |
| Advisor-only | ⚠️ de facto (CLAUDE.md #1) | ✅ formal R900 + doc-zone auto-edit |
| Model strategy | Claude/DeepSeek terkunci | ✅ full model-agnostic (rekomendasi opsional) |
| `CLAUDE.md` | Claude-centric | ✅ netral + MANDATORY READS + UNDERSTAND→PLAN→PROPOSE→WAIT |
| `DECISIONS.md` | tabel D-01..19 | ✅ ADR-001.. penuh + index + superseded |
| `docs/MVP.md` | roadmap naratif | ✅ + backlog T-### + milestone M0–M6 + F#/AC-F#.# |
| `docs/progress.md` | tabel riwayat | ✅ Current Phase → Current Task → Session Log |
| `docs/ARCHITECTURE.md` | ADR-01..06 gaya ringan | ✅ direkonsiliasi → rujuk ADR-### di DECISIONS |
| `learning_docs/` | ❌ | ✅ repo private terpisah + struktur folder |
| `.sangu-project` | ❌ | ✅ file penanda |
| Slash commands | 5 command | ✅ diselaraskan dgn harness (cite R###, re-prime) |
| `scripts/use_*.sh` | Claude/DeepSeek | ✅ jadi profil opsional multi-model |

---

## 5. Fase eksekusi

> Semua file di bawah ada di **zona dokumentasi** (R900.8) → agent boleh buat/edit langsung **setelah plan ini di-approve**. File konstitusional (CLAUDE.md, DECISIONS.md, .harness/rules/**, MVP.md) diperlakukan ekstra hati-hati: perubahan besar tetap saya tunjukkan ringkasannya per fase sebelum lanjut.

### Fase 0 — Kerangka & penanda (S)
**Deliverable:**
- `.harness/` + subfolder `rules/`, `prompts/`, `checklists/`, `examples/`
- `.harness/README.md` (adaptasi: Flutter, tabel penomoran rule, klaim model-agnostic, advisor-only)
- `.sangu-project` (penanda: name, version, main_repo, learning_repo, created)

**Verify:** `ls -R .harness` menampilkan struktur; `cat .sangu-project` benar.

### Fase 1 — Rules inti model-agnostic (M)
**Deliverable — `.harness/rules/`:**

| Rule | Isi (right-sized Flutter) |
|---|---|
| **R000 — Meta** | Baca rule di awal task; cite R### di proposal; ambiguitas → tanya; kategori tinggi menang; perubahan rule butuh ADR; wording model-agnostic (MUST/MUST NOT + contoh). |
| **R900 — Advisor-Only Mode** | Prioritas tertinggi. Forbidden/allowed actions untuk **kode**; **doc-zone whitelist** (docs/**, .harness/**/*.md, learning_docs/**, README.md, CLAUDE.md, `apps`→N/A); **runtime zone** Flutter (lib/**, test/**, pubspec.yaml, analysis_options.yaml, lefthook.yml, .github/**, android/**, ios/**, *.dart, *.g.dart, *.freezed.dart); constitutional edits (DECISIONS.md, .harness/rules/**, CLAUDE.md, MVP.md) → propose dulu bila non-trivial; format proposal; wait-after-propose; emergency halt. |

**Verify:** dua file ada, penomoran & referensi zona konsisten dengan struktur folder Sangu di `ARCHITECTURE.md`.

### Fase 2 — Rules teknis Flutter (L)
**Deliverable — `.harness/rules/`:**

| Rule | Cakupan Sangu |
|---|---|
| **R100 — Coding standards (Dart/Flutter)** | very_good_analysis nol-warning sebelum commit; `snake_case` file / `PascalCase` class / `camelCase` var; **uang = `int` Rupiah, bukan `double`**; tidak ada teks tampilan hardcode (siap i18n, satu tempat); immutability via freezed; disiplin async/Future; error handling (jangan telan exception, model error eksplisit); import order; larang `print` (pakai logger); null-safety; konvensi Riverpod (`@riverpod` generator, Notifier tidak sentuh Drift langsung — via Repository) & Drift (query balik `Stream`). Arsitektur ringan (tanpa CQRS/event sourcing). |
| **R200 — Commit & git** | Conventional Commits; **type whitelist**: feat/fix/docs/refactor/test/chore/perf/build/ci; **scope whitelist**: transactions, dashboard, receipts, insights, gamification, db, ai, theme, core, shared, harness, deps; subject rules; body/footer; atomic commits; branch naming; commit signing (opsional, SHOULD). |
| **R300 — Testing (realistis MVP)** | Fokus jalur kritis, **bukan** 100% coverage; unit: perhitungan saldo/budget, mapper parse AI→model, aturan kata kunci kategori lokal; widget test: validasi form transaksi; **parse-safety test**: output Gemini gagal parse → state error, tidak crash; test naming & lokasi (`test/` mirror `lib/`); CI menjalankan `flutter test` sebagai gate. Tanpa tenant-isolation/E2E berat. |

**Verify:** setiap rule punya sub-nomor (R100.1 dst) + contoh Correct/Violation; bisa dicite dari task.

### Fase 3 — Rules security, AI, design (L)
**Deliverable — `.harness/rules/`:**

| Rule | Cakupan Sangu |
|---|---|
| **R400 — Security baseline (ringan, client app)** | Tidak ada API key/secret di client atau repo (`.env`, `google-services.json`, `firebase_options.dart` di `.gitignore`/aturan commit); **App Check** wajib aktif sebelum panggil Gemini; validasi konten untrusted (teks struk/share) sebelum dipakai; **prompt-injection dasar** (konten struk tidak boleh mengubah instruksi sistem); data finansial **lokal-only**, minimalkan field yang dikirim ke Gemini (lihat Schema B privasi); enkripsi DB opsional (sqlcipher); dependency policy; fail-closed saat parse gagal. **Tanpa** multi-tenant/RLS/auth-server/session/CSRF. |
| **R500 — AI integration (Firebase AI Logic + Gemini)** | `responseSchema` wajib → output selalu JSON valid; prompt versioning & lokasi (`lib/core/ai/prompts/`); kategori/subKategori **dibatasi taksonomi** (ragu → "Lainnya" + `needsReview:true`); confidence + `needsReview` handling; schema-repair/fallback (gagal parse → error state, tidak crash); **antrian offline** (`pending_ai_jobs`) saat tak ada internet; nama model Gemini di **Remote Config** (bukan hardcode); kesadaran free-tier/kuota; multimodal (vision struk); aturan agar prompt tetap jalan di model kecil. |
| **R600 — Design tokens** | Lokasi token: `lib/core/theme/`; **`ColorScheme.fromSeed`**, tidak ada warna hardcode di widget; token warna/spacing/radius/elevation/motion; dark mode via ColorScheme (abu hangat, bukan hitam murni); shape squircle/organik konsisten via theme. |
| **R601 — Motion & haptics** | Semua motion **spring (fisika)**, bukan durasi tetap; `flutter_animate` + `HapticFeedback`; token motion konsisten seluruh app; microinteraction fungsional (bukan hiasan) per `DESIGN.md`. |
| **R602 — Accessibility & anti-generic look** | Kontras **WCAG AA** (4.5:1); **dual-encoding** untung/rugi = ikon (↑/↓) + tanda (+/−) + warna (jangan warna saja); **tabular figures** untuk uang; target sentuh ≥48dp; dukung teks besar; hierarki trust-first (info penting tanpa scroll). |

**Verify:** rule design merujuk `DESIGN.md`; rule AI merujuk Schema A/B di `ARCHITECTURE.md`.

### Fase 4 — Prompt templates & checklists (M)
**Deliverable — `.harness/prompts/`:**
- `_preamble.md` — re-prime tiap task (identity advisor-only, konfirmasi rule terbaca, restate task, scope declaration, format proposal, risks/rollback, stop conditions, bahasa output). Adaptasi: doc-zone auto-edit + Flutter.
- `plan-feature.md` — ubah deskripsi fitur → daftar task T-###.
- `implement-feature.md` — usulkan diff untuk task ter-scope (format proposal + verify command Flutter).
- `review-diff.md` — review diff terhadap R### (cite pelanggaran).
- `debug-error.md` — alur debug terstruktur (Flutter/Dart: analyze, build_runner, stack trace).
- `design-ai-schema.md` — desain `responseSchema` Gemini + prompt (gabungan design-tool + design-prompt ContractIQ, versi Firebase AI).

**Deliverable — `.harness/checklists/`:**
- `pre-commit.md` — `dart format` + `flutter analyze` (nol warning) + `flutter test` hijau.
- `pre-pr.md` — di atas + audit aksesibilitas WCAG AA (gate dari `DESIGN.md`) + build_runner bersih + progress.md terupdate.
- `release.md` — checklist rilis APK/TestFlight (Minggu 6).

**Deliverable — `.harness/examples/`:** seed 1–2 contoh good/bad (mis. dual-encoding benar vs warna-saja; `int` Rupiah vs `double`). Boleh menyusul.

**Verify:** `_preamble.md` bisa dibaca ulang & konsisten dengan R900.

### Fase 5 — Migrasi DECISIONS → ADR-### (L)
**Deliverable — `docs/DECISIONS.md` ditulis ulang:**
- Format ADR penuh per keputusan: **Context → Options considered → Decision → Rationale → Consequences (dua arah) → Change control**.
- Index tabel (ID, Title, Status).
- Migrasi & rekonsiliasi penomoran (usulan — lihat Keputusan kecil #B):

| Baru | Dari | Judul |
|---|---|---|
| ADR-001 | D-01 / ARCH ADR-05 | Framework Flutter + struktur feature-first |
| ADR-002 | D-02 / ARCH ADR-01 | State management Riverpod |
| ADR-003 | D-03 / ARCH ADR-02 | Local DB Drift |
| ADR-004 | D-04 | Model freezed + json_serializable |
| ADR-005 | D-05 | Routing go_router |
| ADR-006 | D-06 | Networking dio |
| ADR-007 | D-07 / ARCH ADR-03 | AI transport Firebase AI Logic + Gemini |
| ADR-008 | D-08 / ARCH ADR-04 | OCR ML Kit + Gemini vision |
| ADR-009 | D-09 / ARCH ADR-06 | Input via OS Share Sheet |
| ADR-010 | D-11 | UI Material 3 + M3E manual, warm-earthy-editorial |
| ADR-011 | D-13 | Gamifikasi ringan (streak/badge/budget, non-sosial) |
| ADR-012 | D-14 | Uang = int Rupiah |
| ADR-013 | D-15 | Data model transaksi lengkap |
| ADR-014 | D-16 | Harness: very_good_analysis + lefthook + CI + slash commands |
| ADR-015 | D-17 → **direvisi** | Advisor-only mode (agent usulkan, human eksekusi) |
| **ADR-016** | **BARU (K-1)** | **Model-agnostic strategy** — *supersedes* D-18/D-19 |
| **ADR-017** | **BARU (K-2)** | **Adopsi `.harness/` + doc-zone auto-edit (R900)** |
| **ADR-018** | **BARU (K-5)** | **learning_docs sebagai repo private terpisah** |
- Section **Superseded**: D-18 (dual-model terkunci) & D-19 (Claude-first planning) → digantikan ADR-016; backend NestJS → ADR-007 (sudah ada).
- D-10, D-12 diserap ke ADR terkait (struktur → ADR-001; nama cosmetic → catatan).

**Verify:** semua D-## lama punya rumah di ADR baru; tidak ada keputusan hilang; index lengkap.

### Fase 6 — CLAUDE.md netral + slash commands + scripts (M)
**Deliverable:**
- **`CLAUDE.md`** ditulis ulang (tetap ringkas, Bahasa Indonesia):
  - Identitas project + apa itu Sangu (dipertahankan).
  - **MANDATORY READS** berurutan: R900 → R000 → `_preamble.md` → DECISIONS.md.
  - **Role: ADVISOR-ONLY** (netral, "agent", bukan "Claude").
  - Workflow **UNDERSTAND → PLAN → PROPOSE → WAIT**.
  - STOP conditions.
  - **Model policy: agnostic** — Plan/Execute/Verify boleh model apa pun; rekomendasi (bukan aturan): model kuat untuk Plan/Verify, model murah untuk Execute. Hapus penguncian Claude/DeepSeek.
  - Tech stack, navigasi repo, standar kode, command harian (dipertahankan, dirujuk ke R###).
- **`.claude/commands/*`** diselaraskan: setiap command re-prime `_preamble.md`, cite R### relevan, hormati advisor-only. Tambah `review-diff.md` (opsional).
- **`scripts/use_*.sh`** → jadi profil opsional multi-model (mis. `use_claude.sh`, `use_deepseek.sh`, contoh `use_gemini.sh`), diframe sebagai kenyamanan, bukan keharusan.

**Verify:** MANDATORY READS menunjuk file yang benar-benar ada; tidak ada string "Claude wajib" yang menyalahi K-1.

### Fase 7 — Backlog task T-### di MVP.md (L)
**Deliverable — `docs/MVP.md` ditambah:**
- Konvensi: **T-### counter global, stabil selamanya**; task shape `Deps · Est(S/M/L) · Files · Rules · AC · Verify`.
- Milestone map dari roadmap 6 minggu:
  - **M0 — Setup & Harness** (Minggu 0) → termasuk memetakan `week-0-setup-harness.md` jadi T-###.
  - **M1 — Data & transaksi manual** (Minggu 1)
  - **M2 — Dashboard, budget, gamifikasi dasar** (Minggu 2)
  - **M3 — Input pintar suara + NL** (Minggu 3)
  - **M4 — OCR & share-sheet** (Minggu 4)
  - **M5 — AI weekly insight** (Minggu 5)
  - **M6 — Polish, Should items, rilis** (Minggu 6)
- Fitur `F1..F#` + `AC-F#.#` (acceptance criteria terukur) untuk fitur Must.
- **Enumerasi task:** M0 dirinci **penuh** sekarang (termasuk task adopsi harness ini + bootstrap Flutter). M1–M6 diisi daftar T-### (judul + Deps + Est + AC) dengan shape lengkap dimatangkan saat milestone-nya didekati (pola living document ContractIQ). → lihat Keputusan kecil #C.
- Section Dependency graph + Definition of Done per fitur.

**Verify:** setiap AC punya minimal satu T-###; setiap T-### punya Verify command; MoSCoW lama tetap ada.

### Fase 8 — progress.md format ContractIQ (S)
**Deliverable — `docs/progress.md` ditulis ulang (Bahasa Indonesia):**
- **Current Phase** → **Current Task** (T-### + Deps + Est + link spec) → **Session Log** (terbaru di atas, per tanggal, ✓/~/! penanda) → cara update & cara baca.
- Migrasi isi riwayat lama ke Session Log.

**Verify:** `/session-start` & `/session-end` masih cocok dengan format baru.

### Fase 9 — learning_docs/ repo private terpisah (M)
**Deliverable:**
- Folder `learning_docs/` dengan struktur ContractIQ: `00-foundations/`, `01-architecture-decisions/`, `02-terminology-in-order/`, `03-harnessing-ai-agentic/`, `04-deep-dives/`, `05-session-logs/`, `measurements/`, `README.md`.
- Seed minimal: `README.md` (konvensi menulis + rujukan ADR-###/R###/T-###) + `00-foundations/01-what-is-ai-native.md` + `03-harnessing-ai-agentic/01-what-is-harness-engineering.md`.
- **Repo terpisah:** `git init` di dalam `learning_docs/`, tambahkan `learning_docs/` ke `.gitignore` repo utama (agar bukan bagian repo publik/utama).
- Buat repo GitHub **private** `sangu-learning-docs` + push. → **aksi jaringan/git = advisor-only**, saya beri perintahnya, developer yang jalankan.
- (Opsional) helper `scripts/sangu-push.sh` meniru `ciq-push` (push repo utama + learning_docs sekaligus).

**Verify:** `cd learning_docs && git status` = repo sendiri; repo utama tidak melacak isinya.

### Fase 10 — Sinkronisasi memory & housekeeping (S)
**Deliverable:**
- Update memory `feedback_plan_must_use_opus` → jadi rekomendasi (bukan aturan keras), karena K-1. Tambah memory `project` untuk keputusan model-agnostic + adopsi harness.
- Update `MEMORY.md` index.
- Update `docs/plans/week-0-setup-harness.md`: tandai bahwa ia kini bagian M0 dan dipetakan ke T-###.

**Verify:** memory konsisten dengan ADR-016; tidak ada instruksi lama yang menyalahi K-1.

---

## 6. Keputusan kecil yang saya asumsikan (koreksi bila salah)

- **#A — Bahasa dokumen committed:** saya **pertahankan Bahasa Indonesia** untuk semua dokumen Sangu (konvensi eksisting), beda dari ContractIQ (English). Komentar kode tetap English. → *Kalau kamu mau English demi "portfolio-grade", bilang.*
- **#B — Penomoran ADR:** saya usulkan **satu register ADR di `DECISIONS.md`** (ADR-001..), dan `ARCHITECTURE.md` yang tadinya punya ADR-01..06 **berhenti menomori sendiri** — cukup merujuk ADR-### di DECISIONS. → *Kalau kamu mau ARCHITECTURE tetap punya nomor sendiri, bilang.*
- **#C — Kedalaman backlog:** M0 dirinci penuh sekarang; M1–M6 daftar judul + shape ringkas, dimatangkan saat didekati (living document). → *Kalau kamu mau SEMUA T-### M0–M6 dirinci penuh sekarang juga, bilang — itu fase besar tersendiri.*
- **#D — Split R600 design:** saya pilih 3 file (R600 tokens, R601 motion/haptics, R602 a11y) alih-alih 6 file seperti ContractIQ (R600–R605), supaya right-sized. → *Kalau mau granular seperti ContractIQ, bilang.*

## 7. Urutan eksekusi aman + gate

```
Fase 0 (kerangka)
  → Fase 1 (R000 + R900)         [GATE A: fondasi advisor-only aktif]
    → Fase 2 (R100/R200/R300)
    → Fase 3 (R400/R500/R600-602) [GATE B: rules lengkap]
      → Fase 4 (prompts + checklists)
        → Fase 5 (DECISIONS→ADR)   [GATE C: constitutional — tunjukkan ringkasan]
          → Fase 6 (CLAUDE.md + commands + scripts) [constitutional]
            → Fase 7 (MVP T-###)   [constitutional]
              → Fase 8 (progress.md)
                → Fase 9 (learning_docs) [aksi git/jaringan = advisor-only, dev jalankan]
                  → Fase 10 (memory + housekeeping)
```

- **GATE A/B:** setelah rules dibuat, saya berhenti & minta kamu baca sekilas sebelum lanjut.
- **GATE C:** Fase 5–7 menyentuh file konstitusional → saya tunjukkan ringkasan perubahan sebelum apply (R900.10).
- **Fase 9:** semua perintah `git init`, buat repo GitHub, push = **kamu yang jalankan** (advisor-only), saya beri langkah persisnya.

## 8. Definition of Done

1. `.harness/` lengkap: README + 8–9 rule + prompts + checklists + examples seed.
2. Semua rule model-agnostic (nol string "Claude wajib") & Flutter-specific.
3. `DECISIONS.md` = ADR-### penuh; semua D-## lama terpetakan; D-18/D-19 tercatat superseded.
4. `CLAUDE.md` netral + MANDATORY READS + advisor-only + workflow.
5. `MVP.md` punya backlog T-### (M0 penuh) + F#/AC-F#.#.
6. `progress.md` format baru.
7. `learning_docs/` = repo private terpisah, ter-gitignore dari repo utama.
8. Memory & `week-0-setup-harness.md` sinkron dengan K-1.
9. `flutter analyze` tetap bersih (tidak ada file kode yang disentuh di plan ini — murni doc-zone).

## 9. Yang **tidak** dikerjakan di plan ini

- Menulis/menjalankan kode aplikasi Flutter (itu M0+ via `week-0-setup-harness.md`).
- Setup Firebase/App Check (bagian M0, sesi terpisah).
- Membuat remote GitHub (kamu yang jalankan di Fase 9).

---

## Catatan revisi
- 2026-07-24: draft awal, setelah 4 konfirmasi user (K-1..K-5).
- 2026-07-24: Keputusan kecil dikonfirmasi (#A Indonesia, #B setuju,
  #C setuju, #D setuju). Fase 0–10 (bagian zona dokumentasi)
  dieksekusi. Sisa = proposal zona runtime (advisor-only):
  `.gitignore` + git setup `learning_docs`, opsional scripts &
  slash-commands. Status T-001 di `MVP.md`/`progress.md` = in-progress
  sampai sisa runtime tuntas.
