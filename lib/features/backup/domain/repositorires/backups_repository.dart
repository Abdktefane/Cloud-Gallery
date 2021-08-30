import 'package:core_sdk/utils/network_result.dart';
import 'package:graduation_project/base/data/datasources/common_datasource.dart';
import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/data/models/pagination_response.dart';
import 'package:graduation_project/base/data/models/search_result_model.dart';
import 'package:graduation_project/base/data/models/upload_model.dart';
import 'package:graduation_project/base/domain/repositories/base_repository.dart';
import 'package:moor/moor.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class BackupsRepository extends BaseRepository {
  const BackupsRepository(
    CommonDataSource backupsDataSource,
  ) : super(backupsDataSource);

  Stream<List<Backup>> observeBackupsByStatus({
    required BackupStatus status,
    required bool asc,
    required BackupModifier modifier,
    int? limit,
    bool withNeedRestore = false,
  });

  Future<void> addNewImages(
    List<AssetEntity> rawImages, {
    InsertMode insertMode = InsertMode.insertOrIgnore,
    BackupsCompanion Function(BackupsCompanion backup)? onConflict,
    // UpsertClause<Table, Backup> Function($BackupsTable)? onConflict,
  });

  Future<LastSyncRequest?> getLastSync();

  Future<int> saveLastSync(DateTime date);

  Future<bool> canStartSaveBackup();

  Future<bool> canStartUploadBackup();

  Future<NetworkResult<UploadModel?>> uploadImages(List<Backup> images);

  Future<void> updateBackups(List<Backup> images);

  Stream<int> observeBackupsRows({required BackupStatus status, required BackupModifier modifier});

  Stream<int> observePendingBackupsRows({required BackupModifier modifier});

  Future<List<Backup>> getBackupsByStatus({
    required BackupStatus status,
    required bool asc,
    required BackupModifier modifier,
    int? limit,
    bool withNeedRestore = false,
  });

  Future<List<Backup>> getPendingImages({
    required bool asc,
    required BackupModifier modifier,
    int? limit,
    bool withNeedRestore = false,
  });

  Future<NetworkResult<UploadModel?>> changeModifire({
    required BackupModifier modifier,
    required String serverPath,
  });

  Future<NetworkResult<PaginationResponse<SearchResultModel>?>> search({
    required int page,
    required BackupModifier modifier,
    required String? query,
    required String? path,
    required String? serverPath,
  });

  Future<NetworkResult<PaginationResponse<BackupsCompanion>?>> getServerImages({
    required int pageSize,
    required int page,
    required BackupModifier modifier,
    DateTime? lastSync,
  });

  Future<NetworkResult<bool?>> downloadFile({
    required String serverPath,
    required String localStoragePath,
  });
}
