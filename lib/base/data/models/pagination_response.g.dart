// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationResponse<T> _$PaginationResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) {
  return PaginationResponse<T>(
    data: (json['data'] as List<dynamic>?)?.map(fromJsonT).toList(),
    meta: json['meta'] == null
        ? null
        : MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PaginationResponseToJson<T>(
  PaginationResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'data': instance.data?.map(toJsonT).toList(),
      'meta': instance.meta,
    };

MetaModel _$MetaModelFromJson(Map<String, dynamic> json) {
  return MetaModel(
    currentPage: json['currentPage'] as int?,
    lastPage: json['lastPage'] as int?,
    perPage: json['perPage'] as int?,
    total: json['total'] as int?,
  );
}

Map<String, dynamic> _$MetaModelToJson(MetaModel instance) => <String, dynamic>{
      'currentPage': instance.currentPage,
      'lastPage': instance.lastPage,
      'perPage': instance.perPage,
      'total': instance.total,
    };
