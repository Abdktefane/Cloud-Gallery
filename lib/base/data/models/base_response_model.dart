import 'package:equatable/equatable.dart';
import 'package:graduation_project/base/utils/base_mapper.dart';
import 'package:json_annotation/json_annotation.dart';

part 'base_response_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseResponseModel<T> extends Equatable {
  @JsonKey(name: 'status')
  final int? statusCode;
  final String? message;
  final T? data;
  final String? error;
  final String? timestamp;

  BaseResponseModel({
    this.statusCode,
    this.message,
    this.data,
    this.error,
    this.timestamp,
  });

  BaseResponseModel<T> copyWith({
    int? statusCode,
    String? message,
    T? data,
    String? error,
    String? timestamp,
  }) {
    return BaseResponseModel<T>(
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      data: data ?? this.data,
      error: error ?? this.error,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      statusCode,
      message,
      data,
      error,
      timestamp,
    ];
  }

  static BaseResponseModel _fromJson<T>(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$BaseResponseModelFromJson(json, fromJsonT);

  static BaseResponseModel<Null> Function(Map<String, dynamic>) get noDataMapper =>
      (Map<String, dynamic> baseJson) => _$BaseResponseModelFromJson(baseJson, (_) => null);

  static String? Function(Map<String, dynamic>) get successMessageMapper =>
      (Map<String, dynamic> baseJson) => _$BaseResponseModelFromJson(baseJson, (_) => Null).message;

  static bool? Function(Object?) get successMapper => (Object? baseJson) =>
      _$BaseResponseModelFromJson(baseJson as Map<String, dynamic>, (_) => Null).statusCode == 200;

  static BaseMapper<R> fromJson<R>(
    R Function(Object?) fromJsonT,
  ) =>
      (Object? baseJson) => _$BaseResponseModelFromJson(
            baseJson as Map<String, dynamic>,
            fromJsonT,
            // fromJsonT,
          );

  // static PaginationMapper<R> fromJsonWithPagination<R>(
  //   R Function(Object) fromJsonT,
  // ) =>
  //     (Object? baseJson) => _$BaseResponseModelFromJson<PaginationResponse<R>>(
  //           baseJson as Map<String, dynamic>,
  //           (Object? paginationJson) => PaginationResponse.fromJson<R>(
  //             paginationJson as Map<String, dynamic>,
  //             fromJsonT as R Function(Object?),
  //           ),
  //         );

  Map<String, dynamic> toJson(
    Object Function(T? value) toJsonT,
  ) =>
      _$BaseResponseModelToJson(this, toJsonT);
}
