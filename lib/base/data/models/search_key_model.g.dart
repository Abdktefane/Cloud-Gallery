// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_key_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchKeyModel _$SearchKeyModelFromJson(Map<String, dynamic> json) {
  return SearchKeyModel(
    key: json['id'] as int?,
    query: json['data'] as String?,
    type: json['type'] as int?,
    createdAt: json['createdAt'] as String?,
    updatedAt: json['updatedAt'] as String?,
  );
}

Map<String, dynamic> _$SearchKeyModelToJson(SearchKeyModel instance) =>
    <String, dynamic>{
      'id': instance.key,
      'data': instance.query,
      'type': instance.type,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
