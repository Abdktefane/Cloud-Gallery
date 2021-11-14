import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:graduation_project/features/backup/data/mappers/backup_mapper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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

// String applicationDir() => getDiskPrefix() + ' Download/' + kSyncFolderName;

Future<String> getApplicationPath() async {
  try {
    if (await Permission.storage.request().isGranted) {
      final path = await findLocalPath(forDownload: true);
      // final path = (await findLocalPath(forDownload: true)) + '/$kSyncFolderName/';
      final savedDir = Directory(path);
      if (!savedDir.existsSync()) {
        savedDir.create();
      }
      return path;
    } else
      throw Exception('Error: Unable to get STORAGE permission!');
  } catch (e) {
    print(e);
    throw Exception('Error: Unable to get STORAGE permission!');
  }
}

Future<String> findLocalPath({bool forDownload = false}) async {
  return '/storage/emulated/0/$kSyncFolderName';
  // return '/storage/emulated/0/Pictures/$kSyncFolderName';
  final directory = Platform.isAndroid
      ? forDownload
          ? Directory('/storage/emulated/0/Download')
          : await (getExternalStorageDirectory() as FutureOr<Directory>)
      : await getApplicationDocumentsDirectory();
  return directory.path;
}

// Future<String> findLocalPath({bool forDownload = false}) async {
//   final directory = Platform.isAndroid
//       ? forDownload
//           ? Directory('/storage/emulated/0/Download')
//           : await (getExternalStorageDirectory() as FutureOr<Directory>)
//       : await getApplicationDocumentsDirectory();
//   return directory.path;
// }
