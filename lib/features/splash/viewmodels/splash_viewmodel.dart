import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:graduation_project/app/base_page.dart';
import 'package:graduation_project/base/domain/repositories/prefs_repository.dart';
import 'package:graduation_project/features/login/ui/pages/login_page.dart';
import 'package:mobx/mobx.dart';
import 'package:injectable/injectable.dart';
import 'package:core_sdk/utils/extensions/string.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/data/viewmodels/base_viewmodel.dart';
import 'package:supercharged/supercharged.dart';

part 'splash_viewmodel.g.dart';

@injectable
class SplashViewmodel extends _SplashViewmodelBase with _$SplashViewmodel {
  SplashViewmodel(
    Logger logger,
    PrefsRepository prefsRepository,
  ) : super(logger, prefsRepository);
}

abstract class _SplashViewmodelBase extends BaseViewmodel with Store {
  _SplashViewmodelBase(Logger logger, this._prefsRepository) : super(logger) {
    logger.d('my debug _SplashViewmodelBase called');
    Future.delayed(
      2.seconds,
      () => getContext((context) {
        context.pushNamedAndRemoveUntil(BasePage.route, (_) => false);
        // logger.d('my debug handler executed');
        // if (!_prefsRepository.token.isNullOrEmpty) {
        //   logger.d('my debug handler executed 1');
        //   context.pushNamedAndRemoveUntil(BasePage.route, (_) => false);
        // } else {
        //   logger.d('my debug handler executed 2');
        //   context.pushNamedAndRemoveUntil(LoginPage.route, (_) => false);
        //   // Navigator.of(context).pushNamedAndRemoveUntil(AuthPage.route, (_) => false);
        // }
      }),
    );
  }
  final PrefsRepository _prefsRepository;

  //* OBSERVERS *//

  //* COMPUTED *//

  //* ACTIONS *//

}
