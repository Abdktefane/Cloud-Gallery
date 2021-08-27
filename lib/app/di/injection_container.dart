import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/utils/Fimber/logger_impl.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:graduation_project/base/data/repositories/prefs_repository_impl.dart';
import 'package:graduation_project/base/domain/repositories/prefs_repository.dart';
import 'package:graduation_project/features/backup/networking/dio_options_utils.dart';
import 'package:graduation_project/features/backup/networking/networking_isolator.dart';
import 'package:injectable/injectable.dart';
import 'package:moor/isolate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'injection_container.config.dart';

const String baseUrl2 = 'http://192.168.1.10:3000';

final GetIt getIt = GetIt.I;

@InjectableInit(
  initializerName: r'$inject',
  preferRelativeImports: true,
  asExtension: false,
)
Future<GetIt?> inject({String? environment}) async => $inject(getIt, environment: environment);

@module
abstract class AppModule {
  @Named('ApiBaseUrl')
  String getBaseUrl(PrefsRepository prefsRepository) {
    return prefsRepository.baseUrl ?? '$baseUrl2/api';
  }

  // @Named('ApiBaseUrl')
  // String get baseUrl => 'https://demo.fivectech.com:9001/rest/v1/';

  NetworkIsolateBaseOptions dioOption(@Named('ApiBaseUrl') String baseUrl) => BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: 14000,
        receiveTimeout: 14000,
        sendTimeout: 14000,
        contentType: 'application/json;charset=utf-8',
        responseType: ResponseType.plain,
        headers: {'Accept': 'application/json', 'Connection': 'keep-alive'},
      ).asNetworkIsolateBaseOptions;

  @preResolve
  @singleton
  Future<NetworkIsolate> getNetworkIsolate(
    NetworkIsolateBaseOptions baseOptions,
    Logger logger,
    MoorIsolate moorIsolate,
  ) =>
      NetworkIsolate.getInstance(
        logger: logger,
        baseOptions: baseOptions,
        databasePort: moorIsolate.connectPort,
      );

  @preResolve
  @singleton
  Future<SharedPreferences> getPrefs() => SharedPreferences.getInstance();

  @prod
  @LazySingleton(as: PrefsRepository)
  PrefsRepositoryImpl prefsRepository(SharedPreferences prefs) => PrefsRepositoryImpl(prefs);

  @Singleton(as: Logger)
  LoggerImpl logger() => LoggerImpl();

  // @Named('image_uploader')
  // @singleton
  // Actor<void, bool> imageUploader(BackupsRepository backupsRepository) =>
  //     Actor<void, bool>(ImageUploader(backupsRepository));
}
