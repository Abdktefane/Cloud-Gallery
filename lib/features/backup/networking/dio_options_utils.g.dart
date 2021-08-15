// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_options_utils.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkIsolateBaseOptions _$NetworkIsolateBaseOptionsFromJson(
    Map<String, dynamic> json) {
  return NetworkIsolateBaseOptions(
    baseUrl: json['baseUrl'] as String,
    connectTimeout: json['connectTimeout'] as int,
    receiveTimeout: json['receiveTimeout'] as int,
    sendTimeout: json['sendTimeout'] as int,
    contentType: json['contentType'] as String?,
    responseType: _$enumDecode(_$ResponseTypeEnumMap, json['responseType']),
    headers: json['headers'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$NetworkIsolateBaseOptionsToJson(
        NetworkIsolateBaseOptions instance) =>
    <String, dynamic>{
      'baseUrl': instance.baseUrl,
      'connectTimeout': instance.connectTimeout,
      'receiveTimeout': instance.receiveTimeout,
      'sendTimeout': instance.sendTimeout,
      'contentType': instance.contentType,
      'responseType': _$ResponseTypeEnumMap[instance.responseType],
      'headers': instance.headers,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$ResponseTypeEnumMap = {
  ResponseType.json: 'json',
  ResponseType.stream: 'stream',
  ResponseType.plain: 'plain',
  ResponseType.bytes: 'bytes',
};
