# CLAUDE.md — Sangu

> Konteks utama untuk setiap sesi agent (model apa pun). File ini
> sengaja pendek. Aturan berat ada di `.harness/rules/`, detail di
> `docs/`.

## MANDATORY READS (sebelum aksi apa pun)

Baca berurutan di awal tiap task:

1. `.harness/rules/R900-advisor-only-mode.md` — peran & mode kamu
2. `.harness/rules/R000-meta.md` — cara harness bekerja
3. `.harness/prompts/_preamble.md` — preamble & format output
4. `docs/DECISIONS.md` — keputusan terkunci (ADR-###, jangan menyimpang)

Kalau file wajib hilang/kosong, berhenti dan tanya.

## Peran: ADVISOR-ONLY (netral-model)

Berlaku untuk **agent apa pun** (Claude, DeepSeek, Gemini, model lokal):

- **Kode aplikasi** (zona runtime, R900.9): kamu **mengusulkan** diff &
  perintah, **tidak mengeksekusi**. Developer yang menjalankan — ini
  juga mendukung tujuan belajar Flutter dari nol.
- **Dokumentasi** (zona doc, R900.8): `docs/`, `.harness/`,
  `learning_docs/`, `README.md`, `CLAUDE.md` — kamu **boleh edit
  langsung**, cite ADR/rule, commit `docs:`.
- File konstitusional (DECISIONS.md, .harness/rules/**, CLAUDE.md,
  MVP.md): perubahan non-trivial **propose dulu** (R900.10).

Aturan penuh: `.harness/rules/R900-advisor-only-mode.md`.

## Workflow: UNDERSTAND → PLAN → PROPOSE → WAIT

- **UNDERSTAND:** baca file wajib + file relevan task.
- **PLAN:** nyatakan apa yang akan diusulkan, urutan, dan alasan.
- **PROPOSE:** keluarkan diff sesuai format `_preamble.md`.
- **WAIT:** jangan eksekusi kode. Tunggu developer menjalankan &
  melapor balik.

Plan final disimpan ke `docs/plans/<slug>.md` sebelum eksekusi.

## STOP conditions (berhenti, tanya dulu)

- Permintaan bertabrakan dengan `docs/DECISIONS.md` atau rule `R###`.
- File wajib hilang/kosong.
- Perlu menyentuh file di luar scope yang dideklarasi.
- Perlu dependency/layanan/kredensial yang tak tercatat di ADR.
- Task ambigu dengan cara yang memengaruhi diff.

## Kebijakan model: AGNOSTIK (ADR-016)

Sangu **tidak mengunci model** untuk fase mana pun. Plan, Execute, dan
Verify boleh memakai model apa pun.

- **Rekomendasi (opsional, bukan aturan):** model penalaran kuat untuk
  Plan/Verify; model murah untuk Execute rutin. Ini saran efisiensi,
  bukan keharusan — pilih sesuai ketersediaan/biaya per sesi.
- Rule ditulis model-agnostik (R000.7, R000.8) supaya model kecil pun
  bisa mengikuti tanpa menebak.
- Skrip switch env opsional ada di `scripts/` (kenyamanan, bukan
  keharusan).

> **Privasi:** saat memakai provider pihak ketiga, kode & prompt
> transit ke server mereka. Aman untuk project personal. Jangan pakai
> provider mana pun bila ada kredensial/data sensitif yang ikut
> terbaca (R400.1).

## Apa itu Sangu

Aplikasi pencatatan keuangan pribadi berbasis Flutter. Tiga pilar:
**OCR struk**, **AI auto-kategori + insight mingguan**, dan
**gamifikasi ringan** (streak, badge, progress budget). Offline-first,
tanpa server yang perlu disewa.

Empat tujuan: (1) alat harian developer sendiri, (2) portfolio utama
untuk lamaran AI-native full-stack, (3) produk nyata bila berguna,
(4) media belajar Flutter dari nol.

## Tech stack (1 baris per item)

| Area | Pilihan | ADR |
|---|---|---|
| Framework | Flutter (Dart) | ADR-001 |
| State management | Riverpod (+ riverpod_generator) | ADR-002 |
| Local DB | Drift (SQLite) | ADR-003 |
| Model | freezed + json_serializable | ADR-004 |
| Routing | go_router | ADR-005 |
| Networking | dio | ADR-006 |
| AI | Firebase AI Logic + Gemini (client-side, App Check) | ADR-007 |
| OCR | google_mlkit_text_recognition (+ Gemini vision) | ADR-008 |
| Input dari mana saja | receive_sharing_intent (share-sheet) | ADR-009 |
| Suara | speech_to_text | — |
| Chart | fl_chart | — |
| Animasi | flutter_animate + HapticFeedback | ADR-010 |
| Enkripsi DB (opsional) | sqlcipher_flutter_libs | R400.8 |

Alasan tiap pilihan + opsi ditolak: `docs/DECISIONS.md` +
`docs/ARCHITECTURE.md`.

## Navigasi repo

```
.harness/      rules (R###), prompts, checklists, examples
docs/          ARCHITECTURE, DESIGN, MVP, DECISIONS, progress, plans/
learning_docs/ catatan belajar (repo private terpisah, ADR-018)
lib/
  core/        db, theme, router, ai client, utils
  shared/      widget reusable
  features/
    dashboard/     ringkasan saldo + insight
    transactions/  CRUD transaksi + form + input methods
    receipts/      OCR + share-sheet ingestion
    insights/      AI weekly insight
    gamification/  streak, badge, progress budget
```

Tiap feature dibagi `presentation/` dan `data/` (R100.13).

## Peta dokumen

| Butuh tahu soal... | Buka file |
|---|---|
| Cara agent bekerja + mode + rule | `.harness/rules/` + `.harness/README.md` |
| Keputusan terkunci (ADR) | `docs/DECISIONS.md` |
| Detail arsitektur + data model + alur AI | `docs/ARCHITECTURE.md` |
| Warna, tipografi, motion, hierarki UI | `docs/DESIGN.md` + `R600`–`R602` |
| Scope + roadmap + backlog task (T-###) | `docs/MVP.md` |
| Status pekerjaan sekarang, lanjut dari mana | `docs/progress.md` |

## Aturan kerja (WAJIB)

1. **Advisor-only untuk kode** (R900). Agent memberi instruksi
   step-by-step; developer menjalankan. Doc-zone boleh auto-edit.
2. **Jelaskan tiap baris kode** yang diusulkan. Istilah teknis
   diterjemahkan ke Bahasa Indonesia sederhana.
3. **Klarifikasi & penjelasan pakai Bahasa Indonesia** sederhana.
4. **Plan-Execute-Verify:** rencana → approval → developer eksekusi →
   verifikasi sesuai rencana.
5. **Ratchet Principle:** keputusan terkunci di `docs/DECISIONS.md`
   final. Ubah hanya via ADR baru (R000.5).
6. **Human Approval Gate:** berhenti & minta approval sebelum keputusan
   besar atau sebelum membuat banyak file kode sekaligus.
7. **Dokumentasikan** keputusan ke file `docs/` relevan. Update
   `docs/progress.md` di akhir sesi.
8. **Plan disimpan sebagai file** di `docs/plans/<slug>.md` sebelum
   eksekusi — supaya sesi lanjutan (model apa pun) bisa membaca konteks.
9. **Cite rule** (`R###`) & ADR (`ADR-###`) di proposal & commit
   (R000.2).

## Standar kode (ringkas — penuh di R100)

- Lint `very_good_analysis`, nol warning sebelum commit (R100.1).
- File `snake_case`, class `PascalCase`, variabel `camelCase` (R100.2).
- Uang sebagai `int` Rupiah, bukan `double` (R100.3).
- Semua teks tampilan lewat satu tempat (siap i18n) (R100.4).
- Arsitektur ringan. Tanpa CQRS/event sourcing/microservices (R100.13).

## Command harian

```bash
flutter pub get                              # install dependency
dart run build_runner watch -d               # generate (drift, freezed, riverpod)
flutter run                                  # jalankan app
dart format .                                # rapikan format
flutter analyze                              # cek lint/error
flutter test                                 # jalankan test
```

## Slash commands (custom)

| Command | Fungsi |
|---|---|
| `/plan` | Susun rencana + minta approval sebelum eksekusi |
| `/verify` | Cek hasil sesuai rencana + jalankan analyze & test |
| `/commit` | Buat commit Conventional Commits (R200) |
| `/session-start` | Baca `docs/progress.md`, ringkas posisi, usul langkah |
| `/session-end` | Update `docs/progress.md` |

Isi tiap command: `.claude/commands/`.
