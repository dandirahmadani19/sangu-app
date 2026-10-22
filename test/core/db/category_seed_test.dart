import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sangu/core/db/database.dart';
import 'package:sangu/core/db/tables.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('kategori induk expense & income ter-seed otomatis', () async {
    final rows = await db.select(db.categories).get();
    final topLevel = rows.where((r) => r.parentId == null).map((r) => r.name);

    expect(
      topLevel,
      containsAll(<String>[
        'Makan & Minum',
        'Transportasi',
        'Belanja',
        'Tagihan & Utilitas',
        'Kesehatan',
        'Hiburan',
        'Pendidikan',
        'Rumah',
        'Keluarga & Sosial',
        'Keuangan',
        'Lainnya',
        'Gaji',
        'Usaha/Freelance',
        'Investasi',
      ]),
    );
  });

  test('subkategori "Bensin/BBM" berelasi ke induk "Transportasi"', () async {
    final rows = await db.select(db.categories).get();
    final transportasi = rows.singleWhere(
      (r) => r.name == 'Transportasi' && r.parentId == null,
    );
    final bensin = rows.singleWhere((r) => r.name == 'Bensin/BBM');

    expect(bensin.parentId, transportasi.id);
    expect(bensin.type, TransactionType.expense);
  });

  test('semua id kategori unik', () async {
    final rows = await db.select(db.categories).get();
    final ids = rows.map((r) => r.id).toSet();

    expect(ids.length, rows.length);
  });
}
