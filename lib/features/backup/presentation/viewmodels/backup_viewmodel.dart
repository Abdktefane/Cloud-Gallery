import 'package:core_sdk/data/viewmodels/base_viewmodel.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/domain/interactors/interactors.dart';
import 'package:graduation_project/features/backup/domain/interactors/image_observer.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'backup_viewmodel.g.dart';

@injectable
class BackupViewmodel extends _BackupViewmodelBase with _$BackupViewmodel {
  BackupViewmodel(
    Logger logger,
    ImageObserver imageSyncInteractor,
  ) : super(logger, imageSyncInteractor);
}

abstract class _BackupViewmodelBase extends BaseViewmodel with Store {
  _BackupViewmodelBase(
    Logger logger,
    this._imageObserver,
  ) : super(logger) {
    images = _imageObserver.asObservable();
    filterObserver = autorun((_) => _imageObserver(filter));
  }

  late final ReactionDisposer filterObserver;
  final ImageObserver _imageObserver;

  //* OBSERVERS *//

  @observable
  ObservableStream<List<Backup>>? images;

  @observable
  BackupStatus filter = BackupStatus.PENDING;

  //* COMPUTED *//

  //* ACTIONS *//

  @action
  void changeFilter(BackupStatus filter) => this.filter = filter;

  @override
  Future<void> dispose() {
    filterObserver();
    return super.dispose();
  }
}
