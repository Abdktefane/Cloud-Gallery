import 'dart:isolate';

import 'package:core_sdk/data/datasource/base_remote_data_source.dart';
import 'package:core_sdk/error/exceptions.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/utils/dio/token_option.dart';
import 'package:dio/dio.dart';
import 'package:graduation_project/features/backup/networking/networking_message.dart';
import 'package:graduation_project/features/backup/networking/networkink_ext.dart';

void proccessNetworkIsolatorRequests(
  RequestIsolateMessage requestMessage, {
  required Logger logger,
  required Dio dio,
  required SendPort callerPort,
}) async {
  late final ResponseIsolateMessage responseMessage;
  try {
    logger.d('Network Isolate:${Isolate.current.hashCode} => RECIVE RequestMessage: $requestMessage');
    responseMessage = await _proccessNetworkIsolatorRequest(
      id: requestMessage.id,
      client: dio,
      logger: logger,
      method: requestMessage.method,
      endpoint: requestMessage.endpoint,
      params: requestMessage.params,
      headers: requestMessage.headers,
      withAuth: requestMessage.withAuth,
      data: requestMessage.data,
    );
    logger.d('Network Isolate:${Isolate.current.hashCode} => SEND ResponseMessage: $responseMessage');
    callerPort.send(responseMessage);
  }
  // TODO(abd): handle error message we should rerurn Error mesage gere
  catch (ex) {
    logger.e('Network Isolate:${Isolate.current.hashCode} => Catch ErrorMessage: $ex');
    callerPort.send(ResponseIsolateMessage.error(requestMessage.id, Exception('unknown error')));
  }
}

Future<ResponseIsolateMessage> _proccessNetworkIsolatorRequest({
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
