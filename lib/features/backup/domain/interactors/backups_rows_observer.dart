import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/domain/interactors/interactors.dart';
import 'package:graduation_project/features/backup/data/stores/backup_store.dart';
import 'package:graduation_project/features/backup/domain/repositorires/backups_repository.dart';
import 'package:graduation_project/features/backup/presentation/viewmodels/backup_viewmodel.dart';
import 'package:injectable/injectable.dart';

@injectable
class BackupsRowsObserver extends SubjectInteractor<_Params, int> {
  BackupsRowsObserver(this._backupsStore);

  final BackupsStore _backupsStore;
  // final BackupsRepository _backupsRepository;

  @override
  Stream<int> createObservable(_Params params) {
    if (params.status == BackupStatusUi.PENDING) {
      return _backupsStore.observePendingBackupsRows(modifier: params.modifier);
    } else if (params.status == BackupStatusUi.NEED_RESTORE) {
      return _backupsStore.observeNeedRestoreBackupsRows(modifier: params.modifier);
    } else {
      return _backupsStore.observeBackupsRows(
        modifier: params.modifier,
        status: params.status.asBackupStatus,
      );
    }
  }

  static _Params params({
    required BackupStatusUi status,
    required BackupModifier modifier,
  }) =>
      _Params(status: status, modifier: modifier);
}

class _Params {
  const _Params({
    required this.status,
    required this.modifier,
  });

  final BackupStatusUi status;
  final BackupModifier modifier;
}
