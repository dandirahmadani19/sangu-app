# DECISIONS.md — Sangu

Ratchet Principle: yang **terkunci** dianggap final. Jangan dibuka lagi kecuali ada alasan baru yang jelas (tulis alasannya).

## Terkunci (per 2026-07-04)

| # | Keputusan |
|---|---|
| D-01 | Framework: **Flutter** |
| D-02 | State management: **Riverpod** (+ riverpod_generator) |
| D-03 | Local DB: **Drift** (SQLite) |
| D-04 | Model: **freezed + json_serializable** |
| D-05 | Routing: **go_router** |
| D-06 | Networking: **dio** |
| D-07 | AI: **Firebase AI Logic + Gemini** (client-side, free tier, App Check). **Tanpa backend yang disewa.** |
| D-08 | OCR: **google_mlkit_text_recognition** + **Gemini vision** untuk parse terstruktur |
| D-09 | Input dari mana saja: **OS Share Sheet** (`receive_sharing_intent`) |
| D-10 | Struktur folder: **feature-first + layering tipis** (bukan Clean Architecture penuh) |
| D-11 | UI: **Material 3** fondasi + **M3E manual** (skill Mic-360). Nuansa **warm-earthy-editorial** |
| D-12 | Nama: **Sangu** (cosmetic, bisa diganti developer kapan saja) |
| D-13 | Gamifikasi: streak + badge + progress budget. **Bukan** leaderboard/sosial |
| D-14 | Uang disimpan sebagai **int Rupiah**, bukan double |
| D-15 | Data model transaksi lengkap: type, amount, category, subCategory, description, merchant (opsional), occurredAt, source, needsReview |
| D-16 | Harness: very_good_analysis + lefthook (pre-commit) + GitHub Actions CI + slash commands |
| D-17 | Claude memberi instruksi, **tidak** mengeksekusi kode aplikasi. Jelaskan tiap baris. Klarifikasi pakai Bahasa Indonesia |
| D-18 | Dual-model workflow: **Claude untuk Plan + Verify**, **DeepSeek V4 Pro** untuk Execute. Switch via env var di terminal. Tanpa OpenRouter, tanpa backend tambahan |
| D-19 | Strategi planning: **seluruh rencana (Plan) dibuat dulu dengan Claude** sebelum ada satu baris kode pun ditulis. DeepSeek baru masuk di fase Execute, berdasarkan plan yang sudah diapprove |

## Digantikan (superseded)

| Lama | Diganti | Alasan |
|---|---|---|
| Backend proxy NestJS untuk AI | Firebase AI Logic (D-07) | Efisiensi release: tidak perlu sewa/deploy server |
| Shared types Dart ↔ backend (open question #3) | Gugur | Tidak ada backend terpisah; schema cukup di sisi Dart |

## Pertanyaan terbuka (belum final)

| Item | Status |
|---|---|
| Hex warna final (light & dark) | Ditentukan saat implementasi UI (Minggu 2/6). Arah sudah: warm-earthy |
| Font spesifik (headline & body) | Pilih saat Minggu 2. Syarat: editorial, ada tabular figures |
| Daftar badge gamifikasi final | Rancang saat Minggu 2 (mulai 3-5 badge) |
| Nama model Gemini spesifik | Cek Firebase console saat Minggu 0; simpan di Remote Config |

Taksonomi kategori bersifat **soft** (mudah diubah di ARCHITECTURE.md), bukan keputusan terkunci keras.
