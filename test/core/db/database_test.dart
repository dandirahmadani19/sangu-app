import 'package:drift/drift.dart';
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

  test('insert kategori induk lalu subkategori → tersimpan', () async {
    await db
        .into(db.categories)
        .insert(
          CategoriesCompanion.insert(
            id: 'cat_transport',
            name: 'Transportasi',
            type: TransactionType.expense,
          ),
        );
    await db
        .into(db.categories)
        .insert(
          CategoriesCompanion.insert(
            id: 'cat_bensin',
            name: 'Bensin/BBM',
            type: TransactionType.expense,
            parentId: const Value('cat_transport'),
          ),
        );

    final rows = await db.select(db.categories).get();
    expect(rows, hasLength(2));
    expect(
      rows.firstWhere((r) => r.id == 'cat_bensin').parentId,
      'cat_transport',
    );
  });

  test('insert transaksi tanpa subCategory → default "Lainnya"', () async {
    await db
        .into(db.transactions)
        .insert(
          TransactionsCompanion.insert(
            id: 'tx_1',
            type: TransactionType.expense,
            amount: 40000,
            category: 'Transportasi',
            description: 'Isi Pertalite',
            occurredAt: DateTime(2026, 9, 25),
            source: TransactionSource.manual,
            createdAt: DateTime(2026, 9, 25),
            updatedAt: DateTime(2026, 9, 25),
          ),
        );

    final tx = await db.select(db.transactions).getSingle();
    expect(tx.subCategory, 'Lainnya');
    expect(tx.amount, isA<int>()); // R100.3
    expect(tx.needsReview, isFalse);
  });
}
