import 'dart:isolate';

import 'package:core_sdk/data/datasource/base_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:graduation_project/base/data/models/form_data_model.dart';

import 'base_isolate.dart';

// TODO(abd): move to core sdk
class InitIsolateMessage extends BaseIsolateMessage with EquatableMixin {
  const InitIsolateMessage(
    int id, {
    required this.callerPort,
    required this.baseOptions,
    required this.databasePort,
    this.interceptors,
  }) : super(id);
  final SendPort callerPort;
  final SendPort databasePort;
  final String baseOptions;
  final List<Interceptor>? interceptors;

  InitIsolateMessage copyWith({
    int? id,
    SendPort? callerPort,
    SendPort? databasePort,
    String? baseOptions,
    List<Interceptor>? interceptors,
  }) =>
      InitIsolateMessage(
        id ?? this.id,
        callerPort: callerPort ?? this.callerPort,
        databasePort: databasePort ?? this.databasePort,
        baseOptions: baseOptions ?? this.baseOptions,
        interceptors: interceptors ?? this.interceptors,
      );

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, callerPort, baseOptions, interceptors];
}

class RequestIsolateMessage extends BaseIsolateMessage with EquatableMixin {
  const RequestIsolateMessage(
    int id, {
    required this.method,
    required this.endpoint,
    this.withAuth = true,
    this.data,
    this.params,
    this.headers,
    this.formDataRows,
  }) : super(id);

  final METHOD method;
  final String endpoint;
  final bool withAuth;
  final dynamic data;
  final Map<String, dynamic>? params;
  final Map<String, dynamic>? headers;
  final List<FormDataRow>? formDataRows;

  RequestIsolateMessage copyWith({
    int? id,
    METHOD? method,
    String? endpoint,
    bool? withAuth,
    dynamic data,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    List<FormDataRow>? formDataRows,
  }) {
    return RequestIsolateMessage(
      id ?? this.id,
      method: method ?? this.method,
      endpoint: endpoint ?? this.endpoint,
      withAuth: withAuth ?? this.withAuth,
      data: data ?? this.data,
      params: params ?? this.params,
      headers: headers ?? this.headers,
      formDataRows: formDataRows ?? this.formDataRows,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, method, endpoint, withAuth, data, params, headers, formDataRows];
}

class ResponseIsolateMessage extends BaseInitResponseIsolateMessage with EquatableMixin {
  const ResponseIsolateMessage.success(int id, this.response) : super(id, callerPort: null, error: null);

  const ResponseIsolateMessage.init(int id, SendPort callerPort)
      : response = null,
        super(id, callerPort: callerPort, error: null);

  const ResponseIsolateMessage.error(int id, Exception error, {StackTrace? st})
      : response = null,
        super(id, callerPort: null, error: error, st: st);

  final Map<String, dynamic>? response;

  bool get isResponse => callerPort == null;
  bool get isSuccess => isResponse && error == null;

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, callerPort, response, error];
}
