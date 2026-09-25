# DECISIONS.md — Sangu (Architecture Decision Records)

File ini mencatat **keputusan terkunci** Sangu dalam format ADR. Tiap
keputusan bersifat mengikat (Ratchet Principle). Untuk mengubahnya,
tambah ADR baru yang men-*supersede* yang lama — **jangan** edit ADR
lampau diam-diam (R000.5).

**Format tiap ADR:** Context → Options considered → Decision →
Rationale → Consequences (dua arah) → Change control. Cite ADR dengan
ID-nya (`ADR-###`) di komentar kode, pesan commit, dan file rule.

> Catatan migrasi (2026-07-24): file ini sebelumnya berupa tabel
> `D-01..D-19`. Semua dikonversi ke ADR penuh. `docs/ARCHITECTURE.md`
> tidak lagi menomori ADR sendiri — ia merujuk ADR di sini (ADR-017).

---

## Index

| ID       | Judul                                                    | Status   |
| -------- | -------------------------------------------------------- | -------- |
| ADR-001  | Framework Flutter + struktur feature-first               | Accepted |
| ADR-002  | State management: Riverpod                                | Accepted |
| ADR-003  | Local DB: Drift (SQLite)                                  | Accepted |
| ADR-004  | Model: freezed + json_serializable                       | Accepted |
| ADR-005  | Routing: go_router                                       | Accepted |
| ADR-006  | Networking: dio                                          | Accepted |
| ADR-007  | AI transport: Firebase AI Logic + Gemini (client-side)   | Accepted |
| ADR-008  | OCR: ML Kit on-device + Gemini vision                    | Accepted |
| ADR-009  | Input dari mana saja: OS Share Sheet                     | Accepted |
| ADR-010  | UI: Material 3 + M3E manual, warm-earthy-editorial       | Accepted |
| ADR-011  | Gamifikasi ringan (streak/badge/budget, non-sosial)      | Accepted |
| ADR-012  | Uang disimpan sebagai `int` Rupiah                       | Accepted |
| ADR-013  | Data model transaksi lengkap                             | Accepted |
| ADR-014  | Harness: very_good_analysis + lefthook + CI + commands   | Accepted |
| ADR-015  | Advisor-Only mode (agent usulkan, human eksekusi kode)   | Accepted |
| ADR-016  | Strategi model: agnostik                                 | Accepted |
| ADR-017  | Adopsi `.harness/` + doc-zone auto-edit (R900)           | Accepted |
| ADR-018  | learning_docs sebagai repo private terpisah              | Accepted |
| ADR-019  | Repo utama GitHub: public                                | Accepted |

**Superseded:** D-18, D-19 (dual-model Claude/DeepSeek terkunci) →
ADR-016. Backend proxy NestJS → ADR-007.

---

## ADR-001 — Framework Flutter + struktur feature-first
**Status:** Accepted · 2026-07-04 (migrasi dari D-01, D-10)

- **Context.** Butuh framework lintas-platform untuk app keuangan
  personal, sekaligus media belajar dari nol.
- **Options considered.** Flutter; React Native; native Android/iOS
  terpisah; Clean Architecture 3-layer penuh vs layering tipis.
- **Decision.** Flutter dengan struktur **feature-first + layering
  tipis** (`presentation/` + `data/` per fitur), bukan Clean
  Architecture penuh.
- **Rationale.** Satu codebase, hot reload, ekosistem matang. Layering
  tipis cukup simpel diingat solo dev & mudah dinavigasi AI.
- **Consequences.** (+) Cepat, konsisten. (−) Butuh disiplin agar
  fitur tetap mandiri (diatur R100.11–.13).
- **Change control.** ADR baru bila pindah framework.

## ADR-002 — State management: Riverpod
**Status:** Accepted · 2026-07-04 (migrasi D-02)

- **Context.** Butuh state management compile-safe & testable.
- **Options considered.** Riverpod (+riverpod_generator); Provider;
  Bloc; GetX.
- **Decision.** Riverpod + `riverpod_generator`.
- **Rationale.** Compile-safe, testable, mental model mirip
  hooks/context React. Generator mengurangi boilerplate.
- **Consequences.** (+) Maintainable, portfolio-friendly. (−) Kurva
  belajar > Provider, butuh `build_runner`.
- **Change control.** ADR baru bila ganti solusi state.

## ADR-003 — Local DB: Drift (SQLite)
**Status:** Accepted · 2026-07-04 (migrasi D-03)

- **Context.** Offline-first, butuh DB lokal type-safe & reaktif.
- **Options considered.** Drift; Isar/Hive (praktis tak dirawat 2026);
  sqflite (SQL mentah); ObjectBox (sebagian komersial).
- **Decision.** Drift.
- **Rationale.** SQLite type-safe, query reaktif (Stream auto-update
  UI), migrasi bisa dites, cocok latar PostgreSQL. Dirawat aktif.
- **Consequences.** (+) Type-safety menutup satu kelas bug runtime.
  (−) Butuh codegen `build_runner`.
- **Change control.** ADR baru bila ganti DB.

## ADR-004 — Model: freezed + json_serializable
**Status:** Accepted · 2026-07-04 (migrasi D-04)

- **Context.** Butuh model immutable + serialisasi JSON aman (parse AI).
- **Options considered.** freezed + json_serializable; manual data
  class; built_value.
- **Decision.** freezed + json_serializable.
- **Rationale.** Immutability, `copyWith`, union types (mis. `Result`
  success/failure), serialisasi otomatis. Sinkron dengan R100.5.
- **Consequences.** (+) Aman & ringkas. (−) Codegen tambahan.
- **Change control.** ADR baru bila ganti pendekatan model.

## ADR-005 — Routing: go_router
**Status:** Accepted · 2026-07-04 (migrasi D-05)

- **Context.** Butuh routing deklaratif yang mendukung deep link
  (share-sheet).
- **Options considered.** go_router; Navigator 1.0; auto_route.
- **Decision.** go_router.
- **Rationale.** Deklaratif, dukungan resmi Flutter, cocok untuk
  deep-link dari share intent.
- **Consequences.** (+) Standar & terdokumentasi. (−) —
- **Change control.** ADR baru bila ganti router.

## ADR-006 — Networking: dio
**Status:** Accepted · 2026-07-04 (migrasi D-06)

- **Context.** Butuh HTTP client (mis. unduh konten share, util).
- **Options considered.** dio; http; chopper.
- **Decision.** dio.
- **Rationale.** Interceptor, timeout, error handling matang.
- **Consequences.** (+) Fleksibel. (−) Lebih berat dari `http` (dapat
  diterima).
- **Change control.** ADR baru bila ganti client.

## ADR-007 — AI transport: Firebase AI Logic + Gemini (client-side)
**Status:** Accepted · 2026-07-04 (migrasi D-07; supersede backend NestJS)

- **Context.** Butuh AI (parse, insight, vision) **tanpa server yang
  disewa/deploy**, kunci API aman.
- **Options considered.** Firebase AI Logic + Gemini; backend proxy
  NestJS (butuh sewa server); API key Gemini langsung di client (tidak
  aman); murni on-device (structured output lemah).
- **Decision.** Firebase AI Logic memanggil Gemini dari client, dengan
  **App Check**.
- **Rationale.** Tanpa server, ada free tier, App Check melindungi
  endpoint, mendukung function calling/structured output + multimodal.
- **Consequences.** (+) Rilis murah, tanpa ops server. (−) Inference di
  cloud Google (bukan on-device), butuh setup Firebase + App Check
  sekali. Nama model disimpan di Remote Config (R500.7).
- **Change control.** ADR baru bila pindah transport AI. Masa depan
  on-device (Gemini Nano/flutter_gemma) di luar scope v1.

## ADR-008 — OCR: ML Kit on-device + Gemini vision
**Status:** Accepted · 2026-07-04 (migrasi D-08)

- **Context.** Butuh baca struk Indonesia (Indomaret/Alfamart, Rupiah).
- **Options considered.** ML Kit text recognition + Gemini vision;
  `receipt_recognition` (ditune pasar Eropa/EUR).
- **Decision.** `google_mlkit_text_recognition` (teks on-device,
  gratis/offline) → bila online, Gemini vision untuk parse terstruktur.
- **Rationale.** On-device gratis & jadi fallback offline; Gemini jauh
  lebih akurat untuk struk lokal.
- **Consequences.** (+) Hemat & akurat. (−) Dua jalur (diatur R500.9).
- **Change control.** ADR baru bila ganti OCR.

## ADR-009 — Input dari mana saja: OS Share Sheet
**Status:** Accepted · 2026-07-04 (migrasi D-09)

- **Context.** Ingin terima struk dari email/e-wallet tanpa server.
- **Options considered.** `receive_sharing_intent` (share-sheet);
  auto-scan Gmail via OAuth (butuh verifikasi Google + server); baca
  SMS/notifikasi (dibatasi Play Store).
- **Decision.** OS Share Sheet via `receive_sharing_intent`.
- **Rationale.** ~90% nilai tanpa server; user share gambar/PDF/teks
  ke Sangu lalu diparse Gemini.
- **Consequences.** (+) Tanpa OAuth/server. (−) Butuh aksi share manual
  user (dapat diterima). Auto-scan email = Won't v1.
- **Change control.** ADR baru bila menambah jalur ingestion.

## ADR-010 — UI: Material 3 + M3E manual, warm-earthy-editorial
**Status:** Accepted · 2026-07-04 (migrasi D-11)

- **Context.** Ingin identitas visual hangat & dewasa, bukan biru
  fintech dingin/generik.
- **Options considered.** Material 3 murni; M3 + M3E manual;
  design-system pihak ketiga.
- **Decision.** Material 3 fondasi + **Material 3 Expressive
  diimplement manual** (spring, shape organik, tipografi editorial,
  haptics). Nuansa warm-earthy-editorial.
- **Rationale.** M3 stabil & default Flutter; M3E belum native → dibuat
  manual. Diatur R600–R602.
- **Consequences.** (+) Khas & aksesibel. (−) Lebih banyak kerja UI
  manual.
- **Change control.** ADR baru bila ganti arah desain.

## ADR-011 — Gamifikasi ringan (non-sosial)
**Status:** Accepted · 2026-07-04 (migrasi D-13)

- **Context.** Ingin app lengket & membentuk kebiasaan.
- **Options considered.** Streak+badge+progress budget; leaderboard
  sosial/perbandingan publik.
- **Decision.** Gamifikasi ringan: streak, 3–5 badge, progress ring
  budget. **Bukan** leaderboard/sosial.
- **Rationale.** Motivasi tanpa tekanan sosial/privasi; sesuai
  slow-living.
- **Consequences.** (+) Sederhana, privat. (−) Tanpa efek viral sosial.
- **Change control.** ADR baru bila menambah elemen sosial.

## ADR-012 — Uang disimpan sebagai `int` Rupiah
**Status:** Accepted · 2026-07-04 (migrasi D-14)

- **Context.** Uang rawan galat floating-point.
- **Options considered.** `int` Rupiah; `double`; Decimal package.
- **Decision.** `int` Rupiah (tanpa desimal). Diatur R100.3.
- **Rationale.** Rupiah praktis tanpa sen; `int` bebas galat & ringan.
- **Consequences.** (+) Akurat. (−) Format tampilan dilakukan di UI.
- **Change control.** ADR baru bila butuh mata uang bersen.

## ADR-013 — Data model transaksi lengkap
**Status:** Accepted · 2026-07-04 (migrasi D-15)

- **Context.** Butuh model transaksi yang mendukung semua metode input
  & fitur AI.
- **Decision.** Field: type, amount, category, subCategory, description,
  merchant (opsional), note (opsional), occurredAt, source,
  aiConfidence (opsional), needsReview, accountId (opsional),
  createdAt/updatedAt. Detail di `ARCHITECTURE.md`.
- **Rationale.** Menopang auto-kategori, OCR, share, insight, review.
- **Consequences.** (+) Fleksibel. (−) Form lebih kaya (diimbangi
  input pintar).
- **Change control.** Perubahan skema butuh migrasi Drift + `BREAKING
  CHANGE` (R200.7).

## ADR-014 — Harness: very_good_analysis + lefthook + CI + slash commands
**Status:** Accepted · 2026-07-04 (migrasi D-16)

- **Context.** Butuh gate kualitas otomatis solo dev.
- **Decision.** `very_good_analysis` (lint), `lefthook` (pre-commit),
  GitHub Actions CI, slash commands `.claude/commands/`.
- **Rationale.** Nol-warning terjaga, Ratchet Principle di CI. Diatur
  R100.1, R300.7.
- **Consequences.** (+) Kualitas konsisten. (−) Setup awal.
- **Change control.** Bagian ini diperluas oleh ADR-017 (`.harness/`).

## ADR-015 — Advisor-Only mode (agent usulkan, human eksekusi kode)
**Status:** Accepted · 2026-07-04, direvisi 2026-07-24 (migrasi D-17)

- **Context.** Developer belajar Flutter dari nol; ingin memahami tiap
  baris dengan mengetik & menjalankan sendiri.
- **Options considered.** Agent eksekusi kode langsung; advisor-only
  (agent usulkan, human eksekusi); advisor-only + doc-zone auto-edit.
- **Decision.** **Advisor-only untuk kode aplikasi** (agent mengusulkan
  diff, human eksekusi), **netral-model** (berlaku model apa pun).
  Pengecualian doc-zone diatur ADR-017. Diatur penuh oleh R900.
- **Rationale.** Mendukung belajar + kontrol manusia atas runtime.
  Revisi 2026-07-24: netralkan dari "Claude" ke "agent" (sejalan
  ADR-016).
- **Consequences.** (+) Aman, edukatif. (−) Lebih banyak langkah manual
  untuk kode.
- **Change control.** ADR baru untuk mengubah mode.

## ADR-016 — Strategi model: agnostik
**Status:** Accepted · 2026-07-24 · **Supersedes D-18, D-19**

- **Context.** D-18/D-19 mengunci "Claude untuk Plan+Verify, DeepSeek
  untuk Execute" — membuat workflow bergantung dua vendor spesifik dan
  memaksa fase ke model tertentu.
- **Options considered.** (a) Pertahankan penguncian Claude/DeepSeek
  per fase; (b) model-agnostik penuh (harness netral, model apa pun
  bisa fase apa pun); (c) netral wording tapi split fase tetap dikunci.
- **Decision.** Ambil (b). Harness ditulis netral ("the agent"); rule
  tidak mensyaratkan model tertentu (R000.8). Pemilihan model jadi
  keputusan operasional per sesi, bukan aturan.
- **Rationale.** Menghindari ketergantungan satu vendor; bebas pakai
  model termurah/terbaik saat itu; rule model-agnostik (R000.7)
  memaksa kejelasan yang menguntungkan semua model.
- **Consequences.** (+) Fleksibel, tahan perubahan harga/ketersediaan.
  (+) Rule lebih eksplisit. (−) Tak ada "resep" tetap; developer memilih
  model sadar per sesi. Rekomendasi opsional tetap dicatat (model kuat
  untuk Plan/Verify, model murah untuk Execute) di `CLAUDE.md`.
- **Change control.** ADR baru yang men-supersede.

## ADR-017 — Adopsi `.harness/` + doc-zone auto-edit (R900)
**Status:** Accepted · 2026-07-24

- **Context.** Ingin sistem harness engineering pola ContractIQ,
  disesuaikan Flutter, agar kolaborasi AI andal & model-agnostik.
- **Options considered.** Tanpa harness formal (hanya CLAUDE.md);
  adopsi `.harness/` penuh; adopsi sebagian.
- **Decision.** Adopsi `.harness/` (README + rules R000–R900 + prompts
  + checklists + examples). Advisor-only untuk kode (R900.1–.4) dengan
  **pengecualian doc-zone auto-edit** (R900.8) agar churn dokumentasi
  tidak boros langkah.
- **Rationale.** Rule eksplisit + model-agnostik menaikkan kualitas
  output lintas-model; doc-zone auto-edit mengurangi friksi tanpa
  melemahkan keamanan runtime.
- **Consequences.** (+) Konsisten, portfolio-grade, mudah dilanjut
  model lain. (−) Overhead memelihara rule (diimbangi R000.5 disiplin
  ADR).
- **Change control.** Perubahan rule butuh ADR (R000.5).

## ADR-018 — learning_docs sebagai repo private terpisah
**Status:** Accepted · 2026-07-24

- **Context.** Butuh tempat catatan belajar (analogi, kebingungan,
  refleksi) tanpa mengotori repo utama yang jadi sinyal portfolio.
- **Options considered.** Folder di repo utama; repo private terpisah;
  tanpa catatan.
- **Decision.** `learning_docs/` sebagai **repo git private terpisah**,
  di-`.gitignore` dari repo utama. Merujuk repo utama via `ADR-###`,
  `R###`, `T-###`, `AC-F#.#`.
- **Rationale.** Repo utama tetap "karya selesai"; catatan belajar bebas
  & jujur di repo pribadi.
- **Consequences.** (+) Portfolio bersih + belajar mendalam. (−) Dua
  repo untuk dikelola (dibantu helper push).
- **Change control.** ADR baru bila menggabung/menghapus.

## ADR-019 — Repo utama GitHub: public
**Status:** Accepted · 2026-09-25 · **Supersedes** bagian "private" di T-007 (`docs/MVP.md`)

- **Context.** T-007 awalnya menyebut repo utama di-push sebagai
  **private**. Saat pengecekan T-006 (CI), repo ternyata sudah
  **public** sejak awal push.
- **Options considered.** (a) Ubah jadi private sesuai spec asli;
  (b) biarkan public, update spec — selaras tujuan Sangu sebagai
  portfolio utama (CLAUDE.md: "portfolio utama untuk lamaran AI-native
  full-stack").
- **Decision.** Ambil (b). Repo utama `sangu-app` tetap **public**.
- **Rationale.** Salah satu dari empat tujuan Sangu adalah portfolio
  yang bisa ditunjukkan langsung (bukan cuma deskripsi) ke calon
  pemberi kerja — repo public mendukung itu tanpa friksi akses.
  Kredensial sensitif (Firebase config, API key) tetap **tidak boleh**
  ikut ter-commit (R400.1) — itu digovern terpisah, bukan oleh
  visibility repo.
- **Consequences.** (+) Mudah dibagikan sebagai portfolio, tanpa perlu
  invite akses. (−) Kode & histori commit (termasuk pesan commit)
  terlihat publik — perlu disiplin ekstra jangan pernah commit secret
  (R400.1, `.gitignore` untuk `.env*`/`firebase_options.dart` bila
  sensitif, ADR-007).
- **Change control.** ADR baru bila kembali ke private (mis. karena
  butuh menyembunyikan logika bisnis tertentu).

---

## Pertanyaan terbuka (belum final)

| Item | Status |
|---|---|
| Hex warna final (light & dark) | Ditentukan saat implementasi UI (M2/M6). Arah: warm-earthy (ADR-010) |
| Font spesifik (headline & body) | Pilih saat M2. Syarat: editorial, ada tabular figures (R602.3) |
| Daftar badge gamifikasi final | Rancang saat M2 (mulai 3–5 badge) (ADR-011) |
| Nama model Gemini spesifik | Cek Firebase console saat M0; simpan di Remote Config (R500.7) |

Taksonomi kategori bersifat **soft** (mudah diubah di
`ARCHITECTURE.md`), bukan keputusan terkunci keras.
