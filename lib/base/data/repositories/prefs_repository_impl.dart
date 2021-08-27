import 'package:core_sdk/utils/constants.dart';
import 'package:graduation_project/base/domain/repositories/prefs_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

class PrefsRepositoryImpl implements PrefsRepository {
  const PrefsRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  String? get token => _prefs.getString(PreferencesKeys.USER_TOKEN);

  @override
  Future<bool> setToken(String token) => _prefs.setString(PreferencesKeys.USER_TOKEN, token);

  @override
  String? get fbToken => _prefs.getString(PreferencesKeys.FB_USER_TOKEN);

  @override
  Future<bool> setFbToken(String? fbToken) => _prefs.setString(PreferencesKeys.FB_USER_TOKEN, fbToken!);

  @override
  bool? get deviceRegistered => _prefs.getBool(PreferencesKeys.IS_DEVICE_REGISTERED);

  @override
  Future<bool> setDeviceRegistered(bool status) => _prefs.setBool(PreferencesKeys.IS_DEVICE_REGISTERED, status);

  @override
  String? get refreshToken => _prefs.getString(PreferencesKeys.USER_REFRESH_TOKEN);

  @override
  Future<bool> setRefreshToken(String refreshToken) =>
      _prefs.setString(PreferencesKeys.USER_REFRESH_TOKEN, refreshToken);

  @override
  String? get languageCode => _prefs.getString(PreferencesKeys.APP_LANGUAGE);

  @override
  Future<bool> setApplicationLanguage(String languageCode) =>
      _prefs.setString(PreferencesKeys.APP_LANGUAGE, languageCode);

  @override
  int? get siteId => _prefs.getInt(PreferencesKeys.SITE_ID);

  @override
  Future<bool> setSiteId(int siteId) => _prefs.setInt(PreferencesKeys.SITE_ID, siteId);

  @override
  String? get baseUrl => _prefs.getString(PreferencesKeys.API_BASE_URL);

  @override
  Future<bool> setBaseUrl(String baseUrl) => _prefs.setString(PreferencesKeys.API_BASE_URL, baseUrl);

  @override
  List<String>? get uploadedFiles => _prefs.getStringList(_UPLOADED_FILES_KEY);

  @override
  Future<bool> setUploadedFiles(List<String> uploadedFiles) => _prefs.setStringList(_UPLOADED_FILES_KEY, uploadedFiles);

  @override
  ImageFileSource get imageFileSource => ImageFileSourceExt.fromIndex(_prefs.getInt(_IMAGE_FILE_SOURCE));
  @override
  Future<bool> setImageFileSource(ImageFileSource imageFileSource) =>
      _prefs.setInt(_IMAGE_FILE_SOURCE, imageFileSource.index);
  @override
  DateTime? get lastServerSync {
    final milliSeconds = _prefs.getInt(_LAST_SERVER_SYNC_DATE);
    if (milliSeconds != null) {
      return DateTime.fromMillisecondsSinceEpoch(milliSeconds);
    }
    return null;
  }

  @override
  Future<bool> setLastServerSync(DateTime lastSyncDate) =>
      _prefs.setInt(_LAST_SERVER_SYNC_DATE, lastSyncDate.millisecondsSinceEpoch);

  // @override
  // Future<bool> setProfile(ProfileModel? profile) =>
  //     _prefs.setString(PreferencesKeys.USER_PROFILE, json.encode(profile!.toJson()));

  // @override
  // ProfileModel? get profile {
  //   final jsonProfile = _prefs.getString(PreferencesKeys.USER_PROFILE);
  //   return jsonProfile != null ? ProfileModel.fromJson(json.decode(jsonProfile)) : null;
  // }

  @override
  Future<void> clearUserData() async {
    await _prefs.remove(PreferencesKeys.SITE_ID);
    await _prefs.remove(PreferencesKeys.USER_TOKEN);
    await _prefs.remove(PreferencesKeys.USER_REFRESH_TOKEN);
    await _prefs.remove(PreferencesKeys.USER_PROFILE);
    await _prefs.remove(PreferencesKeys.CUSTOMER_PROFILE);
    await _prefs.remove(PreferencesKeys.IS_DEVICE_REGISTERED);
    await _prefs.remove(PreferencesKeys.FB_USER_TOKEN);
    await _prefs.remove(_UPLOADED_FILES_KEY);
    await _prefs.remove(_IMAGE_FILE_SOURCE);
  }
}

const String _UPLOADED_FILES_KEY = 'graduate_uploaded_files_key';
const String _IMAGE_FILE_SOURCE = 'image_file_source';
const String _LAST_SERVER_SYNC_DATE = 'last_server_sync_date';
