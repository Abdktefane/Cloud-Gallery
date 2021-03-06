import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/db/entities/last_sync_requests.dart';
import 'package:moor/backends.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'entities/tokens.dart';

part 'graduate_db.g.dart';

const int databaseVersion = 1;
const String databaseFileName = 'graduate_db.sqlite';

@UseMoor(tables: [Backups, LastSyncRequests, Tokens])
class GraduateDB extends _$GraduateDB {
  // GraduateDB({QueryExecutor database}) : super(database ?? _openConnection());
  GraduateDB() : super(_openConnection());

  GraduateDB.connect(DatabaseConnection connection) : super.connect(connection);

  @override
  MigrationStrategy get migration => MigrationStrategy(beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      });

  @override
  int get schemaVersion => databaseVersion;

  Future<void> deleteEverything() {
    return transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, databaseFileName));
    return VmDatabase(file, logStatements: kDebugMode);
  });
}
