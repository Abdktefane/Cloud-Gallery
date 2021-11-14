import 'package:core_sdk/utils/dio/token_option.dart';
import 'package:dio/dio.dart';
import 'package:graduation_project/features/backup/data/stores/tokens_store.dart';

class TokenInterceptor extends Interceptor {
  TokenInterceptor(this._tokensStore);

  final TokensStore _tokensStore;

  @override
  Future<RequestOptions?> onRequest(options, handler) async {
    // options.headers['Accept-Language'] = prefsRepository.languageCode;
    print('interceptor called');
    if (TokenOption.needToken(options)) {
      try {
        print('interceptor called and options need token');
        final token = await _tokensStore.getToken();
        print('my debug token: $token');

        options.headers['Authorization'] = token?.token;
      } catch (ex, st) {
        print('interceptor exception ex:$ex, st: $st');
      }
    }
    handler.next(options);
  }
}
