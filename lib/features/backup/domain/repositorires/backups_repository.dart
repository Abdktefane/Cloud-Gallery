import 'package:core_sdk/utils/network_result.dart';
import 'package:graduation_project/base/data/datasources/common_datasource.dart';
import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/domain/repositories/base_repository.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class BackupsRepository extends BaseRepository {
  const BackupsRepository(
    CommonDataSource backupsDataSource,
  ) : super(backupsDataSource);

  Stream<List<Backup>> observeActiveBackups();

  Stream<List<Backup>> observePendingBackup();

  Stream<List<Backup>> observeUploadedBackup();

  Stream<List<Backup>> observeBackupsByStatus(BackupStatus status);

  Future<void> addNewImages(List<AssetEntity> rawImages);

  Future<LastSyncRequest?> getLastSync();

  Future<int> saveLastSync(DateTime date);

  Future<bool> canStartSaveBackup();

  Future<bool> canStartUploadBackup();

  Future<NetworkResult<bool?>> uploadImages(List<Backup> images);

  Future<void> updateBackups(List<Backup> images);
}
