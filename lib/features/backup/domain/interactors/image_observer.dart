import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/domain/interactors/interactors.dart';
import 'package:graduation_project/features/backup/domain/repositorires/backups_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ImageObserver extends SubjectInteractor<BackupStatus, List<Backup>> {
  ImageObserver(this._backupsRepository);

  final BackupsRepository _backupsRepository;

  @override
  Stream<List<Backup>> createObservable(BackupStatus params) => _backupsRepository.observeBackupsByStatus(params);
}
