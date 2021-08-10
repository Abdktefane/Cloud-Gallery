import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:injectable/injectable.dart';
import 'package:graduation_project/base/data/db/daos/entity_dao.dart';
import 'package:moor/moor.dart';

part 'backup_datasource.g.dart';

abstract class BackupsStore {
  const BackupsStore();

  Stream<List<Backup>> observeActiveBackups();

  Stream<List<Backup>> observePendingBackup();

  Stream<List<Backup>> observeUploadedBackup();

  Future<void> addNewImages(List<BackupsCompanion> rawImages);
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
  Future<void> addNewImages(List<BackupsCompanion> rawImages) => batch(
        (batch) => batch.insertAll(
          backups,
          rawImages,
          mode: InsertMode.insertOrIgnore,
        ),
      );
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
