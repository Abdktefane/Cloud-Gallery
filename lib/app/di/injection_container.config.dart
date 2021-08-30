// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:core_sdk/utils/Fimber/Logger.dart' as _i11;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:moor/isolate.dart' as _i37;
import 'package:shared_preferences/shared_preferences.dart' as _i4;

import '../../base/data/datasources/common_datasource.dart' as _i14;
import '../../base/data/db/database_transaction_runner.dart' as _i5;
import '../../base/data/db/di/db_module.dart' as _i40;
import '../../base/data/db/graduate_db.dart' as _i6;
import '../../base/data/repositories/common_repository_impl.dart' as _i17;
import '../../base/domain/repositories/common_repository.dart' as _i16;
import '../../base/domain/repositories/prefs_repository.dart' as _i3;
import '../../base/utils/image_url_provider.dart' as _i38;
import '../../features/backup/data/mappers/backup_mapper.dart' as _i26;
import '../../features/backup/data/repositories/backups_repository_impl.dart'
    as _i25;
import '../../features/backup/data/stores/backup_store.dart' as _i8;
import '../../features/backup/data/stores/last_sync_requrest_store.dart'
    as _i27;
import '../../features/backup/data/stores/tokens_store.dart' as _i12;
import '../../features/backup/domain/interactors/backups_rows_observer.dart'
    as _i13;
import '../../features/backup/domain/interactors/change_modifire_interactor.dart'
    as _i28;
import '../../features/backup/domain/interactors/image_observer.dart' as _i7;
import '../../features/backup/domain/interactors/image_sync_interactor.dart'
    as _i29;
import '../../features/backup/domain/interactors/image_uploader_interactor.dart'
    as _i30;
import '../../features/backup/domain/interactors/restore_image_interactor.dart'
    as _i31;
import '../../features/backup/domain/interactors/search_observer.dart' as _i32;
import '../../features/backup/domain/interactors/sync_server_images_interactor.dart'
    as _i33;
import '../../features/backup/domain/repositorires/backups_repository.dart'
    as _i24;
import '../../features/backup/networking/dio_options_utils.dart' as _i9;
import '../../features/backup/networking/networking_isolator.dart' as _i15;
import '../../features/backup/presentation/viewmodels/backup_viewmodel.dart'
    as _i35;
import '../../features/home/presentation/viewmodels/home_viewmodel.dart'
    as _i36;
import '../../features/login/data/datasources/login_datasource.dart' as _i18;
import '../../features/login/data/repositories/login_repository_impl.dart'
    as _i20;
import '../../features/login/domain/repositories/login_repository.dart' as _i19;
import '../../features/login/viewmodels/login_viewmodel.dart' as _i21;
import '../../features/recommend/presentation/viewmodels/recommend_viewmodel.dart'
    as _i22;
import '../../features/register/presentation/viewmodels/register_viewmodel.dart'
    as _i23;
import '../../features/splash/viewmodels/splash_viewmodel.dart' as _i10;
import '../viewmodels/app_viewmodel.dart' as _i34;
import 'injection_container.dart' as _i39;

const String _prod = 'prod';
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $inject(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final appModule = _$AppModule();
  final graduateDBModule = _$GraduateDBModule();
  gh.lazySingleton<_i3.PrefsRepository>(
      () => appModule.prefsRepository(get<_i4.SharedPreferences>()),
      registerFor: {_prod});
  gh.factory<String>(() => appModule.getBaseUrl(get<_i3.PrefsRepository>()),
      instanceName: 'ApiBaseUrl');
  gh.factory<_i5.DatabaseTransactionRunner>(
      () => _i5.DatabaseTransactionRunner(get<_i6.GraduateDB>()));
  gh.factory<_i7.ImageObserver>(
      () => _i7.ImageObserver(get<_i8.BackupsStore>()));
  gh.factory<_i9.NetworkIsolateBaseOptions>(
      () => appModule.dioOption(get<String>(instanceName: 'ApiBaseUrl')));
  gh.factory<_i10.SplashViewmodel>(
      () => _i10.SplashViewmodel(get<_i11.Logger>(), get<_i12.TokensStore>()));
  gh.factory<_i13.BackupsRowsObserver>(
      () => _i13.BackupsRowsObserver(get<_i8.BackupsStore>()));
  gh.lazySingleton<_i14.CommonDataSource>(() => _i14.CommonDataSourceImpl(
      get<_i15.NetworkIsolate>(), get<_i3.PrefsRepository>()));
  gh.lazySingleton<_i16.CommonRepository>(
      () => _i17.CommonRepositoryImpl(get<_i14.CommonDataSource>()));
  gh.lazySingleton<_i18.LoginDataSource>(
      () => _i18.LoginDataSourceImpl(get<_i15.NetworkIsolate>()));
  gh.lazySingleton<_i19.LoginRepository>(() => _i20.LoginRepositoryImpl(
      get<_i18.LoginDataSource>(),
      get<_i12.TokensStore>(),
      get<_i11.Logger>(),
      get<_i3.PrefsRepository>()));
  gh.factory<_i21.LoginViewmodel>(() =>
      _i21.LoginViewmodel(get<_i11.Logger>(), get<_i19.LoginRepository>()));
  gh.factory<_i22.RecommendViewmodel>(() => _i22.RecommendViewmodel(
      get<_i11.Logger>(), get<_i16.CommonRepository>()));
  gh.factory<_i23.RegisterViewmodel>(() =>
      _i23.RegisterViewmodel(get<_i11.Logger>(), get<_i19.LoginRepository>()));
  gh.lazySingleton<_i24.BackupsRepository>(() => _i25.BackupsRepositoryImpl(
      get<_i14.CommonDataSource>(),
      get<_i8.BackupsStore>(),
      get<_i26.BackupMapper>(),
      get<_i27.LastSyncRequestStore>()));
  gh.factory<_i28.ChangeModifireInteractor>(
      () => _i28.ChangeModifireInteractor(get<_i24.BackupsRepository>()));
  gh.factory<_i29.ImageSaveInteractor>(() => _i29.ImageSaveInteractor(
      get<_i24.BackupsRepository>(), get<_i3.PrefsRepository>()));
  gh.factory<_i30.ImageUploaderInteractor>(() => _i30.ImageUploaderInteractor(
      get<_i24.BackupsRepository>(), get<_i11.Logger>()));
  gh.factory<_i31.RestoreImageInteractor>(() => _i31.RestoreImageInteractor(
      get<_i24.BackupsRepository>(), get<_i8.BackupsStore>()));
  gh.factory<_i32.SearchObserver>(
      () => _i32.SearchObserver(get<_i24.BackupsRepository>()));
  gh.factory<_i33.SyncServerImagesInteractor>(() =>
      _i33.SyncServerImagesInteractor(get<_i3.PrefsRepository>(),
          get<_i24.BackupsRepository>(), get<_i8.BackupsStore>()));
  gh.factory<_i34.AppViewmodel>(() => _i34.AppViewmodel(
      get<_i11.Logger>(),
      get<_i3.PrefsRepository>(),
      get<_i29.ImageSaveInteractor>(),
      get<_i30.ImageUploaderInteractor>(),
      get<_i33.SyncServerImagesInteractor>()));
  gh.factory<_i35.BackupViewmodel>(() => _i35.BackupViewmodel(
      get<_i11.Logger>(),
      get<_i7.ImageObserver>(),
      get<_i13.BackupsRowsObserver>(),
      get<_i28.ChangeModifireInteractor>(),
      get<_i31.RestoreImageInteractor>()));
  gh.factory<_i36.HomeViewmodel>(
      () => _i36.HomeViewmodel(get<_i11.Logger>(), get<_i32.SearchObserver>()));
  gh.singleton<_i11.Logger>(appModule.logger());
  await gh.singletonAsync<_i37.MoorIsolate>(
      () => graduateDBModule.getMoorIsolate(),
      preResolve: true);
  await gh.singletonAsync<_i4.SharedPreferences>(() => appModule.getPrefs(),
      preResolve: true);
  await gh.singletonAsync<_i6.GraduateDB>(
      () => graduateDBModule.getDb(get<_i37.MoorIsolate>()),
      preResolve: true);
  gh.singleton<_i27.LastSyncRequestStore>(
      _i27.LastSyncRequestStoreImpl(get<_i6.GraduateDB>()));
  gh.singleton<_i12.TokensStore>(_i12.TokensStoreImpl(get<_i6.GraduateDB>()));
  gh.singleton<_i26.BackupMapper>(
      _i26.BackupMapper(get<_i3.PrefsRepository>()));
  gh.singleton<_i8.BackupsStore>(_i8.BackupDao(get<_i6.GraduateDB>()));
  gh.singleton<_i38.ImageUrlProvider>(
      _i38.ImageUrlProvider(get<String>(instanceName: 'ApiBaseUrl')));
  await gh.singletonAsync<_i15.NetworkIsolate>(
      () => appModule.getNetworkIsolate(get<_i9.NetworkIsolateBaseOptions>(),
          get<_i11.Logger>(), get<_i37.MoorIsolate>()),
      preResolve: true);
  return get;
}

class _$AppModule extends _i39.AppModule {}

class _$GraduateDBModule extends _i40.GraduateDBModule {}
