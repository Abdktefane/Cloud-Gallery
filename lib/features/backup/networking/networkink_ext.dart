import 'dart:convert';

import 'package:core_sdk/error/exceptions.dart';
import 'package:core_sdk/utils/constants.dart';
import 'package:dio/dio.dart';
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
