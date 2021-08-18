import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/domain/interactors/interactors.dart';
import 'package:graduation_project/features/backup/domain/repositorires/backups_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class BackupsRowsObserver extends SubjectInteractor<_Params, int> {
  BackupsRowsObserver(this._backupsRepository);

  final BackupsRepository _backupsRepository;

  @override
  Stream<int> createObservable(_Params params) => _backupsRepository.observeBackupsRows(
        modifier: params.modifier,
        status: params.status,
      );

  static _Params params({
    required BackupStatus status,
    required BackupModifier modifier,
  }) =>
      _Params(status: status, modifier: modifier);
}

class _Params {
  const _Params({
    required this.status,
    required this.modifier,
  });

  final BackupStatus status;
  final BackupModifier modifier;
}
