import 'package:core_sdk/utils/extensions/list.dart';
import 'package:graduation_project/base/domain/interactors/interactors.dart';
import 'package:graduation_project/features/backup/domain/repositorires/backups_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';

@injectable
class ImageSyncInteractor extends Interactor<void> {
  ImageSyncInteractor(this._backupsRepository);

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

        gallery.forEach(_syncFolder);
      } else {
        throw UnimplementedError('user not admit permission');
      }
    } catch (ex) {
      print('my debug image fetcher with $ex');
    }
  }

  // TODO(abd): measure performance diff between db batch vs db pagination in insert (add buffer each 250 image or 500)
  // TODO(abd): save last time sync happen and if it's more than 12 hour ask workmanager to do sync with power constraint and support foreground service
  // TODO(abd): find solve to mobx null stram value
  // TODO(abd): isolate for networking to upload backup to server
  // TODO(abd): add DB quert to get pagesize unploaded image and upload them with ui refresh
  // TODO(abd): add stagred animation to lists
  // TODO(abd): find solve to pagination reactive stram
  // TODO(abd): find best arch to support multiple isolate (read moor code)
  Future<void> _syncFolder(AssetPathEntity folder) async {
    print('sync folder:${folder.name},count:${folder.assetCount}');
    const pageSize = 50;
    int page = 0;
    bool canLoadMore = true;

    while (canLoadMore) {
      final images = await folder.getAssetListPaged(page, pageSize);
      if (images.isNullOrEmpty) {
        return;
      }
      _backupsRepository.addNewImages(images);
      page++;
      canLoadMore = images.length == pageSize;
    }
  }
}

extension MimeExt on String? {
  bool get isImage => this?.split('/')[0] == 'image';
}
