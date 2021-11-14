import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/domain/interactors/interactors.dart';
import 'package:graduation_project/features/backup/domain/repositorires/backups_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChangeModifireInteractor extends Interactor<_Params> {
  ChangeModifireInteractor(this._backupsRepository);

  final BackupsRepository _backupsRepository;

  static _Params params(Backup backup) => _Params(backup);

  @override
  Future<void> doWork(_Params params) async {
    await _backupsRepository.changeModifire(
      modifier: params.backup.modifier.negate,
      serverPath: params.backup.serverPath!,
    );

    return _backupsRepository.updateBackups([params.backup.copyWith(modifier: params.backup.modifier.negate)]);
  }
}

class _Params {
  const _Params(this.backup);
  final Backup backup;
}
