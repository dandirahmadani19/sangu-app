# Plan — T-010: Skema Drift (Transaction, Category, SubCategory)

**Status:** DRAFT — menunggu eksekusi developer (proposal sudah
dikeluarkan di sesi, belum di-apply).
**Rule dasar:** R900 (advisor-only), R100.2/.3/.9/.12/.13, R300.1/.5,
ADR-003.
**Spec asal:** `docs/MVP.md#T-010` (Deps: T-004 ✓ · Est: M ·
AC-F1.1/1.4 · Zona: runtime).

## 1. Restate task

Buat skema Drift untuk transaksi & taksonomi kategori sesuai
`docs/ARCHITECTURE.md#data-model`, siap dipakai T-011 (seed) dan T-012
(repository).

## 2. Asumsi (dikonfirmasi via diskusi sesi ini)

- `ARCHITECTURE.md` mendokumentasikan **satu tabel** `Category` dengan
  `parentId` self-reference nullable untuk Category *dan* SubCategory
  sekaligus (`parentId == null` → kategori induk, terisi → subkategori)
  — bukan dua tabel fisik terpisah. Judul T-010 dibaca sebagai 3
  *konsep*, diwujudkan dalam **2 tabel Drift** (`Transactions`,
  `Categories`).
- `Transaction.category`/`subCategory` tetap `String` (nama, bukan FK
  id) — sesuai dokumen, karena output AI juga berupa nama string.

## 3. File yang disentuh + zona

| Path | Aksi | Zona | Alasan |
|---|---|---|---|
| `lib/core/db/tables.dart` | CREATE | runtime (advisor-only) | Definisi tabel `Transactions` & `Categories` + enum |
| `lib/core/db/database.dart` | CREATE | runtime (advisor-only) | `AppDatabase` (`@DriftDatabase`), koneksi via `drift_flutter` |
| `test/core/db/database_test.dart` | CREATE | runtime (advisor-only) | Smoke test insert/select (R300.1, R100.12) |

Tidak disentuh: seed data taksonomi (T-011), repository/DAO (T-012),
`pubspec.yaml` (dependency sudah ada dari T-003).

## 4. Skema (final, sudah di-proposal-kan)

### `Categories`
```dart
enum TransactionType { expense, income }

@DataClassName('Category')
class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => textEnum<TransactionType>()();
  TextColumn get parentId => text().nullable().references(Categories, #id)();

  @override
  Set<Column> get primaryKey => {id};
}
```

### `Transactions`
```dart
enum TransactionSource {
  manual, voice, nlText, receiptPhoto, shareSheet, clipboard,
}

@DataClassName('Transaction')
class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get type => textEnum<TransactionType>()();
  IntColumn get amount => integer()(); // Rupiah, R100.3
  TextColumn get category => text()();
  TextColumn get subCategory => text().withDefault(const Constant('Lainnya'))();
  TextColumn get description => text()();
  TextColumn get merchant => text().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get source => textEnum<TransactionSource>()();
  RealColumn get aiConfidence => real().nullable()();
  BoolColumn get needsReview => boolean().withDefault(const Constant(false))();
  TextColumn get accountId => text().nullable()(); // v1 dompet tunggal
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

`AppDatabase` (`lib/core/db/database.dart`): `@DriftDatabase(tables:
[Transactions, Categories])`, koneksi `driftDatabase(name: 'sangu_db')`
dari `drift_flutter`, `schemaVersion = 1`, `MigrationStrategy(onCreate:
(m) => m.createAll())`.

Detail file lengkap (termasuk test) ada di transkrip sesi proposal —
diringkas di sini supaya sesi lanjutan tak perlu scroll transkrip lama.

## 5. Verifikasi

```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test test/core/db/database_test.dart
```

**Expected:** codegen sukses, `flutter analyze` 0 issues, 2/2 test
passed.

## 6. Keputusan UX turunan (untuk T-014, bukan T-010)

Saat diskusi, developer menunjukkan referensi UI app lain (screenshot
"Add Transaction") yang menampilkan kategori sebagai **1 level chip
flat**, berbeda dari taksonomi 2-level di `ARCHITECTURE.md`
(kategori → subkategori). Semua field di referensi itu sudah
tertampung skema ini tanpa kolom baru (title → `description`, wallet
dropdown → `accountId`, description optional → `note`, category chip
→ `category`).

**Keputusan (developer, sesi ini): Opsi A — tetap taksonomi 2-level**,
dengan UX progresif: user pilih chip kategori induk dulu (mis.
"Transportasi"), lalu baris chip subkategori baru muncul (mis.
"Bensin/BBM", "Ojek/Taksi Online", ...) — bukan dua baris chip
independen sekaligus seperti referensi. `subCategory` default
"Lainnya" kalau user skip. Konsisten dengan taksonomi yang sudah
dikunci di `ARCHITECTURE.md`, dan tetap dipakai penuh oleh hasil parse
AI (voice/struk/share-sheet).

**Alasan menolak Opsi B** (flatten jadi 1 level di form manual): akan
membuat data manual kurang granular dibanding data hasil AI, dan
taksonomi 2-level sudah ADR-locked — bukan hal yang mau diubah tanpa
ADR baru (R000.5).

**Dampak ke task depan:** catatan ini jadi acuan wajib saat menyusun
plan T-014 (form input manual lengkap + validasi) — jangan desain
ulang dari nol, langsung pakai pola progresif 2-level di atas.

## 7. Risks / Unknowns

- Belum ada test/constraint bahwa subkategori harus searah `type`
  dengan kategori induknya (mis. subkategori expense di bawah kategori
  income) — itu validasi level repository (T-012), bukan skema.

## Rollback

Hapus 3 file yang dibuat + `lib/core/db/*.g.dart` hasil generate;
belum ada migrasi database nyata yang jalan (masih tahap skema, belum
ada data user).
