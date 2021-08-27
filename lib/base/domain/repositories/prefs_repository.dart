import 'package:flutter/foundation.dart';

abstract class PrefsRepository {
  String? get token;
  Future<bool> setToken(String token);

  bool? get deviceRegistered;
  Future<bool> setDeviceRegistered(bool status);

  String? get refreshToken;
  Future<bool> setRefreshToken(String refreshToken);

  String? get fbToken;
  Future<bool> setFbToken(String? fbToken);

  String? get baseUrl;
  Future<bool> setBaseUrl(String baseUrl);

  ImageFileSource get imageFileSource;
  Future<bool> setImageFileSource(ImageFileSource imageFileSource);

  String? get languageCode;
  Future<bool> setApplicationLanguage(String languageCode);

  int? get siteId;
  Future<bool> setSiteId(int siteId);

  List<String>? get uploadedFiles;
  Future<bool> setUploadedFiles(List<String> uploadedFiles);

  DateTime? get lastServerSync;
  Future<bool> setLastServerSync(DateTime lastSyncDate);

  // ProfileModel? get profile;
  // Future<bool> setProfile(ProfileModel? profile);

  Future<void> clearUserData();
}

const String kSyncFolderName = 'SmartGallery';
enum ImageFileSource { ALL, FOLDER }

extension ImageFileSourceExt on ImageFileSource {
  String get raw => describeEnum(this);
  String get localizationKey => 'lbl_' + raw.toLowerCase();
  static ImageFileSource fromIndex(int? index) =>
      index == null || index == 1 ? ImageFileSource.FOLDER : ImageFileSource.ALL;
}
