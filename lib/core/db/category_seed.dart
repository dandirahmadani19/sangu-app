import 'package:drift/drift.dart';

import 'package:sangu/core/db/database.dart';
import 'package:sangu/core/db/tables.dart';

/// Satu kategori induk + daftar nama subkategorinya, untuk seed awal.
class _CategorySeed {
  const _CategorySeed(this.name, this.subCategories);

  final String name;
  final List<String> subCategories;
}

/// Taksonomi expense — ARCHITECTURE.md baris 131-142.
const _expenseSeed = <_CategorySeed>[
  _CategorySeed('Makan & Minum', [
    'Warung/Rumah Makan',
    'Restoran',
    'Kopi & Cafe',
    'Jajan/Snack',
    'Belanja Dapur',
    'Delivery',
  ]),
  _CategorySeed('Transportasi', [
    'Bensin/BBM',
    'Ojek/Taksi Online',
    'Parkir',
    'Tol',
    'Transportasi Umum',
    'Servis Kendaraan',
  ]),
  _CategorySeed('Belanja', [
    'Kebutuhan Harian',
    'Elektronik',
    'Pakaian',
    'Rumah Tangga',
    'Online Shopping',
  ]),
  _CategorySeed('Tagihan & Utilitas', [
    'Listrik',
    'Air',
    'Internet',
    'Pulsa/Data',
    'Langganan',
    'BPJS/Asuransi',
  ]),
  _CategorySeed('Kesehatan', [
    'Obat/Apotek',
    'Dokter/Klinik',
    'Rumah Sakit',
    'Olahraga/Gym',
  ]),
  _CategorySeed('Hiburan', ['Nonton', 'Game', 'Traveling', 'Hobi']),
  _CategorySeed('Pendidikan', ['Kursus', 'Buku', 'Sekolah/Kuliah']),
  _CategorySeed('Rumah', ['Sewa/Kontrakan', 'Perabot', 'Perbaikan']),
  _CategorySeed('Keluarga & Sosial', [
    'Hadiah',
    'Donasi',
    'Zakat/Sedekah',
    'Kirim Keluarga',
  ]),
  _CategorySeed('Keuangan', ['Tabungan', 'Investasi', 'Biaya Admin']),
  _CategorySeed('Lainnya', []),
];

/// Taksonomi income — ARCHITECTURE.md baris 144.
const _incomeSeed = <_CategorySeed>[
  _CategorySeed('Gaji', ['Pokok', 'Bonus', 'THR', 'Lembur']),
  _CategorySeed('Usaha/Freelance', ['Proyek', 'Jualan']),
  _CategorySeed('Investasi', ['Dividen', 'Bunga', 'Capital Gain']),
  _CategorySeed('Lainnya', ['Hadiah', 'Refund', 'Cashback']),
];

/// Ubah nama kategori jadi id stabil, mis. "Makan & Minum" →
/// "makan_minum". Non-alfanumerik jadi underscore tunggal.
String _slug(String name) {
  final cleaned = name
      .toLowerCase()
      .replaceAll(RegExp('[^a-z0-9]+'), '_')
      .replaceAll(RegExp('_+'), '_');
  return cleaned.replaceAll(RegExp(r'^_|_$'), '');
}

/// Insert taksonomi kategori awal ke tabel `Categories`. Dipanggil
/// sekali dari `MigrationStrategy.onCreate` (AppDatabase) — bukan
/// idempotent, jangan panggil di luar itu.
Future<void> seedCategories(AppDatabase db) async {
  final rows = <CategoriesCompanion>[];

  void addSeed(TransactionType type, List<_CategorySeed> seeds) {
    for (final seed in seeds) {
      final parentId = '${type.name}_${_slug(seed.name)}';
      rows.add(
        CategoriesCompanion.insert(id: parentId, name: seed.name, type: type),
      );
      for (final subName in seed.subCategories) {
        rows.add(
          CategoriesCompanion.insert(
            id: '${parentId}_${_slug(subName)}',
            name: subName,
            type: type,
            parentId: Value(parentId),
          ),
        );
      }
    }
  }

  addSeed(TransactionType.expense, _expenseSeed);
  addSeed(TransactionType.income, _incomeSeed);

  await db.batch((batch) => batch.insertAll(db.categories, rows));
}
