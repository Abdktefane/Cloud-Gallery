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

  Stream<List<Backup>> observeActiveBackups();

  Stream<List<Backup>> observePendingBackup();

  Stream<List<Backup>> observeUploadedBackup();

  Stream<List<Backup>> observeBackupsByStatus({
    required BackupStatus status,
    required bool asc,
    required BackupModifier modifier,
    int? limit,
  });

  Future<void> addNewImages(List<BackupsCompanion> rawImages, {InsertMode insertMode = InsertMode.insertOrIgnore});

  Future<void> updateBackups(List<Backup> images);

  Future<void> moveUploadingToPending();

  Stream<int> observeBackupsRows({required BackupStatus status, required BackupModifier modifier});

  Future<List<Backup>> getBackupsByStatus({
    required BackupStatus status,
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
  Stream<List<Backup>> observeActiveBackups() => (select(backups)
        ..where((it) => it.status.equals(BackupStatus.PENDING.index) | it.status.equals(BackupStatus.UPLOADING.index)))
      .watch();

  @override
  Stream<List<Backup>> observePendingBackup() =>
      (select(backups)..where((it) => it.status.equals(BackupStatus.PENDING.index))).watch();

  @override
  Stream<List<Backup>> observeUploadedBackup() =>
      (select(backups)..where((it) => it.status.equals(BackupStatus.UPLOADED.index))).watch();

  @override
  Future<void> addNewImages(
    List<BackupsCompanion> rawImages, {
    InsertMode insertMode = InsertMode.insertOrIgnore,
  }) =>
      batch(
        (batch) => batch.insertAll(
          backups,
          rawImages,
          mode: insertMode,
        ),
      );

  @override
  Stream<List<Backup>> observeBackupsByStatus({
    required BackupStatus status,
    required bool asc,
    required BackupModifier modifier,
    int? limit,
  }) {
    final query = select(backups)
      ..where((it) => it.status.equals(status.index) & it.modifier.equals(modifier.index))
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
  }) {
    final query = select(backups)
      ..where((it) => it.status.equals(status.index) & it.modifier.equals(modifier.index))
      ..orderBy(
        [(it) => OrderingTerm(expression: it.createdDate, mode: asc ? OrderingMode.asc : OrderingMode.desc)],
      );
    // ..limit(limit!);

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
    final countExpr = countAll(filter: backups.status.equals(status.index) & backups.modifier.equals(modifier.index));
    return (selectOnly(backups)..addColumns([countExpr])).map((it) => it.read(countExpr)).watchSingle();
  }

  @override
  Future<void> updateBackups(List<Backup> images) =>
      batch((Batch batch) => batch.insertAllOnConflictUpdate(backups, images));

  @override
  Future<void> moveUploadingToPending() =>
      (update(backups)..where((t) => t.status.equals(BackupStatus.UPLOADING.index))).write(const BackupsCompanion(
        status: Value(BackupStatus.PENDING),
      ));
}

// @LazySingleton(as: BackupsStore)
// class BackupsStoreImpl extends BackupsStore {
//   const BackupsStoreImpl(this._dao);

//   final BackupDao _dao;

//   @override
//   Stream<List<Backup>> observeActiveBackups() => _dao.observeActiveBackups();

//   @override
//   Stream<List<Backup>> observePendingBackup() => _dao.observePendingBackup();

//   @override
//   Stream<List<Backup>> observeUploadedBackup() => _dao.observeUploadedBackup();

//   @override
//   Future<void> addNewImages(List<BackupsCompanion> rawImages) => _dao.addNewImages(rawImages);
// }

