import 'package:core_sdk/utils/extensions/list.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/domain/interactors/interactors.dart';
import 'package:graduation_project/base/domain/repositories/prefs_repository.dart';
import 'package:graduation_project/features/backup/domain/repositorires/backups_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:moor/moor.dart';
import 'package:photo_manager/photo_manager.dart';

const int _BUFFER_SIZE = 500;
const int _PAGE_SIZE = 100;

@injectable
class ImageSaveInteractor extends Interactor<bool> {
  ImageSaveInteractor(this._backupsRepository, this._prefsRepository);

  final BackupsRepository _backupsRepository;
  final PrefsRepository _prefsRepository;

  @override
  Future<void> doWork(bool params) async {
    try {
      if (await _backupsRepository.canStartSaveBackup() || params) {
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
      } else {
        print('sync image cancelled due to time constraint');
      }
    } catch (ex, st) {
      print('my debug image fetcher ex: $ex ,st: $st');
    }
  }

  // TODO(abd): UI Enhancement floating search and slideable list in db sections
  // TODO(abd): add empty uint8 list as no thumb image
  // TODO(abd): DB pagination on ahmad phone

  // TODO(abd): send asset id with upload add sync it with server when application first start move each container to done
  // TODO(abd): ask workmanager to do sync with power constraint and support foreground service
  // TODO(abd): upload image with small size image

  // TODO(abd): Hint don't change folder source while uploading
  Future<void> _saveFolder(AssetPathEntity folder) async {
    print('sync folder:${folder.name},count:${folder.assetCount}');
    final List<AssetEntity> imagesBuffer = [];
    int page = 0;
    bool canLoadMore = true;

    List<AssetEntity> images = [];
    try {
      while (canLoadMore) {
        try {
          images = await folder.getAssetListPaged(page, _PAGE_SIZE);
          if (images.isNullOrEmpty) {
            break;
          }
          imagesBuffer.addAll(images);
          if (imagesBuffer.length >= _BUFFER_SIZE) {
            await upsertNewImage(imagesBuffer, imagesBuffer: imagesBuffer);
          }
        } catch (ex, st) {
          print('exception while save folder ex: $ex, st: $st');
        } finally {
          page++;
          canLoadMore = images.length == _PAGE_SIZE;
        }
      }
      if (imagesBuffer.isNotEmpty) {
        await upsertNewImage(imagesBuffer);
      }
      _backupsRepository.saveLastSync(DateTime.now());
    } catch (ex, st) {
      print('exception while save folder ex: $ex, st: $st');
    } finally {}
  }

  Future<void> upsertNewImage(List<AssetEntity> images, {List<AssetEntity>? imagesBuffer}) async {
    await _backupsRepository.addNewImages(
      images,
      insertMode: InsertMode.insert,
      onConflict: (backups) => DoUpdate(
        (old) => const BackupsCompanion(needRestore: Value(true)),
        target: [backups.id, backups.title],
      ),
    );
    imagesBuffer?.clear();
    return;
  }
}

extension MimeExt on String? {
  bool get isImage => this?.split('/')[0] == 'image';
}
