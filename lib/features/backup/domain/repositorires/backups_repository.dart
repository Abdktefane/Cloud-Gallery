import 'package:core_sdk/data/repositories/base_repository.dart';
import 'package:graduation_project/base/data/datasources/common_datasource.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class BackupsRepository extends BaseRepository {
  const BackupsRepository(
    CommonDataSource backupsDataSource,
  ) : super(backupsDataSource);

  Stream<List<Backup>> observeActiveBackups();

  Stream<List<Backup>> observePendingBackup();

  Stream<List<Backup>> observeUploadedBackup();

  Future<void> addNewImages(List<AssetEntity> rawImages);
}
