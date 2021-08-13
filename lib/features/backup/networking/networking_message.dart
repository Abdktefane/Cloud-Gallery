import 'dart:isolate';

import 'package:core_sdk/data/datasource/base_remote_data_source.dart';
import 'package:dio/dio.dart';

abstract class NetworkIsolateMessage {
  const NetworkIsolateMessage(this.id);
  final int id;
}

class InitIsolateMessage extends NetworkIsolateMessage {
  const InitIsolateMessage(int id, {required this.callerPort, required this.baseUrl}) : super(id);
  final SendPort callerPort;
  final String baseUrl;
  // final BaseOptions dioOptions;
}

class RequestIsolateMessage extends NetworkIsolateMessage {
  const RequestIsolateMessage(
    int id, {
    required this.method,
    required this.endpoint,
    this.withAuth = true,
    this.data,
    this.params,
    this.headers,
  }) : super(id);

  final METHOD method;
  final String endpoint;
  final bool withAuth;
  final dynamic data;
  final Map<String, dynamic>? params;
  final Map<String, dynamic>? headers;
}

class ResponseIsolateMessage extends NetworkIsolateMessage {
  ResponseIsolateMessage.init(int id, this.callerPort)
      : response = null,
        error = null,
        super(id);

  ResponseIsolateMessage.error(int id, this.error)
      : callerPort = null,
        response = null,
        super(id);

  ResponseIsolateMessage.success(int id, this.response)
      : callerPort = null,
        error = null,
        super(id);

  final SendPort? callerPort;
  final Map<String, dynamic>? response;
  final Exception? error;

  bool get isInit => response == null && error == null;
  bool get isResponse => callerPort == null;
  bool get isSuccess => isResponse && error == null;
  bool get isFailure => !isSuccess;
}

// enum NetworkIsolateMessageType { Init, Post, Get }

// class NetworkIsolateMessage {
//   const NetworkIsolateMessage.init({required this.callerPort, this.dioOptions})
//       : type = NetworkIsolateMessageType.Init,
//         data = null,
//         endpoint = null,
//         params = null,
//         options = null;

//   const NetworkIsolateMessage.post({
//     required this.endpoint,
//     required this.params,
//     required this.data,
//     this.options,
//   })  : type = NetworkIsolateMessageType.Init,
//         callerPort = null,
//         dioOptions = null;

//   final SendPort? callerPort;
//   final NetworkIsolateMessageType type;
//   final BaseOptions? dioOptions;

//   final String? endpoint;
//   final dynamic data;
//   final Map<String, dynamic>? params;
//   final Options? options;
// }
