import 'package:core_sdk/utils/network_result.dart';
import 'package:graduation_project/base/data/datasources/common_datasource.dart';
import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/data/mappers/mappers.dart';
import 'package:graduation_project/features/backup/data/mappers/backup_mapper.dart';
import 'package:graduation_project/features/backup/data/stores/backup_store.dart';
import 'package:graduation_project/features/backup/data/stores/last_sync_requrest_store.dart';
import 'package:graduation_project/features/backup/domain/repositorires/backups_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:moor/moor.dart';
import 'package:photo_manager/photo_manager.dart';

const Duration _CASHE_DURATION = Duration(seconds: 10);

@LazySingleton(as: BackupsRepository)
class BackupsRepositoryImpl extends BackupsRepository {
  const BackupsRepositoryImpl(
    this._commonDataSource,
    this._backupsStore,
    this._backupMapper,
    this._lastSyncRequestStore,
  ) : super(_commonDataSource);

  final BackupMapper _backupMapper;

  final BackupsStore _backupsStore;

  final LastSyncRequestStore _lastSyncRequestStore;

  final CommonDataSource _commonDataSource;

  @override
  Stream<List<Backup>> observeActiveBackups() => _backupsStore.observeActiveBackups();

  @override
  Stream<List<Backup>> observePendingBackup() => _backupsStore.observePendingBackup();

  @override
  Stream<List<Backup>> observeUploadedBackup() => _backupsStore.observeUploadedBackup();
  @override
  Stream<List<Backup>> observeBackupsByStatus(BackupStatus status) => _backupsStore.observeBackupsByStatus(status);

  @override
  Future<void> addNewImages(List<AssetEntity> rawImages) async => _backupsStore.addNewImages(
        await _backupMapper.forList(rawImages),
      );

  @override
  Future<LastSyncRequest?> getLastSync() => _lastSyncRequestStore.getlastSyncRequest();

  @override
  Future<int> saveLastSync(DateTime date) =>
      _lastSyncRequestStore.saveLastSync(LastSyncRequestsCompanion(lastSyncDate: Value(date)));

  @override
  Future<bool> canStartSaveBackup() async {
    final lastSyncTimeObject = await getLastSync();
    final DateTime? lastSyncDate = lastSyncTimeObject?.lastSyncDate;

    return lastSyncDate == null || DateTime.now().difference(lastSyncDate) > _CASHE_DURATION;
  }

  @override
  Future<bool> canStartUploadBackup() async => !(await canStartSaveBackup());

  @override
  Future<NetworkResult<bool?>> uploadImages(List<Backup> images) {
    return _commonDataSource.uploadImages(images);
  }

  @override
  Future<void> updateBackups(List<Backup> images) => _backupsStore.updateBackups(images);
}
