import 'package:core_sdk/data/viewmodels/base_viewmodel.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/domain/interactors/interactors.dart';
import 'package:graduation_project/features/backup/domain/interactors/backups_rows_observer.dart';
import 'package:graduation_project/features/backup/domain/interactors/image_observer.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'backup_viewmodel.g.dart';

const int _pageSize = 25;

@injectable
class BackupViewmodel extends _BackupViewmodelBase with _$BackupViewmodel {
  BackupViewmodel(
    Logger logger,
    ImageObserver imageSyncInteractor,
    BackupsRowsObserver backupsRowsObserver,
  ) : super(logger, imageSyncInteractor, backupsRowsObserver);
}

abstract class _BackupViewmodelBase extends BaseViewmodel with Store {
  _BackupViewmodelBase(
    Logger logger,
    this._imageObserver,
    this._backupsRowsObserver,
  ) : super(logger) {
    images = _imageObserver.asObservable();
    imagesCount = _backupsRowsObserver.asObservable();
    filterObserver = autorun((_) {
      logger.d('backup viemodel auto run work');
      _imageObserver(ImageObserver.params(
        status: filter,
        modifier: modifier,
        asc: true,
        limit: limit,
      ));

      _backupsRowsObserver(BackupsRowsObserver.params(status: filter, modifier: modifier));
    });
  }

  late final ReactionDisposer filterObserver;
  final ImageObserver _imageObserver;
  final BackupsRowsObserver _backupsRowsObserver;
  int limit = _pageSize;

  //* OBSERVERS *//

  @observable
  ObservableStream<List<Backup>?>? images;

  @observable
  ObservableStream<int>? imagesCount;

  @observable
  BackupStatus filter = BackupStatus.PENDING;

  @observable
  BackupModifier modifier = BackupModifier.PRIVATE;

  //* COMPUTED *//

  @computed
  bool get canLoadMoreBackups => limit < (imagesCount?.value ?? 1000);

  //* ACTIONS *//

  void resetLimit() {
    limit = _pageSize;
  }

  void incrementLimit() {
    limit += _pageSize;
  }

  @action
  void changeFilter(BackupStatus filter) {
    if (this.filter == filter) {
      return;
    }
    resetLimit();
    this.filter = filter;
  }

  @action
  void changeModifier(BackupModifier modifier) {
    if (this.modifier == modifier) {
      return;
    }
    resetLimit();
    this.modifier = modifier;
  }

  @action
  void loadMore() {
    logger.d('my deubg load more called');
    if (canLoadMoreBackups) {
      incrementLimit();
      _imageObserver(ImageObserver.params(
        status: filter,
        modifier: modifier,
        asc: true,
        limit: limit,
      ));
    }
  }

  @action
  void toggleModifer() =>
      modifier = modifier == BackupModifier.PRIVATE ? BackupModifier.PUBPLIC : BackupModifier.PRIVATE;

  @override
  Future<void> dispose() {
    filterObserver();
    return super.dispose();
  }
}
