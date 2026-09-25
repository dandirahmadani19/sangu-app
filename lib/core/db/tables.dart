import 'package:drift/drift.dart';

/// Jenis transaksi: pengeluaran atau pemasukan. Dipakai juga di
/// `Categories.type` (kategori/subkategori selalu milik satu sisi).
enum TransactionType {
  /// Pengeluaran.
  expense,

  /// Pemasukan.
  income,
}

/// Asal input transaksi (ARCHITECTURE.md#data-model).
enum TransactionSource {
  /// Diketik manual lewat form.
  manual,

  /// Diucapkan lewat voice-to-text.
  voice,

  /// Diketik bebas lalu diparse AI.
  nlText,

  /// Difoto dari struk (OCR on-device + Gemini vision).
  receiptPhoto,

  /// Diterima lewat OS share-sheet dari app lain.
  shareSheet,

  /// Ditempel dari clipboard.
  clipboard,
}

/// Tabel taksonomi kategori + subkategori dalam satu tabel:
/// `parentId == null` → kategori induk, `parentId` terisi → subkategori
/// (ARCHITECTURE.md baris 125-129).
@DataClassName('Category')
class Categories extends Table {
  /// ID unik kategori/subkategori (uuid).
  TextColumn get id => text()();

  /// Nama kategori/subkategori, mis. "Transportasi" atau "Bensin/BBM".
  TextColumn get name => text()();

  /// Sisi expense atau income.
  TextColumn get type => textEnum<TransactionType>()();

  /// ID kategori induk; null berarti baris ini kategori induk sendiri.
  TextColumn get parentId => text().nullable().references(Categories, #id)();

  /// Primary key tabel.
  @override
  Set<Column> get primaryKey => {id};
}

/// Tabel transaksi keuangan pengguna.
@DataClassName('Transaction')
class Transactions extends Table {
  /// ID unik transaksi (uuid).
  TextColumn get id => text()();

  /// Sisi expense atau income.
  TextColumn get type => textEnum<TransactionType>()();

  /// Nominal dalam Rupiah, bukan double (R100.3).
  IntColumn get amount => integer()();

  /// Nama kategori, dari taksonomi `Categories`.
  TextColumn get category => text()();

  /// Nama subkategori; default "Lainnya" bila tak diisi.
  TextColumn get subCategory => text().withDefault(const Constant('Lainnya'))();

  /// Deskripsi ringkas transaksi.
  TextColumn get description => text()();

  /// Nama toko/brand/tempat; opsional.
  TextColumn get merchant => text().nullable()();

  /// Catatan bebas tambahan; opsional.
  TextColumn get note => text().nullable()();

  /// Waktu transaksi terjadi.
  DateTimeColumn get occurredAt => dateTime()();

  /// Asal input transaksi.
  TextColumn get source => textEnum<TransactionSource>()();

  /// Skor keyakinan AI (0..1); null bila bukan hasil AI.
  RealColumn get aiConfidence => real().nullable()();

  /// True bila AI ragu dan butuh review manual.
  BoolColumn get needsReview => boolean().withDefault(const Constant(false))();

  /// ID dompet; v1 hanya dompet tunggal, opsional.
  TextColumn get accountId => text().nullable()();

  /// Waktu baris dibuat.
  DateTimeColumn get createdAt => dateTime()();

  /// Waktu baris terakhir diubah.
  DateTimeColumn get updatedAt => dateTime()();

  /// Primary key tabel.
  @override
  Set<Column> get primaryKey => {id};
}
