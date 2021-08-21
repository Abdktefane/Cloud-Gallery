// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormDataRow _$FormDataRowFromJson(Map<String, dynamic> json) {
  return FormDataRow(
    isImage: json['isImage'] as bool,
    key: json['key'] as String,
    value: json['value'] as String,
  );
}

Map<String, dynamic> _$FormDataRowToJson(FormDataRow instance) =>
    <String, dynamic>{
      'isImage': instance.isImage,
      'key': instance.key,
      'value': instance.value,
    };
