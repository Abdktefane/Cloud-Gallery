import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:dio/dio.dart';

part 'form_data_model.g.dart';

@JsonSerializable()
class FormDataRow extends Equatable {
  const FormDataRow({
    this.isImage = true,
    required this.key,
    required this.value,
  });

  final bool isImage;
  final String key;
  final String value;

  FormDataRow copyWith({
    bool? isImage,
    String? key,
    String? value,
  }) {
    return FormDataRow(
      isImage: isImage ?? this.isImage,
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [isImage, key, value];

  static FormDataRow fromJson(Map<String, dynamic> json) => _$FormDataRowFromJson(json);

  Map<String, dynamic> toJson() => _$FormDataRowToJson(this);
}

extension FormDataRowsExt on List<FormDataRow>? {
  Future<FormData> asBody() async {
    final result = <String, dynamic>{};
    if (this != null) {
      for (final it in this!) {
        final entry = MapEntry(
          it.key,
          it.isImage
              ? await MultipartFile.fromFile(
                  it.value,
                  filename: it.value.split('/').last,
                )
              : it.value,
        );
        result.addEntries([entry]);
      }
    }

    return FormData.fromMap(result);
  }
}
