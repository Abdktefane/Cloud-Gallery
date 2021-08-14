import 'dart:isolate';

import 'package:core_sdk/data/datasource/base_remote_data_source.dart';
import 'package:equatable/equatable.dart';

abstract class NetworkIsolateMessage extends Equatable {
  const NetworkIsolateMessage(this.id);
  final int id;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [id];
}

class InitIsolateMessage extends NetworkIsolateMessage with EquatableMixin {
  const InitIsolateMessage(
    int id, {
    required this.callerPort,
    required this.baseUrl,
  }) : super(id);
  final SendPort callerPort;
  final String baseUrl;

  InitIsolateMessage copyWith({
    int? id,
    SendPort? callerPort,
    String? baseUrl,
  }) =>
      InitIsolateMessage(id ?? this.id, callerPort: callerPort ?? this.callerPort, baseUrl: baseUrl ?? this.baseUrl);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, callerPort, baseUrl];
}

class RequestIsolateMessage extends NetworkIsolateMessage with EquatableMixin {
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

  RequestIsolateMessage copyWith({
    int? id,
    METHOD? method,
    String? endpoint,
    bool? withAuth,
    dynamic data,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
  }) {
    return RequestIsolateMessage(
      id ?? this.id,
      method: method ?? this.method,
      endpoint: endpoint ?? this.endpoint,
      withAuth: withAuth ?? this.withAuth,
      data: data ?? this.data,
      params: params ?? this.params,
      headers: headers ?? this.headers,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, method, endpoint, withAuth, data, params, headers];
}

class ResponseIsolateMessage extends NetworkIsolateMessage with EquatableMixin {
  const ResponseIsolateMessage.init(int id, this.callerPort)
      : response = null,
        error = null,
        super(id);

  const ResponseIsolateMessage.error(int id, this.error)
      : callerPort = null,
        response = null,
        super(id);

  const ResponseIsolateMessage.success(int id, this.response)
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

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, callerPort, response, error];
}
