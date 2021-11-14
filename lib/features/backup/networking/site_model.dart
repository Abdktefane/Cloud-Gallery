library site_model;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'site_model.g.dart';

@JsonSerializable()
class SiteModel extends Equatable {
  static final String className = 'SiteModel';

  SiteModel({
    required this.siteId,
    required this.countryCode,
    required this.phoneCode,
    required this.currencyCode,
    required this.siteName,
    required this.commissionPercent,
    required this.cashbackPercent,
    required this.taxPercent,
    required this.pointsRate,
    required this.redeemRate,
  });

  final int? siteId;
  final String? countryCode;
  final String? phoneCode;
  final String? currencyCode;
  final String? siteName;
  final double? commissionPercent;
  final double? cashbackPercent;
  final double? taxPercent;
  final double? pointsRate;
  final double? redeemRate;

  SiteModel copyWith({
    int? siteId,
    String? countryCode,
    String? phoneCode,
    String? currencyCode,
    String? siteName,
    double? commissionPercent,
    double? cashbackPercent,
    double? taxPercent,
    double? pointsRate,
    double? redeemRate,
  }) {
    return SiteModel(
      siteId: siteId ?? this.siteId,
      countryCode: countryCode ?? this.countryCode,
      phoneCode: phoneCode ?? this.phoneCode,
      currencyCode: currencyCode ?? this.currencyCode,
      siteName: siteName ?? this.siteName,
      commissionPercent: commissionPercent ?? this.commissionPercent,
      cashbackPercent: cashbackPercent ?? this.cashbackPercent,
      taxPercent: taxPercent ?? this.taxPercent,
      pointsRate: pointsRate ?? this.pointsRate,
      redeemRate: redeemRate ?? this.redeemRate,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      siteId,
      countryCode,
      phoneCode,
      currencyCode,
      siteName,
      commissionPercent,
      cashbackPercent,
      taxPercent,
      pointsRate,
      redeemRate,
    ];
  }

  String get phoneCodeWithPlus => '+' + phoneCode!;

  static SiteModel fromJson(Object? json) => _$SiteModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$SiteModelToJson(this);
}
