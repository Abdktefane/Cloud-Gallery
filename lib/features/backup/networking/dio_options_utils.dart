import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';

import 'package:json_annotation/json_annotation.dart';

part 'dio_options_utils.g.dart';

@JsonSerializable()
class NetworkIsolateBaseOptions extends Equatable {
  const NetworkIsolateBaseOptions({
    required this.baseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
    required this.sendTimeout,
    required this.contentType,
    required this.responseType,
    required this.headers,
  });

  NetworkIsolateBaseOptions.fromDio(BaseOptions options)
      : baseUrl = options.baseUrl,
        connectTimeout = options.connectTimeout,
        receiveTimeout = options.receiveTimeout,
        sendTimeout = options.sendTimeout,
        contentType = options.contentType,
        responseType = options.responseType,
        headers = options.headers;

  BaseOptions asDioBaseOptions() => BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        sendTimeout: sendTimeout,
        contentType: contentType,
        responseType: responseType,
        headers: headers..remove('content-type'),
        // headers: headers,
      );

  final String baseUrl;
  final int connectTimeout;
  final int receiveTimeout;
  final int sendTimeout;
  final String? contentType;
  final ResponseType responseType;
  final Map<String, dynamic> headers;

  NetworkIsolateBaseOptions copyWith({
    String? baseUrl,
    int? connectTimeout,
    int? receiveTimeout,
    int? sendTimeout,
    String? contentType,
    ResponseType? responseType,
    Map<String, dynamic>? headers,
  }) {
    return NetworkIsolateBaseOptions(
      baseUrl: baseUrl ?? this.baseUrl,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      sendTimeout: sendTimeout ?? this.sendTimeout,
      contentType: contentType ?? this.contentType,
      responseType: responseType ?? this.responseType,
      headers: headers ?? this.headers,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      baseUrl,
      connectTimeout,
      receiveTimeout,
      sendTimeout,
      contentType,
      responseType,
      headers,
    ];
  }

  static NetworkIsolateBaseOptions fromJson(Map<String, dynamic> json) => _$NetworkIsolateBaseOptionsFromJson(json);
  Map<String, dynamic> toJson() => _$NetworkIsolateBaseOptionsToJson(this);
}

extension BaseOptionsExt on BaseOptions {
  NetworkIsolateBaseOptions get asNetworkIsolateBaseOptions => NetworkIsolateBaseOptions.fromDio(this);
  // NetworkIsolateBaseOptions get asNetworkIsolateBaseOptions => NetworkIsolateBaseOptions(
  //       baseUrl: baseUrl,
  //       connectTimeout: connectTimeout,
  //       receiveTimeout: receiveTimeout,
  //       sendTimeout: sendTimeout,
  //       contentType: contentType,
  //       responseType: responseType,
  //       headers: headers,
  //     );
}
