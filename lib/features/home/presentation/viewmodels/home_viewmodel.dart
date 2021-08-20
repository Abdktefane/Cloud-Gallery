import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/app/theme/colors.dart';
import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/domain/repositories/common_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:injectable/injectable.dart';
import 'package:core_sdk/utils/extensions/string.dart';
import 'package:supercharged/supercharged.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/data/viewmodels/base_viewmodel.dart';

part 'home_viewmodel.g.dart';

@injectable
class HomeViewmodel extends _HomeViewmodelBase with _$HomeViewmodel {
  HomeViewmodel(
    Logger logger,
    CommonRepository _commonRepository,
  ) : super(logger, _commonRepository);
}

abstract class _HomeViewmodelBase extends BaseViewmodel with Store {
  _HomeViewmodelBase(Logger logger, this._commonRepository) : super(logger);
  final CommonRepository _commonRepository;
  final ImagePicker _picker = ImagePicker();

  int page = 1;

  //* OBSERVERS *//
  @observable
  BackupModifier imageSource = BackupModifier.PRIVATE;

  //* COMPUTED *//

  //* ACTIONS *//

  @action
  void toggleImageSource() => imageSource = imageSource.negate;

  @action
  void searchByText(String query) {}

  @action
  Future<void> searchByImage(int index) async {
    final XFile? image = await _picker.pickImage(source: index == 0 ? ImageSource.camera : ImageSource.gallery);
    print('image picked ${image?.path}');
  }

  @action
  void search({fresh = false}) {}
}
