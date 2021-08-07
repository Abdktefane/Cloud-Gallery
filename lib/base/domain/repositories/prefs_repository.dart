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

  String? get languageCode;
  Future<bool> setApplicationLanguage(String languageCode);

  int? get siteId;
  Future<bool> setSiteId(int siteId);

  List<String>? get uploadedFiles;
  Future<bool> setUploadedFiles(List<String> uploadedFiles);

  // ProfileModel? get profile;
  // Future<bool> setProfile(ProfileModel? profile);

  Future<void> clearUserData();
}
