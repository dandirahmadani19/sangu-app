# R100 — Coding Standards (Dart/Flutter)

Standar penulisan kode untuk Sangu. Tujuan: konsisten, aman dari
kelas bug umum, dan mudah dinavigasi model kecil maupun manusia.

## Scope

Berlaku untuk semua kode di `lib/**` dan `test/**`. File hasil
generate (`*.g.dart`, `*.freezed.dart`) dikecualikan dari gaya, tapi
diatur R100.14.

## R100.1 — Nol warning sebelum commit

`flutter analyze` MUST bersih (nol error, nol warning) sebelum commit.
Lint mengikuti `very_good_analysis` (lihat `analysis_options.yaml`).
Agent MUST NOT mengusulkan kode yang memicu warning tanpa `// ignore:`
beserta alasan.

## R100.2 — Penamaan

- File: `snake_case` (`transaction_form.dart`).
- Class / enum / typedef: `PascalCase` (`TransactionRepository`).
- Variabel / fungsi / parameter: `camelCase` (`totalSpent`).
- Konstanta: `camelCase` (bukan `SCREAMING_CASE`) sesuai gaya Dart.
- Provider Riverpod: akhiri sesuai peran (`transactionsProvider`).

## R100.3 — Uang selalu `int` Rupiah

Nilai uang MUST disimpan dan dihitung sebagai `int` Rupiah, bukan
`double`. `double` untuk uang membawa galat pembulatan.

**Salah:**
```dart
double amount = 40000.0;
```
**Benar:**
```dart
int amount = 40000; // Rupiah, tanpa desimal
```
Pengecualian: `aiConfidence` (0..1) MAY `double` karena bukan uang.

## R100.4 — Tidak ada teks tampilan hardcode

Semua teks yang tampil ke user MUST lewat satu tempat terpusat (siap
i18n), MUST NOT ditulis langsung di widget.

**Salah:**
```dart
Text('Saldo kamu');
```
**Benar:**
```dart
Text(context.l10n.saldoLabel); // atau konstanta terpusat
```

## R100.5 — Immutability via freezed

Model data MUST immutable. Pakai `freezed` untuk model + union types.
State yang di-expose Notifier MUST immutable. MUST NOT memutasi field
objek model langsung; buat salinan (`copyWith`).

## R100.6 — Disiplin null-safety

- MUST NOT pakai `!` (bang operator) kecuali sudah dibuktikan non-null
  di baris sebelumnya, dan sebutkan alasannya.
- Utamakan `?.`, `??`, dan pattern `if (x case final v?)`.
- Field opsional model (mis. `merchant`) bertipe nullable eksplisit.

## R100.7 — Disiplin async & Future

- Tiap `Future` MUST di-`await` atau sengaja di-`unawaited(...)`.
- MUST NOT ada `async` tanpa `await` di dalamnya.
- Operasi I/O (Drift, AI, file) MUST async; jangan blok UI thread.

## R100.8 — Penanganan error

- MUST NOT menelan exception diam-diam (`catch (_) {}` kosong dilarang).
- Kegagalan yang bisa ditangani dimodelkan eksplisit (mis. `Result`
  freezed union `success`/`failure`, atau `AsyncValue` Riverpod).
- Kegagalan parse AI MUST menghasilkan state error, MUST NOT crash
  (lihat R500.4).

**Salah:**
```dart
try { parse(json); } catch (_) {}
```
**Benar:**
```dart
try {
  return Result.success(parse(json));
} on FormatException catch (e) {
  return Result.failure('Gagal parse: $e');
}
```

## R100.9 — Urutan import

Urutan grup import (dipisah baris kosong): (1) `dart:*`, (2)
`package:flutter/*`, (3) `package:*` pihak ketiga, (4) import relatif
project (`package:sangu/*`). very_good_analysis meng-enforce ini —
jangan lawan.

## R100.10 — Larang `print`

MUST NOT pakai `print()` di kode produksi. Pakai logger terkontrol
atau `debugPrint` hanya saat debug. Log MUST NOT memuat data finansial
sensitif user (lihat R400).

## R100.11 — Konvensi Riverpod

- Pakai `riverpod_generator` (`@riverpod`), bukan provider manual,
  kecuali ada alasan tercatat.
- **Notifier/UI MUST NOT menyentuh Drift langsung.** Semua akses data
  lewat Repository (satu-satunya pintu ke data + AI).
- Aliran satu arah: UI → Notifier → Repository → Drift/AI (per
  `ARCHITECTURE.md`).

## R100.12 — Konvensi Drift

- Query yang menghidupi UI MUST dikembalikan sebagai `Stream` agar UI
  auto-update reaktif.
- Akses tabel lewat DAO, bukan query mentah tersebar di UI.
- Migrasi skema MUST punya langkah migrasi yang bisa dites.

## R100.13 — Arsitektur ringan

MUST NOT memakai CQRS, event sourcing, atau microservices. Simpel
dulu: feature-first + layering tipis (`presentation/` + `data/`) per
`ADR-001`. Repository memisahkan data dari UI — itu cukup.

## R100.14 — File hasil generate

`*.g.dart` dan `*.freezed.dart` MUST NOT diedit tangan. Ubah sumbernya
lalu jalankan `dart run build_runner`. File generate di-exclude dari
analyzer (lihat `analysis_options.yaml`).
