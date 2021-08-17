import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:graduation_project/app/base_page.dart';
import 'package:graduation_project/base/domain/repositories/prefs_repository.dart';
import 'package:graduation_project/features/backup/data/stores/tokens_store.dart';
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
    TokensStore _tokensStore,
  ) : super(logger, _tokensStore);
}

abstract class _SplashViewmodelBase extends BaseViewmodel with Store {
  _SplashViewmodelBase(Logger logger, this._tokensStore) : super(logger) {
    Future.delayed(
      2.seconds,
      () => getContext((context) async {
        // context.pushNamedAndRemoveUntil(BasePage.route, (_) => false);

        (await _tokensStore.getToken())?.token.isNullOrEmpty == true
            ? context.pushNamedAndRemoveUntil(LoginPage.route, (_) => false)
            : context.pushNamedAndRemoveUntil(BasePage.route, (_) => false);
      }),
    );
  }
  final TokensStore _tokensStore;

  //* OBSERVERS *//

  //* COMPUTED *//

  //* ACTIONS *//

}
