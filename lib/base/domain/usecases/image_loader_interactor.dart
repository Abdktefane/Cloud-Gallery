import 'package:graduation_project/base/utils/image_saver.dart';
import 'package:rxdart/rxdart.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:injectable/injectable.dart';

const int _PAGE_SIZE = 15;

abstract class SubjectInteractor<P, T> {
  final BehaviorSubject<P> _controller = BehaviorSubject<P>();

  void call(P params) => _controller.add(params);

  Stream<T> createObservable(P params);

  ValueStream<T> observe() => _controller.switchMap(
        (P value) => createObservable(value),
      ) as ValueStream<T>;

  // ignore: todo
  Future<void> dispose() => _controller.close();
}

@singleton
class ImageLoaderInteractor extends SubjectInteractor<int, AssetEntity> {
  ImageLoaderInteractor(this._imageSaver);

  final ImageSaver _imageSaver;
  late final AssetPathEntity _gallery;

  Future<AssetPathEntity> getGallery() async {
    if (_gallery != null) {
      return _gallery;
    }
    final result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      _gallery = (await PhotoManager.getAssetPathList(type: RequestType.image, onlyAll: true)).first;
      return _gallery;
    } else {
      throw UnimplementedError('user not admit permission');
      // fail
      /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
    }
  }

  @override
  Stream<AssetEntity> createObservable(int params) async* {
    final images = await (await getGallery()).getAssetListPaged(params, _PAGE_SIZE);
    yield* Stream.fromIterable(images.where((it) => !_imageSaver.isUploaded(it.id)));
  }
}
