import 'dart:convert';

import 'package:core_sdk/data/datasource/base_remote_data_source.dart';
import 'package:core_sdk/error/exceptions.dart';
import 'package:core_sdk/error/failures.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/utils/constants.dart';
import 'package:core_sdk/utils/network_result.dart';
import 'package:dio/dio.dart';
import 'package:graduation_project/features/backup/networking/networking_isolator.dart';
import 'package:graduation_project/features/backup/networking/networking_message.dart';

extension NetworkingExt<T> on Future<Response<T>> {
  Future<ResponseIsolateMessage> asNetworkMessageResponse(int id) => then((res) {
        if (res.statusCode == STATUS_OK) {
          return ResponseIsolateMessage.success(id, jsonDecode(res.data as String));
        } else {
          return ResponseIsolateMessage.error(id, ServerException('msg_http_exception'));
        }
      });
  // TODO(abd): handle this erro;
  //.catchError(() {});
}

extension ResponseIsolateMessageExt on ResponseIsolateMessage {
  NetworkResult<T?> asNetworkResult<T>({
    required Map<String, dynamic> jsonResponse,
    required Logger logger,
    required Mapper<T?>? mapper,
    required ErrorMapper? errorMapper,
  }) {
    try {
      if (jsonResponse is! Map && mapper == null) {
        return Success(jsonResponse as T?);
      }

      if (mapper == null) {
        return Success<T?>(null);
      }
      if (errorMapper != null || jsonResponse['message'] != null && (jsonResponse['status'] as int?) != 200) {
        throw ServerException(errorMapper?.call(jsonResponse) ?? jsonResponse['message'] ?? 'msg_something_wrong');
      }

      final value = mapper(jsonResponse);
      return Success(value);
    } catch (e) {
      logger.e('Network Isolator Final Catch request:request<$T>, error:$e, mapper: $mapper, response:$jsonResponse');
      return e is ServerException
          ? NetworkError(ServerFailure(e.message))
          : NetworkError(ServerFailure(e is String ? e : 'msg_something_wrong'));
    }
  }
}
