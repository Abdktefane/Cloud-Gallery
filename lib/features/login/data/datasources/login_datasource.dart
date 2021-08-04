import 'package:core_sdk/data/datasource/base_remote_data_source.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/utils/network_result.dart';
import 'package:dio/dio.dart';
import 'package:graduation_project/base/data/datasources/graduate_datasource.dart';
import 'package:graduation_project/base/data/models/base_response_model.dart';
import 'package:graduation_project/base/domain/repositories/prefs_repository.dart';
import 'package:graduation_project/base/utils/end_points.dart';
import 'package:graduation_project/features/login/data/models/login_response_model.dart';
import 'package:injectable/injectable.dart';

abstract class LoginDataSource extends GraduateDataSource {
  LoginDataSource({
    required Dio client,
    required PrefsRepository prefsRepository,
    required Logger logger,
  }) : super(
          prefsRepository: prefsRepository,
          client: client,
          logger: logger,
        );

  Future<NetworkResult<BaseResponseModel<LoginResponseModel>?>> login({
    required String email,
    required String password,
  });

  Future<NetworkResult<BaseResponseModel<LoginResponseModel>?>> register({
    required String email,
    required String password,
  });
}

@LazySingleton(as: LoginDataSource)
class LoginDataSourceImpl extends LoginDataSource {
  LoginDataSourceImpl({
    required Dio client,
    required PrefsRepository prefsRepository,
    required Logger logger,
  }) : super(
          prefsRepository: prefsRepository,
          client: client,
          logger: logger,
        );

  @override
  Future<NetworkResult<BaseResponseModel<LoginResponseModel>?>> login(
          {required String email, required String password}) =>
      request(
        method: METHOD.POST,
        endpoint: EndPoints.login,
        withAuth: true,
        mapper: BaseResponseModel.fromJson(LoginResponseModel.fromJson),
        data: {
          email: email,
          password: password,
        },
      );

  @override
  Future<NetworkResult<BaseResponseModel<LoginResponseModel>?>> register(
          {required String email, required String password}) =>
      request(
        method: METHOD.POST,
        endpoint: EndPoints.login,
        withAuth: true,
        mapper: BaseResponseModel.fromJson(LoginResponseModel.fromJson),
        data: {
          email: email,
          password: password,
        },
      );
}
