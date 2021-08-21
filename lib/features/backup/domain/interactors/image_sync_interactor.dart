import 'package:core_sdk/utils/extensions/list.dart';
import 'package:graduation_project/base/domain/interactors/interactors.dart';
import 'package:graduation_project/features/backup/domain/interactors/image_uploader_interactor.dart';
import 'package:graduation_project/features/backup/domain/repositorires/backups_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';

const int _BUFFER_SIZE = 1000;
const int _PAGE_SIZE = 250;

@injectable
class ImageSaveInteractor extends Interactor<void> {
  ImageSaveInteractor(this._backupsRepository);

  final BackupsRepository _backupsRepository;

  @override
  Future<void> doWork(void params) async {
    try {
      final permission = await PhotoManager.requestPermissionExtend();
      if (permission.isAuth) {
        final gallery = await PhotoManager.getAssetPathList(
          type: RequestType.image,
          hasAll: true,
          onlyAll: true,
        );
        if (gallery.isNullOrEmpty) {
          print('gallery is empty');
          return;
        }
        return _saveFolder(gallery.first);
        // gallery.forEach(_saveFolder);
      } else {
        throw UnimplementedError('user not admit permission');
      }
    } catch (ex) {
      print('my debug image fetcher with $ex');
    }
  }

  // TODO(abd): new feed if no serarch(recommend)
  // TODO(abd): find best way for image with text search
  // TODO(abd): add base url as textfiled in settings
  // TODO(abd): save last time sync happen and if it's more than 12 hour ask workmanager to do sync with power constraint and support foreground service
  // TODO(abd): empty database when logout
  Future<void> _saveFolder(AssetPathEntity folder) async {
    if (await _backupsRepository.canStartSaveBackup()) {
      print('sync folder:${folder.name},count:${folder.assetCount}');
      final List<AssetEntity> imagesBuffer = [];
      int page = 0;
      bool canLoadMore = true;

      while (canLoadMore) {
        final images = await folder.getAssetListPaged(page, _PAGE_SIZE);
        if (images.isNullOrEmpty) {
          break;
        }
        imagesBuffer.addAll(images);
        if (imagesBuffer.length >= _BUFFER_SIZE) {
          await _backupsRepository.addNewImages(imagesBuffer);
          imagesBuffer.clear();
        }
        page++;
        canLoadMore = images.length == _PAGE_SIZE;
      }
      if (imagesBuffer.isNotEmpty) {
        await _backupsRepository.addNewImages(imagesBuffer);
      }
      _backupsRepository.saveLastSync(DateTime.now());
    } else {
      print('sync image cancelled due to time constraint');
    }
  }
}

extension MimeExt on String? {
  bool get isImage => this?.split('/')[0] == 'image';
}
