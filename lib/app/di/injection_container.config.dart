// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:core_sdk/utils/Fimber/Logger.dart' as _i4;
import 'package:dio/dio.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i7;

import '../../base/data/datasources/common_datasource.dart' as _i14;
import '../../base/data/repositories/common_repository_impl.dart' as _i16;
import '../../base/domain/repositories/common_repository.dart' as _i15;
import '../../base/domain/repositories/prefs_repository.dart' as _i6;
import '../../features/backup/presentation/viewmodels/backup_viewmodel.dart'
    as _i19;
import '../../features/home/presentation/viewmodels/home_viewmodel.dart'
    as _i17;
import '../../features/login/data/datasources/login_datasource.dart' as _i9;
import '../../features/login/data/repositories/login_repository_impl.dart'
    as _i11;
import '../../features/login/domain/repositories/login_repository.dart' as _i10;
import '../../features/login/viewmodels/login_viewmodel.dart' as _i12;
import '../../features/recommend/presentation/viewmodels/recommend_viewmodel.dart'
    as _i18;
import '../../features/register/presentation/viewmodels/register_viewmodel.dart'
    as _i13;
import '../../features/splash/viewmodels/splash_viewmodel.dart' as _i3;
import '../viewmodels/app_viewmodel.dart' as _i8;
import 'injection_container.dart' as _i20;

const String _prod = 'prod';
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $inject(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final appModule = _$AppModule();
  gh.factory<_i3.SplashViewmodel>(() => _i3.SplashViewmodel(get<_i4.Logger>()));
  gh.factory<String>(() => appModule.baseUrl, instanceName: 'ApiBaseUrl');
  gh.factory<_i5.BaseOptions>(
      () => appModule.dioOption(get<String>(instanceName: 'ApiBaseUrl')));
  gh.lazySingleton<_i6.PrefsRepository>(
      () => appModule.prefsRepository(get<_i7.SharedPreferences>()),
      registerFor: {_prod});
  gh.factory<_i8.AppViewmodel>(
      () => _i8.AppViewmodel(get<_i4.Logger>(), get<_i6.PrefsRepository>()));
  gh.lazySingleton<_i9.LoginDataSource>(() => _i9.LoginDataSourceImpl(
      client: get<_i5.Dio>(),
      prefsRepository: get<_i6.PrefsRepository>(),
      logger: get<_i4.Logger>()));
  gh.lazySingleton<_i10.LoginRepository>(() => _i11.LoginRepositoryImpl(
      get<_i9.LoginDataSource>(),
      get<_i4.Logger>(),
      get<_i6.PrefsRepository>()));
  gh.factory<_i12.LoginViewmodel>(() =>
      _i12.LoginViewmodel(get<_i4.Logger>(), get<_i10.LoginRepository>()));
  gh.factory<_i13.RegisterViewmodel>(() =>
      _i13.RegisterViewmodel(get<_i4.Logger>(), get<_i10.LoginRepository>()));
  gh.lazySingleton<_i14.CommonDataSource>(() => _i14.CommonDataSourceImpl(
      client: get<_i5.Dio>(),
      prefsRepository: get<_i6.PrefsRepository>(),
      logger: get<_i4.Logger>()));
  gh.lazySingleton<_i15.CommonRepository>(
      () => _i16.CommonRepositoryImpl(get<_i14.CommonDataSource>()));
  gh.factory<_i17.HomeViewmodel>(() =>
      _i17.HomeViewmodel(get<_i4.Logger>(), get<_i15.CommonRepository>()));
  gh.factory<_i18.RecommendViewmodel>(() =>
      _i18.RecommendViewmodel(get<_i4.Logger>(), get<_i15.CommonRepository>()));
  gh.factory<_i19.BackupViewmodel>(() =>
      _i19.BackupViewmodel(get<_i4.Logger>(), get<_i15.CommonRepository>()));
  gh.singleton<_i4.Logger>(appModule.logger());
  await gh.singletonAsync<_i7.SharedPreferences>(() => appModule.getPrefs(),
      preResolve: true);
  gh.singleton<_i5.Dio>(appModule.dio(
      get<_i7.SharedPreferences>(),
      get<_i5.BaseOptions>(),
      get<_i4.Logger>(),
      get<_i6.PrefsRepository>(),
      get<String>(instanceName: 'RefreshTokenUrl')));
  return get;
}

class _$AppModule extends _i20.AppModule {}
