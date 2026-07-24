# MVP.md — Sangu

Sumber kebenaran untuk scope & roadmap. Prioritas: MoSCoW.

## Scope MoSCoW

### Must (tanpa ini bukan produk)
| Fitur | Manfaat |
|---|---|
| Catat transaksi manual (data lengkap: kategori, sub-kategori, deskripsi, merchant opsional) | Fondasi semua fitur |
| Penyimpanan lokal offline-first (Drift) | Data aman & instan tanpa internet |
| Taksonomi kategori + sub-kategori (seed, bisa ditambah) | Dasar auto-kategori & chart |
| Dashboard trust-first (saldo, insight, transaksi terakhir) | Jawab "duitku gimana" dalam 1 detik |
| **Input suara & natural language** ("isi pertalite 40rb" → form pre-filled) | Input tercepat, terasa pintar |
| **OCR foto struk** (Gemini vision → JSON → konfirmasi) | Pilar pembeda, kurangi friksi |
| **Share-sheet dari mana saja** (struk email/e-wallet → Sangu) | Nilai jual utama, tanpa server |
| **AI weekly insight + rapikan kategori** (Firebase AI Logic) | Centerpiece portfolio AI-native |
| Gamifikasi ringan (streak, 3-5 badge, progress ring budget) | Bentuk kebiasaan, app lengket |
| Budget bulanan sederhana (total) | Bikin progress & microinteraction bermakna |

### Should
- Budget per kategori.
- Chart analitik (pie per kategori, tren bulanan) — `fl_chart`.
- Export CSV.

### Could
- Deteksi clipboard (nominal disalin → quick-add).
- Widget home screen quick-add.
- Reminder notifikasi streak.
- Multi-dompet eksplisit.

### Won't (v1)
- Auto-scan email otomatis (butuh OAuth/verifikasi Google/server).
- Baca SMS/notifikasi bank (dibatasi Play Store).
- Leaderboard sosial / perbandingan publik.
- Sync antar-device, akun keluarga, tracking investasi, versi web/desktop.
- AI on-device (masa depan).

## Metode input (rekap)
Share-sheet (Must) · Foto struk (Must) · Suara + natural language (Must) · Deteksi clipboard (Could) · Widget (Could).

---

## Roadmap 6 minggu (solo, part-time malam/weekend)

> Estimasi longgar. Kalau mepet, geser Should/Could, jangan korbankan Must.

### Minggu 0 — Setup & Harness (fondasi)
- Init project Flutter, struktur folder feature-first.
- Pasang harness: `analysis_options.yaml`, `lefthook`, CI GitHub Actions, slash commands (lihat ARCHITECTURE.md).
- Setup Firebase project + App Check + `firebase_ai`.
- Pasang dependency inti (riverpod, drift, freezed, go_router, dio).
- **Verify:** `flutter analyze` bersih, CI hijau, panggilan Gemini "hello" berhasil.

### Minggu 1 — Data & transaksi manual
- Skema Drift (Transaction, Category, SubCategory) + seed taksonomi.
- Repository + Riverpod provider.
- Form input manual lengkap + list transaksi.
- **Verify:** bisa tambah/edit/hapus transaksi, data persist setelah restart.

### Minggu 2 — Dashboard & budget & gamifikasi dasar
- Home trust-first (saldo, transaksi terakhir).
- Budget bulanan + progress ring.
- Streak counter + badge dasar.
- **Verify:** saldo & progress akurat, streak naik saat catat harian.

### Minggu 3 — Input pintar (suara + natural language)
- Integrasi `speech_to_text` + parse Gemini → form pre-filled.
- Aturan kata kunci lokal untuk auto-kategori instan (fallback offline).
- **Verify:** ucapan "isi pertalite 40rb" mengisi form dengan benar.

### Minggu 4 — OCR & share-sheet
- Kamera + `google_mlkit_text_recognition` + Gemini vision → JSON.
- `receive_sharing_intent`: terima struk dari app lain → parse → form.
- Antrian AI offline (`pending_ai_jobs`).
- **Verify:** foto struk & share dari email menghasilkan transaksi benar.

### Minggu 5 — AI weekly insight
- Agregasi mingguan → Gemini (schema B) → kartu insight + rapikan kategori.
- Tampilkan insight di dashboard.
- **Verify:** insight muncul, kategori uncategorized ikut dirapikan.

### Minggu 6 — Polish, Should items, rilis
- Chart analitik + export CSV (bila sempat).
- Dark mode final, microinteraction, aksesibilitas (audit WCAG).
- Siapkan store listing / APK / TestFlight.
- **Verify:** audit aksesibilitas lolos, app stabil dipakai harian.

---

## Scope testing (realistis untuk MVP)
- **Unit test:** logika penting saja — perhitungan saldo/budget, mapper parse AI → model, aturan kategori lokal.
- **Widget test:** form transaksi (validasi input).
- **Tidak** kejar 100% coverage. Fokus ke jalur yang gampang salah & sering dipakai.
- CI menjalankan semua test sebagai gate.

Detail aturan testing: `.harness/rules/R300-testing-standards.md`.

---

# Backlog Task (T-###)

> `DECISIONS.md` = **apa** yang dibangun. `ARCHITECTURE.md` = **bagaimana**
> komponen menyatu. Bagian ini = **urutan, verifikasi, dan kriteria mana**
> yang dipenuhi. Living document: task baru di-*append*, ID tidak pernah
> dipakai ulang.

## Cara baca

**Konvensi ID task:** `T-###` counter global, stabil selamanya. Tidak
pernah dinomori ulang walau task dihapus/digeser.

**Shape task:**
```
### T-###: judul
- Deps: T-### (atau "none")
- Est: S | M | L   (S ≤ 1 jam, M ≤ 4 jam, L ≤ 1 hari; solo, fokus)
- Zona: doc | runtime   (runtime = advisor-only, R900.9)
- Files: file utama yang disentuh
- Rules: R### terkait
- AC: AC-F#.# yang dipenuhi (bila fitur)
- Verify: perintah persis + hasil yang diharapkan
```

**Shape fitur (`F#`):** User Story → Acceptance Criteria (`AC-F#.#`,
terukur) → daftar `T-###`.

**Status task:** `[ ]` belum · `[~]` in-progress · `[✓]` selesai ·
`[!]` blocked.

## Milestone overview

| M# | Minggu | Tema | Membuka |
|---|---|---|---|
| M0 | 0 | Setup & Harness | fondasi kerja |
| M1 | 1 | Data & transaksi manual (F1) | pencatatan inti |
| M2 | 2 | Dashboard, budget, gamifikasi (F2, F3) | "duitku gimana" 1 detik |
| M3 | 3 | Input pintar suara + NL (F4) | input tercepat |
| M4 | 4 | OCR & share-sheet (F5) | pilar pembeda |
| M5 | 5 | AI weekly insight (F6) | centerpiece AI |
| M6 | 6 | Polish, Should, rilis (F7) | siap dipakai/rilis |

---

## M0 — Setup & Harness

Fondasi. **Dirinci penuh.** Sebagian sudah/akan dieksekusi via
`docs/plans/week-0-setup-harness.md` (bootstrap Flutter) dan
`docs/plans/adopt-contractiq-harness.md` (harness governance).

### T-001: Adopsi `.harness/` + migrasi docs ke ADR/T-###
- Deps: none · Est: L · Zona: doc
- Files: `.harness/**`, `.sangu-project`, `CLAUDE.md`, `docs/DECISIONS.md`, `docs/MVP.md`, `docs/progress.md`
- Rules: R000, R900, ADR-016/017/018
- Verify: `ls .harness/rules` = 10 rule; `DECISIONS.md` format ADR; `CLAUDE.md` MANDATORY READS ada.

### T-002: `analysis_options.yaml` — very_good_analysis + exclude generated
- Deps: T-001 · Est: S · Zona: runtime
- Files: `analysis_options.yaml`
- Rules: R100.1, R100.14, ADR-014
- Verify: `flutter analyze` jalan; `*.g.dart`/`*.freezed.dart` ter-exclude.

### T-003: `pubspec.yaml` — dependency inti
- Deps: T-002 · Est: S · Zona: runtime
- Files: `pubspec.yaml`
- Rules: ADR-002..006
- Verify: `flutter pub get` sukses; riverpod, drift, freezed, go_router, dio, flutter_animate terpasang.

### T-004: Folder skeleton feature-first + `main.dart` placeholder
- Deps: T-003 · Est: S · Zona: runtime
- Files: `lib/main.dart`, `lib/core/**`, `lib/shared/**`, `lib/features/**`
- Rules: R100.13, ADR-001
- Verify: `flutter run` menampilkan placeholder; struktur sesuai `ARCHITECTURE.md`.

### T-005: `lefthook.yml` pre-commit gate
- Deps: T-004 · Est: S · Zona: runtime
- Files: `lefthook.yml`
- Rules: R100.1, R300.7, ADR-014
- Verify: `lefthook install`; commit dengan file belum-format ditolak.

### T-006: CI GitHub Actions
- Deps: T-005 · Est: S · Zona: runtime
- Files: `.github/workflows/ci.yml`
- Rules: R300.7, ADR-014
- Verify: push → CI hijau (pub get, build_runner, analyze, test).

### T-007: Push repo utama ke GitHub (private)
- Deps: T-006 · Est: S · Zona: runtime (aksi developer)
- Files: — (git remote)
- Rules: R200, R900.1
- Verify: repo private ada; CI hijau pada push pertama.

### T-008: learning_docs repo private terpisah
- Deps: T-001 · Est: M · Zona: doc + aksi git developer
- Files: `learning_docs/**`, `.gitignore` (tambah `learning_docs/`)
- Rules: ADR-018
- Verify: `cd learning_docs && git status` = repo sendiri; repo utama tak melacaknya.

### T-009: Setup Firebase + App Check + firebase_ai, tes "hello" Gemini
- Deps: T-003 · Est: M · Zona: runtime (setup eksternal)
- Files: `firebase_options.dart` (gitignore bila sensitif), `lib/core/ai/**`
- Rules: R400.1, R400.2, R500.7, ADR-007
- Verify: panggilan "hello" ke Gemini berhasil dengan App Check aktif.

---

## M1 — Data & transaksi manual

### F1 — Catat transaksi manual
**User Story:** Sebagai user, saya mencatat pemasukan/pengeluaran
lengkap (kategori, sub-kategori, deskripsi, merchant opsional) agar
punya fondasi data keuangan.

**Acceptance Criteria:**
- AC-F1.1: Bisa tambah transaksi dengan semua field wajib (amount `int`).
- AC-F1.2: Bisa edit & hapus transaksi.
- AC-F1.3: Data persist setelah restart app.
- AC-F1.4: Taksonomi kategori+subkategori ter-seed & bisa ditambah.
- AC-F1.5: Amount invalid (kosong/nol) ditolak dengan pesan validasi.

**Tasks (shape ringkas, dimatangkan saat M1 didekati):**
- [ ] **T-010** Skema Drift: Transaction, Category, SubCategory — Deps T-004 · M · AC-F1.1/1.4
- [ ] **T-011** Seed taksonomi kategori (dari `ARCHITECTURE.md`) — Deps T-010 · S · AC-F1.4
- [ ] **T-012** Repository transaksi (pintu tunggal ke Drift) — Deps T-010 · M · R100.11
- [ ] **T-013** Riverpod provider/Notifier transaksi — Deps T-012 · M · R100.11
- [ ] **T-014** Form input manual lengkap + validasi — Deps T-013 · L · AC-F1.1/1.5
- [ ] **T-015** List transaksi (Stream reaktif) — Deps T-013 · M · AC-F1.2/1.3
- [ ] **T-016** Unit test hitung saldo + widget test form — Deps T-014 · M · R300.2/3

---

## M2 — Dashboard, budget, gamifikasi

### F2 — Dashboard trust-first
**User Story:** Sebagai user, saya membuka app dan tahu kondisi uang
saya dalam 1 detik.

**Acceptance Criteria:**
- AC-F2.1: Saldo tampil sebagai hero (tabular figures) tanpa scroll.
- AC-F2.2: Transaksi terakhir tampil di home.
- AC-F2.3: Untung/rugi pakai dual-encoding (ikon+tanda+warna).

**Tasks:**
- [ ] **T-017** Layout home trust-first (hierarki R602.6) — Deps T-015 · L · AC-F2.1
- [ ] **T-018** Widget kartu saldo (tabular figures, dual-encoding) — Deps T-017 · M · R602.2/3
- [ ] **T-019** Seksi transaksi terakhir — Deps T-017 · S · AC-F2.2

### F3 — Budget & gamifikasi dasar
**User Story:** Sebagai user, saya menetapkan budget bulanan dan
termotivasi mencatat tiap hari.

**Acceptance Criteria:**
- AC-F3.1: Budget bulanan (total) bisa diatur; progress ring akurat.
- AC-F3.2: Streak naik saat mencatat di hari baru.
- AC-F3.3: 3–5 badge dasar bisa diperoleh.
- AC-F3.4: Budget terlewat memicu peringatan (warna+ikon+haptic beda).

**Tasks:**
- [ ] **T-020** Model + penyimpanan budget bulanan — Deps T-010 · S · AC-F3.1
- [ ] **T-021** Progress ring budget (spring) — Deps T-020 · M · R601.1, AC-F3.1/3.4
- [ ] **T-022** Streak counter (last_logged_date) — Deps T-012 · M · AC-F3.2
- [ ] **T-023** Badge dasar (3–5) — Deps T-022 · M · AC-F3.3
- [ ] **T-024** Microinteraction simpan/rayakan/peringatan — Deps T-021 · M · R601.4

---

## M3 — Input pintar (suara + natural language)

### F4 — Input suara & natural language
**User Story:** Sebagai user, saya mengucapkan "isi pertalite 40rb" dan
form terisi otomatis.

**Acceptance Criteria:**
- AC-F4.1: Ucapan → teks (`speech_to_text`).
- AC-F4.2: Teks → form pra-isi via Gemini (Schema A), kategori dari taksonomi.
- AC-F4.3: Aturan kata kunci lokal memberi kategori instan offline.
- AC-F4.4: Hasil ragu ditandai `needsReview`, user bisa koreksi sebelum simpan.

**Tasks:**
- [ ] **T-025** Integrasi `speech_to_text` — Deps T-014 · M · AC-F4.1
- [ ] **T-026** Schema A + prompt parse transaksi (`lib/core/ai/prompts`) — Deps T-009 · M · R500.1/3/10
- [ ] **T-027** Aturan kata kunci kategori lokal (fallback) — Deps T-011 · M · R500.9, AC-F4.3
- [ ] **T-028** Alur teks→Gemini→form pra-isi + review — Deps T-026 · L · AC-F4.2/4.4
- [ ] **T-029** Unit test mapper parse + parse-safety — Deps T-028 · M · R300.4

---

## M4 — OCR & share-sheet

### F5 — OCR foto struk & share-sheet
**User Story:** Sebagai user, saya memfoto struk atau men-share struk
dari app lain, lalu jadi transaksi otomatis.

**Acceptance Criteria:**
- AC-F5.1: Foto struk → teks on-device → Gemini vision → JSON → form pra-isi.
- AC-F5.2: Share dari email/e-wallet → parse → form pra-isi.
- AC-F5.3: Offline: transaksi tercatat, job AI masuk antrian `pending_ai_jobs`.

**Tasks:**
- [ ] **T-030** Kamera + `google_mlkit_text_recognition` on-device — Deps T-009 · M · R500.9
- [ ] **T-031** Gemini vision → JSON (Schema A multimodal) — Deps T-030 · M · R500.1
- [ ] **T-032** `receive_sharing_intent` ingestion — Deps T-009 · L · AC-F5.2
- [ ] **T-033** Tabel + worker antrian `pending_ai_jobs` — Deps T-010 · M · R500.6, AC-F5.3
- [ ] **T-034** Alur konfirmasi hasil OCR/share → simpan — Deps T-031 · M · R500.5

---

## M5 — AI weekly insight

### F6 — AI weekly insight + rapikan kategori
**User Story:** Sebagai user, saya melihat ringkasan mingguan + saran,
dan kategori yang belum rapi ikut dibenahi.

**Acceptance Criteria:**
- AC-F6.1: Agregasi mingguan → Gemini (Schema B) → kartu insight.
- AC-F6.2: Satu panggilan sekaligus merapikan kategori `uncategorized`.
- AC-F6.3: Hanya data minimal dikirim (agregat, bukan riwayat mentah).
- AC-F6.4: Gagal parse → state error, tidak crash.

**Tasks:**
- [ ] **T-035** Agregasi mingguan per kategori — Deps T-015 · M · R400.5
- [ ] **T-036** Schema B + prompt insight — Deps T-009 · M · R500.1/10/11
- [ ] **T-037** Kartu insight di dashboard — Deps T-036, T-017 · M · AC-F6.1
- [ ] **T-038** Terapkan `categoryCorrections` ke transaksi — Deps T-036 · M · AC-F6.2
- [ ] **T-039** Parse-safety test insight — Deps T-036 · S · R300.4, AC-F6.4

---

## M6 — Polish, Should items, rilis

### F7 — Polish & rilis
**User Story:** Sebagai user, saya memakai app yang stabil, aksesibel,
dan enak dipakai harian.

**Acceptance Criteria:**
- AC-F7.1: Audit aksesibilitas WCAG AA lolos menyeluruh (R602).
- AC-F7.2: Dark mode final teruji.
- AC-F7.3: App Check aktif di build rilis; tak ada secret ter-commit.
- AC-F7.4: (Should, bila sempat) chart analitik + export CSV.

**Tasks:**
- [ ] **T-040** Chart analitik (`fl_chart`) — Should — Deps T-035 · M
- [ ] **T-041** Export CSV — Should — Deps T-015 · S
- [ ] **T-042** Dark mode final + audit kontras — Deps T-018 · M · R602.1, AC-F7.2
- [ ] **T-043** Audit aksesibilitas menyeluruh (checklist pre-pr) — Deps semua UI · M · AC-F7.1
- [ ] **T-044** Siapkan store listing / APK / TestFlight — Deps T-043 · M · AC-F7.3

---

## Definition of Done (per fitur)

Sebuah fitur `F#` selesai bila: semua `AC-F#.#` terpenuhi & terverifikasi;
task terkait `[✓]`; `flutter analyze` bersih; test jalur kritis hijau
(R300); checklist `pre-pr.md` lolos; `progress.md` terupdate.

## Dependency graph (ringkas)

```
M0 (T-001..009)
  → M1 F1 (T-010..016)
    → M2 F2/F3 (T-017..024)
      → M3 F4 (T-025..029)   [butuh T-009 AI]
        → M4 F5 (T-030..034) [butuh T-009 AI]
          → M5 F6 (T-035..039)
            → M6 F7 (T-040..044)
```
