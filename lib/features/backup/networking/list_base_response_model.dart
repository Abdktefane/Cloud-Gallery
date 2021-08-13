import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'base_mappers.dart';

part 'list_base_response_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ListBaseResponseModel<T> extends Equatable {
  @JsonKey(name: 'status')
  final int? statusCode;
  final String? message;
  final List<T>? data;
  final String? error;
  final String? timestamp;

  ListBaseResponseModel({
    this.statusCode,
    this.message,
    this.data,
    this.error,
    this.timestamp,
  });

  ListBaseResponseModel<T> copyWith({
    int? statusCode,
    String? message,
    List<T>? data,
    String? error,
    String? timestamp,
  }) {
    return ListBaseResponseModel<T>(
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

  static ListBaseResponseModel _fromJson<T>(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ListBaseResponseModelFromJson(json, fromJsonT);

  static ListMapper<R> fromJson<R>(
    R Function(Object) fromJsonT,
  ) =>
      (Object? baseJson) => _$ListBaseResponseModelFromJson(
            baseJson as Map<String, dynamic>,
            (contentJson) => fromJsonT(contentJson as Object),
          );

  Map<String, dynamic> toJson(
    Object Function(T value) toJsonT,
  ) =>
      _$ListBaseResponseModelToJson(this, toJsonT);

  static ListBaseResponseModel<Null> Function(Map<String, dynamic>) get noDataMapper =>
      (Map<String, dynamic> baseJson) => _$ListBaseResponseModelFromJson(baseJson, (_) => null);
}
