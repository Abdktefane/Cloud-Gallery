import 'package:core_sdk/utils/extensions/list.dart';
import 'package:graduation_project/base/domain/interactors/interactors.dart';
import 'package:graduation_project/base/domain/repositories/prefs_repository.dart';
import 'package:graduation_project/features/backup/domain/interactors/image_uploader_interactor.dart';
import 'package:graduation_project/features/backup/domain/repositorires/backups_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';

const int _BUFFER_SIZE = 500;
const int _PAGE_SIZE = 100;

@injectable
class ImageSaveInteractor extends Interactor<void> {
  ImageSaveInteractor(this._backupsRepository, this._prefsRepository);

  final BackupsRepository _backupsRepository;
  final PrefsRepository _prefsRepository;

  @override
  Future<void> doWork(void params) async {
    try {
      final permission = await PhotoManager.requestPermissionExtend();
      if (permission.isAuth) {
        late List<AssetPathEntity> gallery;
        if (_prefsRepository.imageFileSource == ImageFileSource.ALL) {
          gallery = await PhotoManager.getAssetPathList(
            type: RequestType.image,
            hasAll: true,
            onlyAll: true,
          );
        } else {
          gallery = await PhotoManager.getAssetPathList(
            type: RequestType.image,
          );
          int i = 0;
          gallery = gallery.where((it) => it.name == kSyncFolderName).toList();
        }

        if (gallery.isNullOrEmpty) {
          print('gallery is empty');
          return;
        }
        return _saveFolder(gallery.first);
        // gallery.forEach(_saveFolder);
      } else {
        throw UnimplementedError('user not admit permission');
      }
    } catch (ex, st) {
      print('my debug image fetcher ex: $ex ,st: $st');
    }
  }

  // TODO(abd): UI Enhancement floating search and slideable list in db sections
  // TODO(abd): solve double reaction when search
  // TODO(abd): add empty uint8 list as no thumb image
  // TODO(abd): DB pagination on ahmad phone

  // TODO(abd): send asset id with upload add sync it with server when application first start move each container to done
  // TODO(abd): long tab on image sync icon to start upload immediatly
  // TODO(abd): force sync to overcome last_sync conditions
  // TODO(abd): save last time sync happen and if it's more than 12 hour ask workmanager to do sync with power constraint and support foreground service
  // TODO(abd): upload image with small size image

  // TODO(abd): empty database when logout
  // TODO(abd): move every thing in uploading to pending when close app

  // TODO(abd): Hint don't change folder source while uploading
  Future<void> _saveFolder(AssetPathEntity folder) async {
    if (await _backupsRepository.canStartSaveBackup()) {
      print('sync folder:${folder.name},count:${folder.assetCount}');
      final List<AssetEntity> imagesBuffer = [];
      int page = 0;
      bool canLoadMore = true;

      List<AssetEntity> images = [];

      while (canLoadMore) {
        try {
          images = await folder.getAssetListPaged(page, _PAGE_SIZE);
          if (images.isNullOrEmpty) {
            break;
          }
          imagesBuffer.addAll(images);
          if (imagesBuffer.length >= _BUFFER_SIZE) {
            await _backupsRepository.addNewImages(imagesBuffer);
            imagesBuffer.clear();
          }

          if (imagesBuffer.isNotEmpty) {
            await _backupsRepository.addNewImages(imagesBuffer);
          }
          _backupsRepository.saveLastSync(DateTime.now());
        } catch (ex, st) {
          print('exception while save folder ex: $ex, st: $st');
        } finally {
          page++;
          canLoadMore = images.length == _PAGE_SIZE;
        }
      }
    } else {
      print('sync image cancelled due to time constraint');
    }
  }
}

extension MimeExt on String? {
  bool get isImage => this?.split('/')[0] == 'image';
}
