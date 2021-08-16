import 'package:core_sdk/utils/dio/token_option.dart';
import 'package:dio/dio.dart';
import 'package:graduation_project/features/backup/data/stores/tokens_store.dart';

class TokenInterceptor extends Interceptor {
  TokenInterceptor(this._tokensStore);

  final TokensStore _tokensStore;

  @override
  Future<RequestOptions?> onRequest(options, handler) async {
    // options.headers['Accept-Language'] = prefsRepository.languageCode;
    if (TokenOption.needToken(options)) {
      options.headers['Authorization'] = /* 'Basic ' + */ await _tokensStore.getToken();
    }
    handler.next(options);
  }
}
