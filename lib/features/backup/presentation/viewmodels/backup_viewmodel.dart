import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:flutter/foundation.dart';
import 'package:graduation_project/app/viewmodels/graduate_viewmodel.dart';
import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/domain/interactors/interactors.dart';
import 'package:graduation_project/features/backup/domain/interactors/backups_rows_observer.dart';
import 'package:graduation_project/features/backup/domain/interactors/change_modifire_interactor.dart';
import 'package:graduation_project/features/backup/domain/interactors/image_observer.dart';
import 'package:graduation_project/features/backup/domain/interactors/restore_image_interactor.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:rxdart/rxdart.dart';

part 'backup_viewmodel.g.dart';

const int _pageSize = 25;

enum BackupStatusUi {
  UPLOADING,
  UPLOADED,
  NEED_RESTORE,
  PENDING,
}

extension BackupStatusUiExt on BackupStatusUi {
  String get raw => describeEnum(this);
  String get localizationKey => 'lbl_' + raw.toLowerCase();

  BackupStatus get asBackupStatus {
    switch (this) {
      case BackupStatusUi.UPLOADING:
        return BackupStatus.UPLOADING;
      case BackupStatusUi.UPLOADED:
        return BackupStatus.UPLOADED;
      case BackupStatusUi.NEED_RESTORE:
        throw UnimplementedError('BackupStatusUi.PENDING dont have BackupStatus');

      case BackupStatusUi.PENDING:
        throw UnimplementedError('BackupStatusUi.PENDING dont have BackupStatus');
    }
  }
}

@injectable
class BackupViewmodel extends _BackupViewmodelBase with _$BackupViewmodel {
  BackupViewmodel(
    Logger logger,
    ImageObserver imageSyncInteractor,
    BackupsRowsObserver backupsRowsObserver,
    ChangeModifireInteractor changeModifireInteractor,
    RestoreImageInteractor restoreImageInteractor,
  ) : super(
          logger,
          imageSyncInteractor,
          backupsRowsObserver,
          changeModifireInteractor,
          restoreImageInteractor,
        );
}

abstract class _BackupViewmodelBase extends GraduateViewmodel with Store {
  _BackupViewmodelBase(
    Logger logger,
    this._imageObserver,
    this._backupsRowsObserver,
    this._changeModifireInteractor,
    this._restoreImageInteractor,
  ) : super(logger) {
    images = _imageObserver.asObservable();
    imagesCount = _backupsRowsObserver.asObservable();
    // imagesCount?.first.then((count) {
    //   if (count == 0 && filter == BackupStatus.PENDING) {
    //     changeFilter(BackupStatus.UPLOADED);

    //     // imagesCount?.first.then((count) {
    //     //   if (count == 0 && filter == BackupStatus.UPLOADED && modifier == BackupModifier.PRIVATE) {
    //     //     changeModifier(BackupModifier.PUBPLIC);
    //     //   }
    //     // });
    //   }
    // });
    filterObserver = autorun((_) {
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
  final ChangeModifireInteractor _changeModifireInteractor;
  final RestoreImageInteractor _restoreImageInteractor;
  int limit = _pageSize;

  //* OBSERVERS *//

  @observable
  ObservableStream<List<Backup>?>? images;

  @observable
  ObservableStream<int>? imagesCount;

  @observable
  BackupStatusUi filter = BackupStatusUi.PENDING;

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
  void changeFilter(BackupStatusUi filter) {
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
  void toggleFilterModifer() => modifier = modifier.negate;

  @action
  void toggleBackupModifire(Backup backup) => collect(
        _changeModifireInteractor(ChangeModifireInteractor.params(backup)),
        useLoadingCollector: true,
      );

  @action
  void restoreImage(Backup backup) => collect(
        _restoreImageInteractor(backup),
        useLoadingCollector: true,
      );

  @override
  Future<void> dispose() {
    filterObserver();
    return super.dispose();
  }
}
