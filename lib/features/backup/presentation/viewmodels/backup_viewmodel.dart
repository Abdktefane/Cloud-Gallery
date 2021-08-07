import 'package:core_sdk/data/viewmodels/base_viewmodel.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/utils/extensions/string.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supercharged/supercharged.dart';

import 'package:graduation_project/base/domain/repositories/common_repository.dart';
import 'package:graduation_project/base/domain/usecases/image_loader_interactor.dart';
import 'package:graduation_project/features/backup/presentation/viewmodels/backup_image_ui_model.dart';

part 'backup_viewmodel.g.dart';

@injectable
class BackupViewmodel extends _BackupViewmodelBase with _$BackupViewmodel {
  BackupViewmodel(
    Logger logger,
    CommonRepository _commonRepository,
    ImageLoaderInteractor _imageLoaderInteractor,
  ) : super(logger, _commonRepository, _imageLoaderInteractor);
}

abstract class _BackupViewmodelBase extends BaseViewmodel with Store {
  _BackupViewmodelBase(
    Logger logger,
    this._commonRepository,
    this._imageLoaderInteractor,
  ) : super(logger) {
    _imageLoaderInteractor.observe().map((it) => BackupImageUIModel.fromAsset(image: it)).listen(_addRaw);
    _imageLoaderInteractor(pageNumber);
  }
  final CommonRepository _commonRepository;
  final ImageLoaderInteractor _imageLoaderInteractor;
  int pageNumber = 0;

  //* OBSERVERS *//
  @observable
  ObservableList<BackupImageUIModel>? images;

  //* COMPUTED *//

  //* ACTIONS *//

  @action
  void _addRaw(BackupImageUIModel raw) => images?.add(raw);

  @action
  void fetchLocalImages() {
    pageNumber++;
    _imageLoaderInteractor(pageNumber);
  }
}
