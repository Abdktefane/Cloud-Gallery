import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_key_model.g.dart';

@JsonSerializable()
class SearchKeyModel extends Equatable {
  const SearchKeyModel({
    required this.key,
    required this.query,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  @JsonKey(name: 'id')
  final int? key;

  @JsonKey(name: 'data')
  final String? query;

  final int? type;
  final String? createdAt;
  final String? updatedAt;

  SearchKeyModel copyWith({
    int? key,
    String? query,
    int? type,
    String? createdAt,
    String? updatedAt,
  }) {
    return SearchKeyModel(
      key: key ?? this.key,
      query: query ?? this.query,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool get stringify => true;

  static SearchKeyModel fromJson(Object? json) => _$SearchKeyModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$SearchKeyModelToJson(this);

  @override
  List<Object?> get props {
    return [
      key,
      query,
      type,
      createdAt,
      updatedAt,
    ];
  }
}
