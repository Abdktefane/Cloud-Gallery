import 'package:core_sdk/utils/extensions/list.dart';
import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/models/pagination_response.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/domain/interactors/interactors.dart';
import 'package:graduation_project/base/domain/repositories/prefs_repository.dart';
import 'package:graduation_project/features/backup/data/stores/backup_store.dart';
import 'package:graduation_project/features/backup/domain/repositorires/backups_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:moor/moor.dart';

@injectable
class SyncServerImagesInteractor extends Interactor<void> {
  SyncServerImagesInteractor(this._prefsRepository, this._backupsRepository, this._backupsStore);

  final PrefsRepository _prefsRepository;
  final BackupsRepository _backupsRepository;
  final BackupsStore _backupsStore;

  @override
  Future<void> doWork(void params) async {
    // get all images from backend
    final PaginationResponse<Backup> serverImages = (await _backupsRepository.getServerImages(
      page: 1,
      modifier: BackupModifier.PRIVATE,
      lastSync: _prefsRepository.lastServerSync,
    ))
        .getOrThrow()!;

    // update last sync date
    await _prefsRepository.setLastServerSync(DateTime.now());

    // TODO(abd): make all backups status NEED_RESTORE in first

    if (serverImages.data.isNullOrEmpty == true) {
      return;
    }

    // TODO(abd): find solution for maping (decode json) netwrok model to backup
    return _backupsStore.addNewImages(
      serverImages.data!.map((it) => it.toCompanion(true)).toList(),
      insertMode: InsertMode.insert,
    );
  }
}
