import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_result_model.g.dart';

@JsonSerializable()
class SearchResultModel extends Equatable {
  const SearchResultModel({
    this.id,
    this.data,
    this.score,
  });

  final int? id;
  final String? data;
  final double? score;

  SearchResultModel copyWith({
    int? id,
    String? data,
    double? score,
  }) {
    return SearchResultModel(
      id: id ?? this.id,
      data: data ?? this.data,
      score: score ?? this.score,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, data, score];

  static SearchResultModel fromJson(Object? json) => _$SearchResultModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$SearchResultModelToJson(this);
}
