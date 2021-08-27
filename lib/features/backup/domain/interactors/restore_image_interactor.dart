import 'dart:io';

import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/domain/repositories/prefs_repository.dart';
import 'package:injectable/injectable.dart';

import 'package:graduation_project/base/domain/interactors/interactors.dart';
import 'package:graduation_project/features/backup/data/stores/backup_store.dart';
import 'package:graduation_project/features/backup/domain/repositorires/backups_repository.dart';
import 'package:permission_handler/permission_handler.dart';

@injectable
class RestoreImageInteractor extends Interactor<Backup> {
  RestoreImageInteractor(this._backupsRepository, this._backupsStore);
  final BackupsRepository _backupsRepository;
  final BackupsStore _backupsStore;

  @override
  Future<void> doWork(Backup params) async {
    final localStorage = await getLocalStoragePath();
    if (localStorage != null) {
      final result = await _backupsRepository.downloadFile(
        localStoragePath: localStorage + '/${params.serverPath!}',
        serverPath: params.serverPath!,
      );
      if (result.isSuccess) {
        await _backupsStore.updateBackups([params.copyWith(needRestore: false, status: BackupStatus.UPLOADED)]);
      }
    }
  }

  Future<String?> getLocalStoragePath() async {
    if (await Permission.storage.request().isGranted) {
      // final path = await getExternalStorageDirectories(type: StorageDirectory.pictures);
      // final directory = Directory(path!.first.path + '/' + kSyncFolderName);
      final path = 'storage/emulated/0/Android/media/$kSyncFolderName';
      final directory = Directory(path);
      if (!directory.existsSync()) {
        await directory.create(recursive: true);
      }
      return path;
    }
    return null;
  }
}
