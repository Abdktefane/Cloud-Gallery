import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/utils/network_result.dart';
import 'package:graduation_project/base/domain/repositories/graduate_repository.dart';
import 'package:graduation_project/base/domain/repositories/prefs_repository.dart';
import 'package:graduation_project/features/login/data/datasources/login_datasource.dart';

abstract class LoginRepository extends GraduateRepository {
  const LoginRepository(
    LoginDataSource loginDataSource,
    Logger logger,
    PrefsRepository prefsRepository,
  ) : super(dataSource: loginDataSource, logger: logger, prefsRepository: prefsRepository);

  Future<NetworkResult<bool>> login({required String email, required String password});
  Future<NetworkResult<bool>> register({required String email, required String password});
}
