// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_base_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListBaseResponseModel<T> _$ListBaseResponseModelFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) {
  return ListBaseResponseModel<T>(
    statusCode: json['status'] as int?,
    message: json['message'] as String?,
    data: (json['data'] as List<dynamic>?)?.map(fromJsonT).toList(),
    error: json['error'] as String?,
    timestamp: json['timestamp'] as String?,
  );
}

Map<String, dynamic> _$ListBaseResponseModelToJson<T>(
  ListBaseResponseModel<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'status': instance.statusCode,
      'message': instance.message,
      'data': instance.data?.map(toJsonT).toList(),
      'error': instance.error,
      'timestamp': instance.timestamp,
    };
