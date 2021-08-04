import 'package:core_sdk/data/viewmodels/base_viewmodel.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/utils/extensions/build_context.dart';
import 'package:core_sdk/utils/extensions/future.dart';
import 'package:graduation_project/app/base_page.dart';
import 'package:graduation_project/features/login/domain/repositories/login_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:supercharged/supercharged.dart';

part 'register_viewmodel.g.dart';

@injectable
class RegisterViewmodel extends _RegisterViewmodelBase with _$RegisterViewmodel {
  RegisterViewmodel(
    Logger logger,
    LoginRepository registerRepository,
  ) : super(logger, registerRepository);
}

abstract class _RegisterViewmodelBase extends BaseViewmodel with Store {
  _RegisterViewmodelBase(Logger logger, this._registerRepository) : super(logger);
  final LoginRepository _registerRepository;

  //* OBSERVERS *//

  //* COMPUTED *//

  //* ACTIONS *//

  @action
  void register({required String email, required String password}) => futureWrapper(
        () => _registerRepository.login(email: email, password: password).whenSuccess(
              (res) => getContext(
                (context) => context.pushNamedAndRemoveUntil(BasePage.route, (_) => false),
              ),
            ),
        catchBlock: (err) => showSnack(err ?? '', duration: 2.seconds),
        useLoader: true,
      );
}
