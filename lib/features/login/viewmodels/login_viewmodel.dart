import 'package:core_sdk/utils/dialogs.dart';
import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:core_sdk/utils/extensions/future.dart';
import 'package:graduation_project/app/base_page.dart';
import 'package:graduation_project/features/login/domain/repositories/login_repository.dart';
import 'package:mobx/mobx.dart';
import 'package:injectable/injectable.dart';
import 'package:core_sdk/utils/extensions/string.dart';
import 'package:supercharged/supercharged.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/data/viewmodels/base_viewmodel.dart';

part 'login_viewmodel.g.dart';

@injectable
class LoginViewmodel extends _LoginViewmodelBase with _$LoginViewmodel {
  LoginViewmodel(
    Logger logger,
    LoginRepository loginRepository,
  ) : super(logger, loginRepository);
}

abstract class _LoginViewmodelBase extends BaseViewmodel with Store {
  _LoginViewmodelBase(Logger logger, this._loginRepository) : super(logger);
  final LoginRepository _loginRepository;

  //* OBSERVERS *//

  //* COMPUTED *//

  //* ACTIONS *//

  @action
  void login({required String email, required String password}) => futureWrapper(
        () => _loginRepository.login(email: email, password: password).whenSuccess(
              (res) => getContext(
                (context) => context.pushNamedAndRemoveUntil(BasePage.route, (_) => false),
              ),
            ),
        catchBlock: (err) => showSnack(err ?? '', duration: 2.seconds),
        useLoader: true,
      );
}
