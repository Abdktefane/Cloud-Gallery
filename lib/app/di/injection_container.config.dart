// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:core_sdk/utils/Fimber/Logger.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:moor/isolate.dart' as _i31;
import 'package:shared_preferences/shared_preferences.dart' as _i5;

import '../../base/data/datasources/common_datasource.dart' as _i10;
import '../../base/data/db/database_transaction_runner.dart' as _i8;
import '../../base/data/db/di/db_module.dart' as _i34;
import '../../base/data/db/graduate_db.dart' as _i9;
import '../../base/data/repositories/common_repository_impl.dart' as _i13;
import '../../base/domain/repositories/common_repository.dart' as _i12;
import '../../base/domain/repositories/prefs_repository.dart' as _i4;
import '../../features/backup/data/mappers/backup_mapper.dart' as _i24;
import '../../features/backup/data/repositories/backups_repository_impl.dart'
    as _i22;
import '../../features/backup/data/stores/backup_store.dart' as _i23;
import '../../features/backup/data/stores/last_sync_requrest_store.dart'
    as _i25;
import '../../features/backup/data/stores/tokens_store.dart' as _i32;
import '../../features/backup/domain/interactors/image_observer.dart' as _i26;
import '../../features/backup/domain/interactors/image_sync_interactor.dart'
    as _i29;
import '../../features/backup/domain/interactors/image_uploader_inreractor.dart'
    as _i27;
import '../../features/backup/domain/repositorires/backups_repository.dart'
    as _i21;
import '../../features/backup/networking/dio_options_utils.dart' as _i3;
import '../../features/backup/networking/networking_isolator.dart' as _i11;
import '../../features/backup/presentation/viewmodels/backup_viewmodel.dart'
    as _i28;
import '../../features/home/presentation/viewmodels/home_viewmodel.dart'
    as _i14;
import '../../features/login/data/datasources/login_datasource.dart' as _i15;
import '../../features/login/data/repositories/login_repository_impl.dart'
    as _i17;
import '../../features/login/domain/repositories/login_repository.dart' as _i16;
import '../../features/login/viewmodels/login_viewmodel.dart' as _i18;
import '../../features/recommend/presentation/viewmodels/recommend_viewmodel.dart'
    as _i19;
import '../../features/register/presentation/viewmodels/register_viewmodel.dart'
    as _i20;
import '../../features/splash/viewmodels/splash_viewmodel.dart' as _i6;
import '../viewmodels/app_viewmodel.dart' as _i30;
import 'injection_container.dart' as _i33;

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
  gh.factory<_i3.NetworkIsolateBaseOptions>(
      () => appModule.dioOption(get<String>(instanceName: 'ApiBaseUrl')));
  gh.lazySingleton<_i4.PrefsRepository>(
      () => appModule.prefsRepository(get<_i5.SharedPreferences>()),
      registerFor: {_prod});
  gh.factory<_i6.SplashViewmodel>(
      () => _i6.SplashViewmodel(get<_i7.Logger>(), get<_i4.PrefsRepository>()));
  gh.factory<_i8.DatabaseTransactionRunner>(
      () => _i8.DatabaseTransactionRunner(get<_i9.GraduateDB>()));
  gh.lazySingleton<_i10.CommonDataSource>(
      () => _i10.CommonDataSourceImpl(get<_i11.NetworkIsolate>()));
  gh.lazySingleton<_i12.CommonRepository>(
      () => _i13.CommonRepositoryImpl(get<_i10.CommonDataSource>()));
  gh.factory<_i14.HomeViewmodel>(() =>
      _i14.HomeViewmodel(get<_i7.Logger>(), get<_i12.CommonRepository>()));
  gh.lazySingleton<_i15.LoginDataSource>(
      () => _i15.LoginDataSourceImpl(get<_i11.NetworkIsolate>()));
  gh.lazySingleton<_i16.LoginRepository>(() => _i17.LoginRepositoryImpl(
      get<_i15.LoginDataSource>(),
      get<_i7.Logger>(),
      get<_i4.PrefsRepository>()));
  gh.factory<_i18.LoginViewmodel>(() =>
      _i18.LoginViewmodel(get<_i7.Logger>(), get<_i16.LoginRepository>()));
  gh.factory<_i19.RecommendViewmodel>(() =>
      _i19.RecommendViewmodel(get<_i7.Logger>(), get<_i12.CommonRepository>()));
  gh.factory<_i20.RegisterViewmodel>(() =>
      _i20.RegisterViewmodel(get<_i7.Logger>(), get<_i16.LoginRepository>()));
  gh.lazySingleton<_i21.BackupsRepository>(() => _i22.BackupsRepositoryImpl(
      get<_i10.CommonDataSource>(),
      get<_i23.BackupsStore>(),
      get<_i24.BackupMapper>(),
      get<_i25.LastSyncRequestStore>()));
  gh.factory<_i26.ImageObserver>(
      () => _i26.ImageObserver(get<_i21.BackupsRepository>()));
  gh.factory<_i27.ImageUploaderInteractor>(() => _i27.ImageUploaderInteractor(
      get<_i21.BackupsRepository>(), get<_i26.ImageObserver>()));
  gh.factory<_i28.BackupViewmodel>(
      () => _i28.BackupViewmodel(get<_i7.Logger>(), get<_i26.ImageObserver>()));
  gh.factory<_i29.ImageSyncInteractor>(() => _i29.ImageSyncInteractor(
      get<_i21.BackupsRepository>(), get<_i27.ImageUploaderInteractor>()));
  gh.factory<_i30.AppViewmodel>(() => _i30.AppViewmodel(get<_i7.Logger>(),
      get<_i4.PrefsRepository>(), get<_i29.ImageSyncInteractor>()));
  gh.singleton<_i24.BackupMapper>(_i24.BackupMapper());
  gh.singleton<_i7.Logger>(appModule.logger());
  await gh.singletonAsync<_i31.MoorIsolate>(
      () => graduateDBModule.getMoorIsolate(),
      preResolve: true);
  await gh.singletonAsync<_i5.SharedPreferences>(() => appModule.getPrefs(),
      preResolve: true);
  await gh.singletonAsync<_i9.GraduateDB>(
      () => graduateDBModule.getDb(get<_i31.MoorIsolate>()),
      preResolve: true);
  gh.singleton<_i25.LastSyncRequestStore>(
      _i25.LastSyncRequestStoreImpl(get<_i9.GraduateDB>()));
  gh.singleton<_i32.TokensStore>(_i32.TokensStoreImpl(get<_i9.GraduateDB>()));
  gh.singleton<_i23.BackupsStore>(_i23.BackupDao(get<_i9.GraduateDB>()));
  await gh.singletonAsync<_i11.NetworkIsolate>(
      () => appModule.getNetworkIsolate(get<_i3.NetworkIsolateBaseOptions>(),
          get<_i7.Logger>(), get<_i4.PrefsRepository>()),
      preResolve: true);
  return get;
}

class _$AppModule extends _i33.AppModule {}

class _$GraduateDBModule extends _i34.GraduateDBModule {}
