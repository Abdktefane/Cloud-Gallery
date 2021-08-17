import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/app/theme/colors.dart';
import 'package:graduation_project/base/domain/repositories/common_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:injectable/injectable.dart';
import 'package:core_sdk/utils/extensions/string.dart';
import 'package:supercharged/supercharged.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/data/viewmodels/base_viewmodel.dart';

part 'home_viewmodel.g.dart';

enum ImageSourceType { local, cloud }

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

  //* OBSERVERS *//
  @observable
  ImageSourceType imageSource = ImageSourceType.local;

  //* COMPUTED *//

  //* ACTIONS *//

  @action
  void toggleImageSource() =>
      imageSource = imageSource == ImageSourceType.local ? ImageSourceType.cloud : ImageSourceType.local;

  @action
  void searchByText(String query) {}

  @action
  Future<void> searchByImage(int index) async {
    final XFile? image = await _picker.pickImage(source: index == 0 ? ImageSource.camera : ImageSource.gallery);
    print('image picked ${image?.path}');
  }
}

extension ImageSourceTypeExt on ImageSourceType {
  String get raw => describeEnum(this);
  String get localizationKey => 'lbl_' + raw;
  IconButton getIcon(VoidCallback onPressed) {
    late final IconData iconData;
    switch (this) {
      case ImageSourceType.local:
        iconData = Icons.sd_storage;
        break;
      case ImageSourceType.cloud:
        iconData = Icons.cloud;
        break;
    }
    return IconButton(
      key: ValueKey(raw),
      icon: Icon(iconData),
      color: PRIMARY,
      onPressed: onPressed,
    );
  }
}
