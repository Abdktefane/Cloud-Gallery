import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:injectable/injectable.dart';
import 'package:graduation_project/base/data/db/daos/entity_dao.dart';
import 'package:moor/moor.dart';
import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
part 'backup_store.g.dart';

Function eq = const ListEquality().equals;

abstract class BackupsStore {
  const BackupsStore();

  // Stream<List<Backup>> observeActiveBackups();

  // Stream<List<Backup>> observePendingBackup();

  // Stream<List<Backup>> observeUploadedBackup();

  Stream<List<Backup>> observeBackupsByStatus({
    required BackupStatus status,
    required bool asc,
    required BackupModifier modifier,
    int? limit,
    bool withNeedRestore = false,
  });

  Stream<List<Backup>> observePendingBackups({
    required bool asc,
    required BackupModifier modifier,
    int? limit,
    bool withNeedRestore = false,
  });

  Future<void> addNewImages(
    List<BackupsCompanion> rawImages, {
    InsertMode insertMode = InsertMode.insertOrIgnore,
    BackupsCompanion Function(BackupsCompanion backup)? onConflict,
    // UpsertClause<Table, Backup> Function($BackupsTable)? onConflict,
  });

  Future<void> updateBackups(List<Backup> images);

  Future<List<Backup>> getAll();

  // Future<void> moveUploadingToPending();

  Stream<int> observeBackupsRows({required BackupStatus status, required BackupModifier modifier});

  Stream<int> observePendingBackupsRows({required BackupModifier modifier});

  Stream<int> observeNeedRestoreBackupsRows({required BackupModifier modifier});

  Future<List<Backup>> getBackupsByStatus({
    required BackupStatus status,
    required bool asc,
    required BackupModifier modifier,
    int? limit,
    bool withNeedRestore = false,
  });

  Future<void> makeAllNeedRestore();

  Future<List<Backup>> getPendingImages({
    required bool asc,
    required BackupModifier modifier,
    int? limit,
    bool withNeedRestore = false,
  });

  Stream<List<Backup>> observeNeedRestoreBackups({
    required bool asc,
    required BackupModifier modifier,
    int? limit,
  });
}

@Singleton(as: BackupsStore)
@UseDao(tables: <Type>[Backups])
class BackupDao extends EntityDao<Backups, Backup, GraduateDB> with _$BackupDaoMixin implements BackupsStore {
  BackupDao(GraduateDB db) : super(db, db.backups);

  @override
  Future<List<Backup>> getAll() => super.getAll();

  @override
  Future<void> addNewImages(
    List<BackupsCompanion> rawImages, {
    InsertMode insertMode = InsertMode.insertOrIgnore,
    BackupsCompanion Function(BackupsCompanion backup)? onConflict,
    // UpsertClause<Table, Backup> Function($BackupsTable)? onConflict,
  }) async {
    // print('android db rows');
    // print(rawImages);
    await batch((batch) {
      for (final row in rawImages) {
        batch.insert(
          backups,
          row,
          mode: insertMode,
          onConflict: onConflict == null
              ? null
              : UpsertMultiple([
                  DoUpdate((_) => onConflict(row)),
                  DoUpdate((_) => onConflict(row), target: [backups.title]),
                ]),
        );
      }
    });
    print('after insert new images from android db');
    // print(await getAll());
  }
  //   (batch) => batch.insertAll(
  //     backups,
  //     rawImages,
  //     mode: insertMode,
  //     onConflict: onConflict?.call(backups),
  //   ),
  // );

  @override
  Stream<List<Backup>> observeBackupsByStatus({
    required BackupStatus status,
    required bool asc,
    required BackupModifier modifier,
    int? limit,
    bool withNeedRestore = false,
  }) {
    final query = select(backups)
      ..where(
        (it) =>
            it.status.equals(status.index) &
            it.modifier.equals(modifier.index) &
            // it.needRestore.equals(withNeedRestore) &
            it.serverPath.isNotNull(),
      )
      ..orderBy(
        [(it) => OrderingTerm(expression: it.createdDate, mode: asc ? OrderingMode.asc : OrderingMode.desc)],
      );
    // ..limit(limit!);

    if (limit != null && limit != 0) {
      query.limit(limit);
    }

    return query.watch().distinct((oldImages, newImages) {
      final result = eq(oldImages, newImages);
      return result;
    });
  }

  @override
  Stream<List<Backup>> observePendingBackups({
    required bool asc,
    required BackupModifier modifier,
    int? limit,
    bool withNeedRestore = false,
  }) {
    final query = select(backups)
      ..where(
        (it) => it.serverPath.isNull() & it.modifier.equals(modifier.index) & it.needRestore.equals(withNeedRestore),
      )
      ..orderBy(
        [(it) => OrderingTerm(expression: it.createdDate, mode: asc ? OrderingMode.asc : OrderingMode.desc)],
      );
    // ..limit(limit!);

    if (limit != null && limit != 0) {
      query.limit(limit);
    }

    return query.watch().distinct((oldImages, newImages) {
      final result = eq(oldImages, newImages);
      return result;
    });
  }

  @override
  Stream<List<Backup>> observeNeedRestoreBackups({
    required bool asc,
    required BackupModifier modifier,
    int? limit,
  }) {
    final query = select(backups)
      ..where(
        (it) => it.needRestore.equals(true) & it.modifier.equals(modifier.index) & it.serverPath.isNotNull(),
      )
      ..orderBy(
        [(it) => OrderingTerm(expression: it.createdDate, mode: asc ? OrderingMode.asc : OrderingMode.desc)],
      );
    // ..limit(limit!);

    if (limit != null && limit != 0) {
      query.limit(limit);
    }

    return query.watch().distinct((oldImages, newImages) {
      final result = eq(oldImages, newImages);
      return result;
    });
  }

  @override
  Future<List<Backup>> getBackupsByStatus({
    required BackupStatus status,
    required bool asc,
    required BackupModifier modifier,
    int? limit,
    bool withNeedRestore = false,
  }) {
    final query = select(backups)
      ..where(
        (it) =>
            it.status.equals(status.index) &
            it.modifier.equals(modifier.index) &
            it.needRestore.equals(withNeedRestore),
      )
      ..orderBy(
        [(it) => OrderingTerm(expression: it.createdDate, mode: asc ? OrderingMode.asc : OrderingMode.desc)],
      );

    if (limit != null && limit != 0) {
      query.limit(limit);
    }

    return query.get();
  }

  @override
  Future<List<Backup>> getPendingImages({
    required bool asc,
    required BackupModifier modifier,
    int? limit,
    bool withNeedRestore = false,
  }) {
    final query = select(backups)
      ..where(
        (it) => it.serverPath.isNull() & it.modifier.equals(modifier.index) & it.needRestore.equals(withNeedRestore),
      )
      ..orderBy(
        [(it) => OrderingTerm(expression: it.createdDate, mode: asc ? OrderingMode.asc : OrderingMode.desc)],
      );

    if (limit != null && limit != 0) {
      query.limit(limit);
    }

    return query.get();
  }

  @override
  Stream<int> observeBackupsRows({
    required BackupStatus status,
    required BackupModifier modifier,
  }) {
    final countExpr = countAll(
      filter: backups.status.equals(status.index) &
          backups.modifier.equals(modifier.index) &
          backups.serverPath.isNotNull(),
    );
    return (selectOnly(backups)..addColumns([countExpr])).map((it) => it.read(countExpr)).watchSingle();
  }

  @override
  Stream<int> observePendingBackupsRows({required BackupModifier modifier}) {
    final countExpr = countAll(filter: backups.serverPath.isNull() & backups.modifier.equals(modifier.index));
    return (selectOnly(backups)..addColumns([countExpr])).map((it) => it.read(countExpr)).watchSingle();
  }

  @override
  Stream<int> observeNeedRestoreBackupsRows({required BackupModifier modifier}) {
    final countExpr = countAll(
      filter:
          backups.needRestore.equals(true) & backups.modifier.equals(modifier.index) & backups.serverPath.isNotNull(),
    );
    return (selectOnly(backups)..addColumns([countExpr])).map((it) => it.read(countExpr)).watchSingle();
  }

  @override
  Future<void> updateBackups(List<Backup> images) =>
      batch((Batch batch) => batch.insertAllOnConflictUpdate(backups, images));

  @override
  Future<void> makeAllNeedRestore() => update(backups).write(const BackupsCompanion(needRestore: Value(true)));
}
