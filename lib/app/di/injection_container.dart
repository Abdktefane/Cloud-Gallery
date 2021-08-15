import 'package:actors/actors.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/utils/Fimber/logger_impl.dart';
import 'package:core_sdk/utils/dio/retry_interceptor.dart';
import 'package:core_sdk/utils/dio/retry_options.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:graduation_project/base/data/repositories/prefs_repository_impl.dart';
import 'package:graduation_project/base/domain/repositories/prefs_repository.dart';
import 'package:graduation_project/base/utils/token_interceptor.dart';
import 'package:graduation_project/features/backup/domain/interactors/image_uploader_inreractor.dart';
import 'package:graduation_project/features/backup/domain/repositorires/backups_repository.dart';
import 'package:graduation_project/features/backup/networking/dio_options_utils.dart';
import 'package:graduation_project/features/backup/networking/networking_isolator.dart';
import 'package:graduation_project/features/backup/networking/networking_message.dart';
import 'package:graduation_project/features/backup/networking/networkink_ext.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'injection_container.config.dart';

const String baseUrl2 = 'http://192.168.1.9:3000';

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
  String get baseUrl => '$baseUrl2/api';

  // @Named('ApiBaseUrl')
  // String get baseUrl => 'https://demo.fivectech.com:9001/rest/v1/';

  NetworkIsolateBaseOptions dioOption(@Named('ApiBaseUrl') String baseUrl) => BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: 2000,
        receiveTimeout: 2000,
        sendTimeout: 2000,
        contentType: 'application/json;charset=utf-8',
        responseType: ResponseType.plain,
        headers: {'Accept': 'application/json', 'Connection': 'keep-alive'},
      ).asNetworkIsolateBaseOptions;

  @preResolve
  @singleton
  Future<NetworkIsolate> getNetworkIsolate(
    NetworkIsolateBaseOptions baseOptions,
    Logger logger,
    PrefsRepository prefsRepository,
  ) =>
      NetworkIsolate.getInstance(
        logger: logger,
        baseOptions: baseOptions,
        interceptors: [TokenInterceptor(prefsRepository: prefsRepository)],
      );

  @preResolve
  @singleton
  Future<SharedPreferences> getPrefs() => SharedPreferences.getInstance();

  @prod
  @LazySingleton(as: PrefsRepository)
  PrefsRepositoryImpl prefsRepository(SharedPreferences prefs) => PrefsRepositoryImpl(prefs);

  // @singleton
  // Dio dio(
  //   SharedPreferences sharedPreferences,
  //   BaseOptions option,
  //   Logger logger,
  //   PrefsRepository tokenRepository,
  //   // @Named('RefreshTokenUrl') String refreshTokenUrl,
  // ) {
  //   final dio = Dio(option);
  //   return dio
  //     ..interceptors.addAll(<Interceptor>[
  //       RetryInterceptor(
  //         dio: dio,
  //         logger: logger,
  //         options: const RetryOptions(),
  //       ),
  //       TokenInterceptor(
  //         // baseDio: dio,
  //         prefsRepository: tokenRepository,
  //       ),
  //       LogInterceptor(
  //         requestBody: true,
  //         responseBody: true,
  //         responseHeader: true,
  //         requestHeader: true,
  //         request: true,
  //       ),
  //     ]);
  // }

  @Singleton(as: Logger)
  LoggerImpl logger() => LoggerImpl();

  // @Named('image_uploader')
  // @singleton
  // Actor<void, bool> imageUploader(BackupsRepository backupsRepository) =>
  //     Actor<void, bool>(ImageUploader(backupsRepository));
}
