import 'package:core_sdk/data/datasource/base_remote_data_source.dart';
import 'package:core_sdk/error/exceptions.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/utils/dio/token_option.dart';
import 'package:dio/dio.dart';
import 'package:graduation_project/features/backup/networking/networking_message.dart';
import 'package:graduation_project/features/backup/networking/networkink_ext.dart';

Future<ResponseIsolateMessage> request({
  required int id,
  required Dio client,
  required Logger logger,
  required METHOD method,
  required String endpoint,
  required Map<String, dynamic>? params,
  required Map<String, dynamic>? headers,
  required bool withAuth,
  required dynamic data,
}) async {
  try {
    final Options options = withAuth ? TokenOption.toOptions().copyWith(headers: headers) : Options(headers: headers);
    switch (method) {
      case METHOD.POST:
        return client
            .post(endpoint, data: data, queryParameters: params ?? {}, options: options)
            .asNetworkMessageResponse(id);
      case METHOD.GET:
        return client.get(endpoint, queryParameters: params ?? {}, options: options).asNetworkMessageResponse(id);
      case METHOD.PUT:
        return client
            .put(endpoint, data: data, queryParameters: params ?? {}, options: options)
            .asNetworkMessageResponse(id);
      case METHOD.DELETE:
        return client
            .delete(endpoint, data: data, queryParameters: params ?? {}, options: options)
            .asNetworkMessageResponse(id);
    }
  } catch (e) {
    logger.e('BaseRemoteDataSourceImpl => performPostRequest => $e');
    throw e is ServerException ? ServerException(e.message) : ServerException('msg_something_wrong');
  }
}
