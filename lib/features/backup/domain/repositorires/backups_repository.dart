import 'package:core_sdk/utils/network_result.dart';
import 'package:graduation_project/base/data/datasources/common_datasource.dart';
import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/data/models/upload_model.dart';
import 'package:graduation_project/base/domain/repositories/base_repository.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class BackupsRepository extends BaseRepository {
  const BackupsRepository(
    CommonDataSource backupsDataSource,
  ) : super(backupsDataSource);

  Stream<List<Backup>> observeActiveBackups();

  Stream<List<Backup>> observePendingBackup();

  Stream<List<Backup>> observeUploadedBackup();

  Stream<List<Backup>> observeBackupsByStatus({
    required BackupStatus status,
    required bool asc,
    required BackupModifier modifier,
    int? limit,
  });

  Future<void> addNewImages(List<AssetEntity> rawImages);

  Future<LastSyncRequest?> getLastSync();

  Future<int> saveLastSync(DateTime date);

  Future<bool> canStartSaveBackup();

  Future<bool> canStartUploadBackup();

  Future<NetworkResult<UploadModel?>> uploadImages(List<Backup> images);

  Future<void> updateBackups(List<Backup> images);

  Stream<int> observeBackupsRows({required BackupStatus status, required BackupModifier modifier});

  Future<List<Backup>> getBackupsByStatus({
    required BackupStatus status,
    required bool asc,
    required BackupModifier modifier,
    int? limit,
  });

  Future<NetworkResult<UploadModel?>> changeModifire({
    required BackupModifier modifier,
    required String serverPath,
  });
}
