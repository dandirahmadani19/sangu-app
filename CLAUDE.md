# CLAUDE.md — Sangu

> Konteks utama untuk setiap sesi Claude Code. File ini sengaja pendek. Detail berat ada di `docs/`.

## Apa itu Sangu

Aplikasi pencatatan keuangan pribadi berbasis Flutter. Tiga pilar pembeda: **OCR struk**, **AI auto-kategori + insight mingguan**, dan **gamifikasi ringan** (streak, badge, progress budget). Offline-first, tanpa server yang perlu disewa.

Empat tujuan: (1) alat harian developer sendiri, (2) portfolio utama untuk lamaran AI-native full-stack, (3) produk nyata bila berguna, (4) media belajar Flutter dari nol.

## Tech stack (1 baris per item)

| Area | Pilihan |
|---|---|
| Framework | Flutter (Dart) |
| State management | Riverpod (+ riverpod_generator) |
| Local DB | Drift (SQLite, type-safe, reactive) |
| Model | freezed + json_serializable |
| Routing | go_router |
| Networking | dio |
| AI | Firebase AI Logic + Gemini (free tier, client-side, App Check) |
| OCR | google_mlkit_text_recognition (+ Gemini vision untuk parse terstruktur) |
| Input dari mana saja | receive_sharing_intent (share-sheet) |
| Suara | speech_to_text |
| Chart | fl_chart |
| Animasi | flutter_animate + HapticFeedback |
| Enkripsi DB (opsional) | sqlcipher_flutter_libs |

Alasan tiap pilihan + opsi yang ditolak: lihat `docs/ARCHITECTURE.md`.

## Navigasi repo

```
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

Tiap feature dibagi `presentation/` (screen, widget, provider) dan `data/` (repository, model).

## Peta dokumen

| Butuh tahu soal... | Buka file |
|---|---|
| Keputusan arsitektur + data model + alur AI | `docs/ARCHITECTURE.md` |
| Warna, tipografi, motion, hierarki UI | `docs/DESIGN.md` |
| Scope + roadmap 6 minggu | `docs/MVP.md` |
| Keputusan terkunci + pertanyaan terbuka | `docs/DECISIONS.md` |
| Status pekerjaan sekarang, lanjut dari mana | `docs/progress.md` |

## Aturan kerja Claude (WAJIB)

1. **Claude tidak mengeksekusi kode aplikasi.** Tugas Claude: memberi instruksi + arahan detail step-by-step. Developer yang menjalankan semua perintah, kode, dan setup.
2. **Jelaskan tiap baris kode** yang diberikan. Istilah teknis diterjemahkan ke Bahasa Indonesia sederhana.
3. **Jawaban klarifikasi selalu pakai Bahasa Indonesia sederhana**, bukan Inggris.
4. **Plan-Execute-Verify (PEV):** susun rencana → minta approval → developer eksekusi → verifikasi hasil sesuai rencana.
5. **Ratchet Principle:** keputusan yang sudah dikunci di `docs/DECISIONS.md` dianggap final. Jangan dibuka lagi kecuali ada alasan baru yang jelas.
6. **Human Approval Gate:** berhenti dan minta approval sebelum keputusan besar atau sebelum membuat banyak file sekaligus.
7. **Dokumentasikan** tiap keputusan + alur logika ke file `docs/` yang relevan. Update `docs/progress.md` di akhir sesi.
8. **Plan wajib pakai Opus.** Sebelum menyusun plan apapun (implementasi, refactor, roadmap, ADR, respons `/plan`, atau permintaan bebas "buatkan rencana"), Claude cek model aktif. Kalau bukan Opus, hentikan — beri peringatan dan minta konfirmasi user (switch via `/model opus`, atau izin eksplisit "lanjut pakai model ini"). Fase Verify & Execute tidak diwajibkan Opus.
9. **Plan wajib disimpan sebagai file.** Setiap plan yang sudah final ditulis ke `docs/plans/<slug>.md` (mis. `week-0-setup-harness.md`) sebelum eksekusi — bukan hanya di chat. Alasannya: fase Execute pakai DeepSeek di sesi terpisah, tinggal `cat` file plan untuk lanjut tanpa kehilangan konteks.

## Model switching (dual-model workflow)

Dua mode yang bisa diswitch kapan saja. **Claude untuk berpikir, DeepSeek untuk mengeksekusi.**

| Fase PEV | Model | Alasan |
|---|---|---|
| **Plan** (susun rencana, arsitektur, keputusan) | Claude | Instruction-following konsisten, architectural reasoning lebih kuat |
| **Execute** (implementasi kode rutin, buat file, CRUD) | DeepSeek V4 | 10–15× lebih murah, hasilnya kompetitif untuk tugas well-scoped |
| **Verify** (review kualitas, cek hasil, debug logic) | Claude | Tool-call handling lebih andal, lebih konsisten di sesi panjang |

### Mode A — Claude (default, planning & verify)
Tidak perlu ubah apapun. Pakai API key Anthropic seperti biasa.

### Mode B — DeepSeek (execution)
Jalankan perintah ini di terminal **sebelum** membuka sesi Claude Code:
```bash
export ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic
export ANTHROPIC_AUTH_TOKEN=<DeepSeek API Key kamu>
export ANTHROPIC_MODEL=deepseek-v4-pro[1m]
export ANTHROPIC_DEFAULT_OPUS_MODEL=deepseek-v4-pro[1m]
export ANTHROPIC_DEFAULT_SONNET_MODEL=deepseek-v4-pro[1m]
export ANTHROPIC_DEFAULT_HAIKU_MODEL=deepseek-v4-flash
export CLAUDE_CODE_SUBAGENT_MODEL=deepseek-v4-flash
```
Setelah itu jalankan `claude` seperti biasa. Untuk kembali ke Claude: tutup terminal, buka terminal baru (env var kembali ke default).

> **Peringatan model string:** Alias lama `deepseek-chat` dan `deepseek-reasoner` deprecated **24 Juli 2026**. Selalu pakai `deepseek-v4-pro[1m]` dan `deepseek-v4-flash`.

> **Privasi:** Saat Mode B aktif, kode dan prompt transit ke server DeepSeek, bukan Anthropic. Aman untuk project personal. Jangan gunakan Mode B bila ada credential atau data sensitif yang ikut terbaca agent.

### Tips praktis
Buat dua file shell script di root repo untuk switch cepat:
- `scripts/use_claude.sh` → `unset` semua env var di atas
- `scripts/use_deepseek.sh` → `export` semua env var di atas
Jalankan dengan `source scripts/use_deepseek.sh` (bukan `./`, karena perlu apply ke sesi terminal yang sama).

## Standar kode

- Ikuti lint `very_good_analysis` (lihat `analysis_options.yaml`). Nol warning sebelum commit.
- Nama file `snake_case`, class `PascalCase`, variabel `camelCase`.
- Simpan uang sebagai `int` Rupiah, bukan `double`.
- Semua teks tampilan lewat satu tempat (siap i18n), jangan hardcode di widget.
- Arsitektur ringan. Jangan pakai CQRS, event sourcing, atau microservices. Simpel dulu.

## Command harian

```bash
flutter pub get                              # install dependency
dart run build_runner watch -d               # generate kode (drift, freezed, riverpod)
flutter run                                  # jalankan app
dart format .                                # rapikan format
flutter analyze                              # cek lint/error
flutter test                                 # jalankan test
```

## Slash commands (custom)

| Command | Fungsi |
|---|---|
| `/plan` | Susun rencana kerja + minta approval sebelum eksekusi |
| `/verify` | Cek hasil pekerjaan sesuai rencana + jalankan analyze & test |
| `/commit` | Buat commit pesan Conventional Commits |
| `/session-start` | Baca `docs/progress.md`, ringkas posisi terakhir, usulkan langkah berikut |
| `/session-end` | Update `docs/progress.md` (status, yang selesai, langkah berikut) |

Isi tiap slash command: lihat bagian "Harness & Tooling" di `docs/ARCHITECTURE.md`.
