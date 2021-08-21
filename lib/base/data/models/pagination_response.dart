import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pagination_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class PaginationResponse<T> extends Equatable {
  const PaginationResponse({
    required this.data,
    required this.meta,
  });

  final List<T>? data;
  final MetaModel? meta;

  @override
  bool get stringify => true;

  static PaginationResponse<T> fromJson<T>(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PaginationResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(
    Object Function(T value) toJsonT,
  ) =>
      _$PaginationResponseToJson(this, toJsonT);

  @override
  List<Object?> get props => [data, meta];

  PaginationResponse<T> copyWith({
    List<T>? data,
    MetaModel? meta,
  }) {
    return PaginationResponse<T>(
      data: data ?? this.data,
      meta: meta ?? this.meta,
    );
  }
}

@JsonSerializable()
class MetaModel extends Equatable {
  const MetaModel({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
  });

  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;

  MetaModel copyWith({
    int? currentPage,
    int? lastPage,
    int? perPage,
    int? total,
  }) {
    return MetaModel(
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      perPage: perPage ?? this.perPage,
      total: total ?? this.total,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [currentPage, lastPage, perPage, total];

  static MetaModel fromJson(Object? json) => _$MetaModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$MetaModelToJson(this);
}
