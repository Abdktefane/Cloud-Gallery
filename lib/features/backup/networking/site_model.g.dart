// GENERATED CODE - DO NOT MODIFY BY HAND

part of site_model;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SiteModel _$SiteModelFromJson(Map<String, dynamic> json) {
  return SiteModel(
    siteId: json['siteId'] as int?,
    countryCode: json['countryCode'] as String?,
    phoneCode: json['phoneCode'] as String?,
    currencyCode: json['currencyCode'] as String?,
    siteName: json['siteName'] as String?,
    commissionPercent: (json['commissionPercent'] as num?)?.toDouble(),
    cashbackPercent: (json['cashbackPercent'] as num?)?.toDouble(),
    taxPercent: (json['taxPercent'] as num?)?.toDouble(),
    pointsRate: (json['pointsRate'] as num?)?.toDouble(),
    redeemRate: (json['redeemRate'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$SiteModelToJson(SiteModel instance) => <String, dynamic>{
      'siteId': instance.siteId,
      'countryCode': instance.countryCode,
      'phoneCode': instance.phoneCode,
      'currencyCode': instance.currencyCode,
      'siteName': instance.siteName,
      'commissionPercent': instance.commissionPercent,
      'cashbackPercent': instance.cashbackPercent,
      'taxPercent': instance.taxPercent,
      'pointsRate': instance.pointsRate,
      'redeemRate': instance.redeemRate,
    };
