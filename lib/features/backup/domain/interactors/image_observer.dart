import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/domain/interactors/interactors.dart';
import 'package:graduation_project/features/backup/data/stores/backup_store.dart';
import 'package:graduation_project/features/backup/presentation/viewmodels/backup_viewmodel.dart';
import 'package:injectable/injectable.dart';

@injectable
class ImageObserver extends SubjectInteractor<_Params, List<Backup>> {
  ImageObserver(this._backupsStore);

  final BackupsStore _backupsStore;

  @override
  Stream<List<Backup>> createObservable(_Params params) {
    if (params.status == BackupStatusUi.NEED_RESTORE) {
      return _backupsStore.observeNeedRestoreBackups(
        asc: params.asc,
        modifier: params.modifier,
        limit: params.limit,
      );
    } else if (params.status == BackupStatusUi.PENDING) {
      return _backupsStore.observePendingBackups(
        asc: params.asc,
        modifier: params.modifier,
        limit: params.limit,
      );
    } else {
      return _backupsStore.observeBackupsByStatus(
        asc: params.asc,
        modifier: params.modifier,
        status: params.status.asBackupStatus,
        limit: params.limit,
      );
    }
  }

  static _Params params({
    required BackupStatusUi status,
    bool asc = true,
    BackupModifier modifier = BackupModifier.PRIVATE,
    int? limit,
    bool withNeedRestore = false,
  }) =>
      _Params(
        status: status,
        asc: asc,
        limit: limit,
        modifier: modifier,
        withNeedRestore: withNeedRestore,
      );
}

class _Params {
  const _Params({
    required this.status,
    this.modifier = BackupModifier.PRIVATE,
    this.asc = true,
    this.limit,
    this.withNeedRestore = false,
  });

  final BackupStatusUi status;
  final bool asc;
  final bool withNeedRestore;
  final BackupModifier modifier;
  final int? limit;
}
