import 'package:core_sdk/utils/dio/token_option.dart';
import 'package:dio/dio.dart';
import 'package:graduation_project/base/domain/repositories/prefs_repository.dart';

class TokenInterceptor extends Interceptor {
  TokenInterceptor({required this.baseDio, required this.prefsRepository});

  final PrefsRepository prefsRepository;
  final Dio baseDio;

  // We use a new Dio(to avoid dead lock) instance to request token.
  final Dio tokenDio = Dio()
    ..interceptors.addAll([
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        requestHeader: true,
        request: true,
        // logPrint: (Object err) => logger.w('LogInterceptor:$err'),
      ),
    ]);

  @override
  Future<RequestOptions?> onRequest(options, handler) async {
    options.headers['Accept-Language'] = prefsRepository.languageCode;
    if (TokenOption.needToken(options)) {
      options.headers['Authorization'] = /* 'Basic ' + */ prefsRepository.token!;
    }
    handler.next(options);
  }
}
