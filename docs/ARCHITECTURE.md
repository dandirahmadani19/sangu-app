# ARCHITECTURE.md — Sangu

> Register ADR kanonik ada di `docs/DECISIONS.md` (ADR-###, per ADR-017).
> Bagian di bawah menyimpan **detail teknis + opsi lain + alasan** yang
> menopang tiap ADR — bukan register terpisah. Nomor mengikuti
> `DECISIONS.md`.

## ADR-002 — State management: Riverpod (detail)
- **Opsi lain:** Provider (lebih simpel), Bloc (lebih banyak boilerplate), GetX (reputasi anti-pattern).
- **Alasan:** compile-safe, testable, mental modelnya mirip hooks/context React yang sudah dikuasai. `riverpod_generator` mengurangi boilerplate.
- **Tradeoff:** kurva belajar > Provider, butuh langkah `build_runner`. Sepadan untuk maintainability + portfolio.

## ADR-003 — Local DB: Drift (detail)
- **Opsi lain:** Isar/Hive (praktis tidak dirawat lagi di 2026), sqflite (SQL mentah, boilerplate), ObjectBox (sebagian komersial).
- **Alasan:** SQLite type-safe, query reaktif (stream auto-update UI), migrasi bisa dites, cocok dengan latar belakang PostgreSQL. Dirawat aktif.
- **Tradeoff:** butuh codegen `build_runner`. Type-safety menutup satu kelas bug runtime.

## ADR-007 — AI transport: Firebase AI Logic + Gemini (detail)
- **Opsi lain:** backend proxy NestJS (butuh sewa server), API key Gemini langsung di client (tidak aman), murni on-device (structured output lemah di Android, device terbatas).
- **Alasan:** SDK `firebase_ai` memanggil Gemini langsung dari client **tanpa server yang perlu disewa/deploy**, ada **free tier**, dan **App Check** melindungi kunci API. Mendukung **function calling / structured output** (pola ContractIQ) dan **multimodal** (foto struk).
- **Tradeoff:** inference berjalan di cloud Google (bukan on-device), butuh setup project Firebase + App Check sekali di awal. Ini menggantikan rencana backend lama.
- **Catatan model:** pakai model Flash terbaru (cek Firebase console; model lama seperti gemini-2.0-flash sudah dimatikan). Simpan nama model di Firebase Remote Config agar bisa ganti tanpa rilis ulang.
- **Masa depan:** mode offline/privasi via ML Kit GenAI (Gemini Nano) atau flutter_gemma — di luar scope v1.

## ADR-008 — OCR: ML Kit on-device + Gemini vision (detail)
- **Opsi lain:** `receipt_recognition` (dirawat, tapi ditune pasar Eropa: Aldi/Rewe/Lidl, format EUR & EN/DE).
- **Alasan:** `google_mlkit_text_recognition` mengekstrak teks on-device (gratis, offline). Untuk parsing terstruktur (merchant, item, total), kirim teks/gambar ke Gemini via Firebase AI Logic — jauh lebih akurat untuk struk Indonesia (Indomaret/Alfamart, Rupiah).
- **Alur:** capture → teks on-device (fallback offline) → bila online, Gemini vision → JSON → form pre-filled → user konfirmasi.

## ADR-001 — Struktur folder: feature-first + layering tipis (detail)
- **Opsi lain:** Clean Architecture 3-layer penuh (terlalu berat untuk solo).
- **Alasan:** cukup simpel untuk diingat di kepala, tiap fitur mandiri, mudah dinavigasi AI.

## ADR-009 — Input dari mana saja: OS Share Sheet (detail)
- **Opsi lain:** auto-scan Gmail via OAuth (butuh verifikasi Google + praktis butuh server), baca SMS/notifikasi (dibatasi kebijakan Play Store).
- **Alasan:** `receive_sharing_intent` menerima struk (gambar/PDF/teks) yang di-*share* dari email/e-wallet/marketplace ke Sangu, lalu diparse Gemini. ~90% nilai tanpa server. Auto-scan email penuh = Won't (v1).

---

## Struktur folder lengkap

```
sangu/
  CLAUDE.md
  analysis_options.yaml
  lefthook.yml
  .github/workflows/ci.yml
  docs/
    ARCHITECTURE.md  DESIGN.md  MVP.md  DECISIONS.md  progress.md
  lib/
    main.dart
    core/
      db/            drift database, tables, DAOs
      ai/            firebase ai client, prompt & schema
      router/        go_router config
      theme/         color, typography, motion tokens
      utils/         format uang, tanggal
    shared/
      widgets/       widget reusable (kartu, tombol, dsb)
    features/
      dashboard/     { presentation/, data/ }
      transactions/  { presentation/, data/ }
      receipts/      { presentation/, data/ }
      insights/      { presentation/, data/ }
      gamification/  { presentation/, data/ }
  test/
```

## Alur state (satu arah, reaktif)

```
UI (widget)
  → panggil method di Notifier (Riverpod)
    → Notifier panggil Repository
      → Repository baca/tulis Drift
        → Drift kembalikan Stream
      ← Repository teruskan Stream
    ← Notifier expose state
  ← UI rebuild otomatis saat stream berubah
```

- **Repository** = satu-satunya pintu ke data (Drift + AI). Notifier tidak menyentuh Drift langsung.
- Query Drift dikembalikan sebagai `Stream`, jadi UI auto-update tanpa refresh manual.

## Alur offline + AI

- **Data transaksi 100% lokal** di Drift. App jalan penuh tanpa internet.
- **Panggilan AI butuh online.** Bila offline saat butuh insight/parse:
  - Transaksi tetap tercatat (kategori sementara via aturan kata kunci lokal).
  - Job AI masuk **antrian** (tabel `pending_ai_jobs`), diproses saat online.
- Auto-kategori harian = aturan kata kunci on-device (instan, offline). AI merapikan saat insight mingguan.

## Alur share-sheet

```
App lain (email/e-wallet) → tombol Share → pilih Sangu
  → receive_sharing_intent tangkap file/teks
    → deteksi tipe (gambar → OCR/vision, teks → parse)
      → Gemini → JSON transaksi
        → buka form pre-filled → user konfirmasi → simpan ke Drift
```

---

## Data model

### Transaction
| Field | Tipe | Wajib | Catatan |
|---|---|---|---|
| id | String (uuid) | ✅ | |
| type | enum expense/income | ✅ | |
| amount | int (Rupiah) | ✅ | bukan double |
| category | String | ✅ | dari taksonomi |
| subCategory | String | ✅ | default "Lainnya" |
| description | String | ✅ | ringkas |
| merchant | String? | — | nama toko/brand/tempat (opsional) |
| note | String? | — | catatan bebas |
| occurredAt | DateTime | ✅ | default now |
| source | enum | ✅ | manual/voice/nlText/receiptPhoto/shareSheet/clipboard |
| aiConfidence | double? | — | 0..1, bila hasil AI |
| needsReview | bool | ✅ | true bila AI ragu |
| accountId | String? | — | v1 dompet tunggal |
| createdAt / updatedAt | DateTime | ✅ | |

### Category & SubCategory (tabel seed, bisa ditambah user)
| id | name | type | parentId |
|---|---|---|---|
| ... | Transportasi | expense | null |
| ... | Bensin/BBM | expense | (id Transportasi) |

**Taksonomi seed — Expense:**
- **Makan & Minum:** Warung/Rumah Makan, Restoran, Kopi & Cafe, Jajan/Snack, Belanja Dapur, Delivery
- **Transportasi:** Bensin/BBM, Ojek/Taksi Online, Parkir, Tol, Transportasi Umum, Servis Kendaraan
- **Belanja:** Kebutuhan Harian, Elektronik, Pakaian, Rumah Tangga, Online Shopping
- **Tagihan & Utilitas:** Listrik, Air, Internet, Pulsa/Data, Langganan, BPJS/Asuransi
- **Kesehatan:** Obat/Apotek, Dokter/Klinik, Rumah Sakit, Olahraga/Gym
- **Hiburan:** Nonton, Game, Traveling, Hobi
- **Pendidikan:** Kursus, Buku, Sekolah/Kuliah
- **Rumah:** Sewa/Kontrakan, Perabot, Perbaikan
- **Keluarga & Sosial:** Hadiah, Donasi, Zakat/Sedekah, Kirim Keluarga
- **Keuangan:** Tabungan, Investasi, Biaya Admin
- **Lainnya**

**Taksonomi seed — Income:** Gaji (Pokok, Bonus, THR, Lembur), Usaha/Freelance (Proyek, Jualan), Investasi (Dividen, Bunga, Capital Gain), Lainnya (Hadiah, Refund, Cashback).

### Streak & Gamification
`streak_count`, `last_logged_date`, `badges[]`, `monthly_budget`. Detail visual di `docs/DESIGN.md`.

---

## Schema AI

### A. Parse satu transaksi (voice / teks / share / foto)
**Input:** teks ucapan/tulisan user, atau gambar struk.
**Output (structured):**
```json
{
  "type": "expense",
  "amount": 40000,
  "category": "Transportasi",
  "subCategory": "Bensin/BBM",
  "description": "Isi Pertalite",
  "merchant": "SPBU / POM Bensin",
  "occurredAt": "2026-07-04T10:00:00+07:00",
  "confidence": 0.9,
  "needsReview": false
}
```
Aturan: kategori & subCategory harus dari taksonomi; jika ragu → subCategory "Lainnya" + `needsReview: true`. `merchant` opsional (null bila tak jelas). `occurredAt` default now kecuali user sebut waktu.

### B. Insight mingguan
**Input (minimal, jaga privasi):**
```json
{
  "period": "2026-07-01 s/d 2026-07-07",
  "currency": "IDR",
  "totalsByCategory": [{ "category": "Makan & Minum", "amount": 340000 }],
  "totalSpent": 1250000,
  "budget": 2000000,
  "uncategorized": [{ "id": "tx_12", "merchant": "Indomaret", "amount": 32000 }],
  "prevPeriodTotal": 1100000
}
```
**Output:**
```json
{
  "headline": "1 kalimat ringkas",
  "highlights": ["2-4 poin insight"],
  "warning": "string | null (bila mendekati/lewat budget)",
  "tip": "1 saran actionable",
  "categoryCorrections": [{ "id": "tx_12", "category": "Belanja", "subCategory": "Kebutuhan Harian" }]
}
```
Satu panggilan = insight + rapikan kategori sekaligus.

**Enforcement:** definisikan `responseSchema` Gemini agar output selalu JSON valid. Parse aman di Dart pakai model freezed; bila gagal parse → tampilkan state error, jangan crash.

---

## Harness & Tooling

### analysis_options.yaml
```yaml
# Mengaktifkan aturan lint ketat dari paket very_good_analysis.
include: package:very_good_analysis/analysis_options.yaml
analyzer:
  exclude:
    - "**/*.g.dart"      # file hasil generate, jangan dilint
    - "**/*.freezed.dart"
```

### lefthook.yml (pre-commit hook)
```yaml
# Dijalankan otomatis sebelum tiap git commit.
pre-commit:
  commands:
    format:
      run: dart format --set-exit-if-changed .   # gagal bila ada file belum diformat
    analyze:
      run: flutter analyze                        # gagal bila ada warning/error
    test:
      run: flutter test                           # gagal bila ada test merah
```
Pasang sekali: `dart pub global activate lefthook` lalu `lefthook install`.

### .github/workflows/ci.yml (CI gate)
```yaml
# Gerbang di GitHub: sekali hijau, wajib tetap hijau (Ratchet).
name: ci
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: dart run build_runner build -d      # generate kode
      - run: flutter analyze
      - run: flutter test
```

### Slash commands (letakkan di `.claude/commands/`)
- **plan.md:** "Susun rencana langkah kerja untuk tugas berikut, tunggu approval sebelum eksekusi. Jangan tulis kode implementasi dulu."
- **verify.md:** "Bandingkan hasil dengan rencana. Jalankan `flutter analyze` dan `flutter test`. Laporkan yang belum sesuai."
- **commit.md:** "Buat pesan commit Conventional Commits (feat/fix/docs/refactor/test/chore) dari perubahan staged."
- **session-start.md:** "Baca docs/progress.md. Ringkas posisi terakhir dan usulkan 1-3 langkah berikutnya."
- **session-end.md:** "Update docs/progress.md: status, yang selesai sesi ini, langkah berikutnya, blocker."
