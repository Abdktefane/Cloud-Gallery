// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:core_sdk/utils/Fimber/Logger.dart' as _i7;
import 'package:dio/dio.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:moor/isolate.dart' as _i29;
import 'package:shared_preferences/shared_preferences.dart' as _i5;

import '../../base/data/datasources/common_datasource.dart' as _i15;
import '../../base/data/db/database_transaction_runner.dart' as _i8;
import '../../base/data/db/di/db_module.dart' as _i32;
import '../../base/data/db/graduate_db.dart' as _i9;
import '../../base/data/repositories/common_repository_impl.dart' as _i17;
import '../../base/domain/repositories/common_repository.dart' as _i16;
import '../../base/domain/repositories/prefs_repository.dart' as _i4;
import '../../base/utils/image_saver.dart' as _i30;
import '../../features/backup/data/mappers/backup_mapper.dart' as _i23;
import '../../features/backup/data/repositories/backups_repository_impl.dart'
    as _i21;
import '../../features/backup/data/stores/backup_store.dart' as _i22;
import '../../features/backup/data/stores/last_sync_requrest_store.dart'
    as _i24;
import '../../features/backup/domain/interactors/image_observer.dart' as _i25;
import '../../features/backup/domain/interactors/image_sync_interactor.dart'
    as _i26;
import '../../features/backup/domain/repositorires/backups_repository.dart'
    as _i20;
import '../../features/backup/presentation/viewmodels/backup_viewmodel.dart'
    as _i28;
import '../../features/home/presentation/viewmodels/home_viewmodel.dart'
    as _i18;
import '../../features/login/data/datasources/login_datasource.dart' as _i10;
import '../../features/login/data/repositories/login_repository_impl.dart'
    as _i12;
import '../../features/login/domain/repositories/login_repository.dart' as _i11;
import '../../features/login/viewmodels/login_viewmodel.dart' as _i13;
import '../../features/recommend/presentation/viewmodels/recommend_viewmodel.dart'
    as _i19;
import '../../features/register/presentation/viewmodels/register_viewmodel.dart'
    as _i14;
import '../../features/splash/viewmodels/splash_viewmodel.dart' as _i6;
import '../viewmodels/app_viewmodel.dart' as _i27;
import 'injection_container.dart' as _i31;

const String _prod = 'prod';
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $inject(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final appModule = _$AppModule();
  final graduateDBModule = _$GraduateDBModule();
  gh.factory<String>(() => appModule.baseUrl, instanceName: 'ApiBaseUrl');
  gh.factory<_i3.BaseOptions>(
      () => appModule.dioOption(get<String>(instanceName: 'ApiBaseUrl')));
  gh.lazySingleton<_i4.PrefsRepository>(
      () => appModule.prefsRepository(get<_i5.SharedPreferences>()),
      registerFor: {_prod});
  gh.factory<_i6.SplashViewmodel>(
      () => _i6.SplashViewmodel(get<_i7.Logger>(), get<_i4.PrefsRepository>()));
  gh.factory<_i8.DatabaseTransactionRunner>(
      () => _i8.DatabaseTransactionRunner(get<_i9.GraduateDB>()));
  gh.lazySingleton<_i10.LoginDataSource>(() => _i10.LoginDataSourceImpl(
      client: get<_i3.Dio>(),
      prefsRepository: get<_i4.PrefsRepository>(),
      logger: get<_i7.Logger>()));
  gh.lazySingleton<_i11.LoginRepository>(() => _i12.LoginRepositoryImpl(
      get<_i10.LoginDataSource>(),
      get<_i7.Logger>(),
      get<_i4.PrefsRepository>()));
  gh.factory<_i13.LoginViewmodel>(() =>
      _i13.LoginViewmodel(get<_i7.Logger>(), get<_i11.LoginRepository>()));
  gh.factory<_i14.RegisterViewmodel>(() =>
      _i14.RegisterViewmodel(get<_i7.Logger>(), get<_i11.LoginRepository>()));
  gh.lazySingleton<_i15.CommonDataSource>(() => _i15.CommonDataSourceImpl(
      client: get<_i3.Dio>(),
      prefsRepository: get<_i4.PrefsRepository>(),
      logger: get<_i7.Logger>()));
  gh.lazySingleton<_i16.CommonRepository>(
      () => _i17.CommonRepositoryImpl(get<_i15.CommonDataSource>()));
  gh.factory<_i18.HomeViewmodel>(() =>
      _i18.HomeViewmodel(get<_i7.Logger>(), get<_i16.CommonRepository>()));
  gh.factory<_i19.RecommendViewmodel>(() =>
      _i19.RecommendViewmodel(get<_i7.Logger>(), get<_i16.CommonRepository>()));
  gh.lazySingleton<_i20.BackupsRepository>(() => _i21.BackupsRepositoryImpl(
      get<_i15.CommonDataSource>(),
      get<_i22.BackupsStore>(),
      get<_i23.BackupMapper>(),
      get<_i24.LastSyncRequestStore>()));
  gh.factory<_i25.ImageObserver>(
      () => _i25.ImageObserver(get<_i20.BackupsRepository>()));
  gh.factory<_i26.ImageSyncInteractor>(
      () => _i26.ImageSyncInteractor(get<_i20.BackupsRepository>()));
  gh.factory<_i27.AppViewmodel>(() => _i27.AppViewmodel(get<_i7.Logger>(),
      get<_i4.PrefsRepository>(), get<_i26.ImageSyncInteractor>()));
  gh.factory<_i28.BackupViewmodel>(
      () => _i28.BackupViewmodel(get<_i7.Logger>(), get<_i25.ImageObserver>()));
  gh.singleton<_i23.BackupMapper>(_i23.BackupMapper());
  gh.singleton<_i7.Logger>(appModule.logger());
  await gh.singletonAsync<_i29.MoorIsolate>(
      () => graduateDBModule.getMoorIsolate(),
      preResolve: true);
  await gh.singletonAsync<_i5.SharedPreferences>(() => appModule.getPrefs(),
      preResolve: true);
  await gh.singletonAsync<_i9.GraduateDB>(
      () => graduateDBModule.getDb(get<_i29.MoorIsolate>()),
      preResolve: true);
  gh.singleton<_i24.LastSyncRequestStore>(
      _i24.LastSyncRequestStoreImpl(get<_i9.GraduateDB>()));
  gh.singleton<_i22.BackupsStore>(_i22.BackupDao(get<_i9.GraduateDB>()));
  gh.singleton<_i3.Dio>(appModule.dio(get<_i5.SharedPreferences>(),
      get<_i3.BaseOptions>(), get<_i7.Logger>(), get<_i4.PrefsRepository>()));
  gh.singleton<_i30.ImageSaver>(_i30.ImageSaver(get<_i4.PrefsRepository>()));
  return get;
}

class _$AppModule extends _i31.AppModule {}

class _$GraduateDBModule extends _i32.GraduateDBModule {}
