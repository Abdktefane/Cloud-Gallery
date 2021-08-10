import 'package:graduation_project/base/data/datasources/common_datasource.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/data/mappers/mappers.dart';
import 'package:graduation_project/features/backup/data/mappers/backup_mapper.dart';
import 'package:graduation_project/features/backup/data/stores/backup_datasource.dart';
import 'package:graduation_project/features/backup/domain/repositorires/backups_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';

@LazySingleton(as: BackupsRepository)
class BackupsRepositoryImpl extends BackupsRepository {
  const BackupsRepositoryImpl(
    CommonDataSource commonDataSource,
    this._backupsStore,
    this._backupMapper,
  ) : super(commonDataSource);

  final BackupMapper _backupMapper;

  final BackupsStore _backupsStore;

  @override
  Stream<List<Backup>> observeActiveBackups() => _backupsStore.observeActiveBackups();

  @override
  Stream<List<Backup>> observePendingBackup() => _backupsStore.observePendingBackup();

  @override
  Stream<List<Backup>> observeUploadedBackup() => _backupsStore.observeUploadedBackup();

  @override
  Future<void> addNewImages(List<AssetEntity> rawImages) async => _backupsStore.addNewImages(
        await _backupMapper.forList(rawImages),
      );
}
