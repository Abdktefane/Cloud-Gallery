import 'package:core_sdk/utils/dio/token_option.dart';
import 'package:dio/dio.dart';

class TokenInterceptor extends Interceptor {
  TokenInterceptor({required this.tokenBuilder});

  final String Function() tokenBuilder;

  @override
  Future<RequestOptions?> onRequest(options, handler) async {
    // options.headers['Accept-Language'] = prefsRepository.languageCode;
    if (TokenOption.needToken(options)) {
      options.headers['Authorization'] = /* 'Basic ' + */ tokenBuilder();
    }
    handler.next(options);
  }
}
