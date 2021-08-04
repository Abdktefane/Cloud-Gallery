import 'package:mobx/mobx.dart';
import 'package:injectable/injectable.dart';
import 'package:core_sdk/utils/extensions/string.dart';
import 'package:supercharged/supercharged.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/data/viewmodels/base_viewmodel.dart';

part 'splash_viewmodel.g.dart';

@injectable
class SplashViewmodel extends _SplashViewmodelBase with _$SplashViewmodel {
  SplashViewmodel(Logger logger) : super(logger);
}

abstract class _SplashViewmodelBase extends BaseViewmodel with Store {
  _SplashViewmodelBase(Logger logger) : super(logger);

  //* OBSERVERS *//

  //* COMPUTED *//

  //* ACTIONS *//

}
