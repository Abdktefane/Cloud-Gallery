import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'upload_model.g.dart';

@JsonSerializable()
class UploadModel extends Equatable {
  const UploadModel({
    required this.name,
    required this.type,
  });

  final String? name;
  final String? type;

  UploadModel copyWith({
    String? name,
    String? type,
  }) {
    return UploadModel(
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [name, type];

  static UploadModel fromJson(Object? json) => _$UploadModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$UploadModelToJson(this);
}
