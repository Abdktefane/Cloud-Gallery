import 'package:injectable/injectable.dart';

import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/domain/interactors/interactors.dart';
import 'package:graduation_project/features/backup/domain/repositorires/backups_repository.dart';

@injectable
class ImageObserver extends SubjectInteractor<_Params, List<Backup>> {
  ImageObserver(this._backupsRepository);

  final BackupsRepository _backupsRepository;

  @override
  Stream<List<Backup>> createObservable(_Params params) => _backupsRepository.observeBackupsByStatus(
        asc: params.asc,
        modifier: params.modifier,
        status: params.status,
        limit: params.limit,
      );

  static _Params params({
    required BackupStatus status,
    bool asc = true,
    BackupModifier modifier = BackupModifier.PRIVATE,
    int? limit,
  }) =>
      _Params(status: status, asc: asc, limit: limit, modifier: modifier);
}

class _Params {
  const _Params({
    required this.status,
    this.modifier = BackupModifier.PRIVATE,
    this.asc = true,
    this.limit,
  });

  final BackupStatus status;
  final bool asc;
  final BackupModifier modifier;
  final int? limit;
}
