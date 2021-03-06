import 'package:core_sdk/utils/extensions/future.dart';
import 'package:core_sdk/utils/network_result.dart';
import 'package:graduation_project/base/data/datasources/common_datasource.dart';
import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/data/mappers/mappers.dart';
import 'package:graduation_project/base/data/models/pagination_response.dart';
import 'package:graduation_project/base/data/models/search_result_model.dart';
import 'package:graduation_project/base/data/models/upload_model.dart';
import 'package:graduation_project/features/backup/data/mappers/backup_mapper.dart';
import 'package:graduation_project/features/backup/data/stores/backup_store.dart';
import 'package:graduation_project/features/backup/data/stores/last_sync_requrest_store.dart';
import 'package:graduation_project/features/backup/domain/repositorires/backups_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:moor/moor.dart';
import 'package:photo_manager/photo_manager.dart';

// const Duration _CASHE_DURATION = Duration(seconds: 10);
const Duration _CASHE_DURATION = Duration(hours: 12);

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

  // @override
  // Stream<List<Backup>> observeActiveBackups() => _backupsStore.observeActiveBackups();

  // @override
  // Stream<List<Backup>> observePendingBackup() => _backupsStore.observePendingBackup();

  // @override
  // Stream<List<Backup>> observeUploadedBackup() => _backupsStore.observeUploadedBackup();
  @override
  Stream<List<Backup>> observeBackupsByStatus({
    required BackupStatus status,
    required bool asc,
    required BackupModifier modifier,
    int? limit,
    bool withNeedRestore = false,
  }) =>
      _backupsStore.observeBackupsByStatus(
        asc: asc,
        modifier: modifier,
        status: status,
        limit: limit,
      );

  @override
  Future<void> addNewImages(
    List<AssetEntity> rawImages, {
    InsertMode insertMode = InsertMode.insertOrIgnore,
    BackupsCompanion Function(BackupsCompanion backup)? onConflict,

    // UpsertClause<Table, Backup> Function($BackupsTable)? onConflict,
  }) async =>
      _backupsStore.addNewImages(
        await _backupMapper.forList(rawImages),
        insertMode: insertMode,
        onConflict: onConflict,
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
  Future<NetworkResult<UploadModel?>> uploadImages(List<Backup> images) =>
      _commonDataSource.uploadImages(images).whenSuccessWrapped((res) => res!.data);

  @override
  Future<void> updateBackups(List<Backup> images) => _backupsStore.updateBackups(images);

  @override
  Stream<int> observeBackupsRows({required BackupStatus status, required BackupModifier modifier}) =>
      _backupsStore.observeBackupsRows(status: status, modifier: modifier);

  @override
  Stream<int> observePendingBackupsRows({required BackupModifier modifier}) =>
      _backupsStore.observePendingBackupsRows(modifier: modifier);

  @override
  Future<List<Backup>> getBackupsByStatus({
    required BackupStatus status,
    required bool asc,
    required BackupModifier modifier,
    int? limit,
    bool withNeedRestore = false,
  }) =>
      _backupsStore.getBackupsByStatus(
        status: status,
        asc: asc,
        modifier: modifier,
        limit: limit,
        withNeedRestore: withNeedRestore,
      );

  @override
  Future<List<Backup>> getPendingImages({
    required bool asc,
    required BackupModifier modifier,
    int? limit,
    bool withNeedRestore = false,
  }) =>
      _backupsStore.getPendingImages(
        withNeedRestore: withNeedRestore,
        asc: asc,
        modifier: modifier,
        limit: limit,
      );

  @override
  Future<NetworkResult<UploadModel?>> changeModifire({
    required BackupModifier modifier,
    required String serverPath,
  }) =>
      _commonDataSource
          .changeModifire(modifier: modifier, serverPath: serverPath)
          .whenSuccessWrapped((res) => res!.data);

  @override
  Future<NetworkResult<PaginationResponse<SearchResultModel>?>> search({
    required int page,
    required BackupModifier modifier,
    required String? query,
    required String? path,
    required String? serverPath,
  }) =>
      _commonDataSource
          .search(page: page, modifier: modifier, query: query, path: path, serverPath: serverPath)
          .whenSuccessWrapped((res) => res!.data);

  @override
  Future<NetworkResult<PaginationResponse<BackupsCompanion>?>> getServerImages({
    required int page,
    required int pageSize,
    required BackupModifier modifier,
    DateTime? lastSync,
  }) =>
      _commonDataSource
          .getServerImages(
            pageSize: pageSize,
            page: page,
            modifier: modifier,
            lastSync: lastSync,
          )
          .whenSuccessWrapped((res) => res!.data);

  @override
  Future<NetworkResult<bool?>> downloadFile({
    required String serverPath,
    required String localStoragePath,
  }) =>
      _commonDataSource.downloadFile(serverPath: serverPath, localStoragePath: localStoragePath);
}
