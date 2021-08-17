import 'package:core_sdk/utils/extensions/list.dart';
import 'package:graduation_project/base/domain/interactors/interactors.dart';
import 'package:graduation_project/features/backup/domain/interactors/image_uploader_inreractor.dart';
import 'package:graduation_project/features/backup/domain/repositorires/backups_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';

const int _BUFFER_SIZE = 250;
const int _PAGE_SIZE = 50;

@injectable
class ImageSyncInteractor extends Interactor<void> {
  ImageSyncInteractor(this._backupsRepository, this._imageUploaderInteractor);

  final BackupsRepository _backupsRepository;
  final ImageUploaderInteractor _imageUploaderInteractor;

  @override
  Future<void> doWork(void params) async {
    try {
      // _startUploadInteractor();
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
        await _syncFolder(gallery.first);
        // gallery.forEach( _syncFolder);

      } else {
        throw UnimplementedError('user not admit permission');
      }
    } catch (ex) {
      print('my debug image fetcher with $ex');
    }
  }

  // TODO(abd): save last time sync happen and if it's more than 12 hour ask workmanager to do sync with power constraint and support foreground service
  // TODO(abd): find solve to mobx null stram value
  // TODO(abd): isolate for networking to upload backup to server
  // TODO(abd): add DB quert to get pagesize unploaded image and upload them with ui refresh
  // TODO(abd): add stagred animation to lists
  // TODO(abd): find solve to pagination reactive stram
  // TODO(abd): find best arch to support multiple isolate (read moor code)
  Future<void> _syncFolder(AssetPathEntity folder) async {
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
          _backupsRepository.addNewImages(imagesBuffer);
          imagesBuffer.clear();
        }
        page++;
        canLoadMore = images.length == _PAGE_SIZE;
      }
      if (imagesBuffer.isNotEmpty) {
        _backupsRepository.addNewImages(imagesBuffer);
      }
      _backupsRepository.saveLastSync(DateTime.now());
      // TODO(abd): we must start upload proccess when finish move images to database
      // _startUploadInteractor();
    } else {
      print('sync image cancelled due to time constraint');
    }
  }

  void _startUploadInteractor() {
    _imageUploaderInteractor(1, timeout: const Duration(hours: 2)).listen((event) {});
  }
}

extension MimeExt on String? {
  bool get isImage => this?.split('/')[0] == 'image';
}
