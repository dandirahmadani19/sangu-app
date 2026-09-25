import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'package:sangu/core/db/tables.dart';

part 'database.g.dart';

/// Database Drift utama Sangu (transaksi + taksonomi kategori).
@DriftDatabase(tables: [Transactions, Categories])
class AppDatabase extends _$AppDatabase {
  /// Buka koneksi default (file SQLite `sangu_db`).
  AppDatabase() : super(_openConnection());

  /// Konstruktor untuk test — inject executor in-memory/custom.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration =>
      MigrationStrategy(onCreate: (migrator) => migrator.createAll());

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'sangu_db');
  }
}
