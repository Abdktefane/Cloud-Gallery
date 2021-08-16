import 'package:core_sdk/utils/extensions/future.dart';
import 'package:core_sdk/utils/network_result.dart';
import 'package:graduation_project/base/domain/repositories/prefs_repository.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:graduation_project/features/backup/data/stores/tokens_store.dart';
import 'package:graduation_project/features/login/data/datasources/login_datasource.dart';
import 'package:graduation_project/features/login/data/models/login_response_model.dart';
import 'package:graduation_project/features/login/domain/repositories/login_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: LoginRepository)
class LoginRepositoryImpl extends LoginRepository {
  LoginRepositoryImpl(
    this.loginDataSource,
    this._tokensStore,
    Logger logger,
    PrefsRepository prefsRepository,
  ) : super(loginDataSource, logger, prefsRepository);

  final LoginDataSource loginDataSource;
  final TokensStore _tokensStore;

  @override
  Future<NetworkResult<bool>> login({
    required String email,
    required String password,
  }) =>
      loginDataSource.login(email: email, password: password).whenSuccessWrapped((res) => _saveToken(res!.data!));

  @override
  Future<NetworkResult<bool>> register({
    required String email,
    required String password,
  }) =>
      loginDataSource.register(email: email, password: password).whenSuccessWrapped((res) => _saveToken(res!.data!));

  Future<bool> _saveToken(LoginResponseModel res) async {
    _tokensStore.saveToken(res.token!);
    return true;
  }
}
