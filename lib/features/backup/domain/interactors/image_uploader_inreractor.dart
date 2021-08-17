import 'dart:async';

import 'package:collection/collection.dart';
import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/utils/network_result.dart';
import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/domain/interactors/interactors.dart';
import 'package:graduation_project/features/backup/domain/interactors/image_observer.dart';
import 'package:graduation_project/features/backup/domain/repositorires/backups_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

const int IMAGES_PER_UPLOAD = 1;

@injectable
class ImageUploaderInteractor extends Interactor<void> {
  ImageUploaderInteractor(this._backupsRepository, this._pendingImageObserver, this._logger);

  final BackupsRepository _backupsRepository;
  final ImageObserver _pendingImageObserver;
  final Set<Backup> uploadQueue = {};
  final Logger _logger;

  late final StreamSubscription<List<Backup>> _pendingImagesubscribe;
  late final StreamController<List<Backup>> _proxyStream;

  bool localImagesSynced = false;

  @override
  Future<void> doWork(void params) async {
    try {
      _logger.d('ImageUploader Started ...');

      // producer
      // _subscribe = _imageObserver.observe().listen(moveToQueue);
      _pendingImagesubscribe =
          _pendingImageObserver.observe() /* .mergeWith([_uploadingImageObserver.observe()]) */ .listen(moveToQueue);

      _logger.d('ImageUploader 1');

      _logger.d('ImageUploader Started 2');

      _pendingImageObserver(BackupStatus.PENDING);
      _logger.d('ImageUploader Started 3');

      // _uploadingImageObserver(BackupStatus.UPLOADING);
      // _logger.d('ImageUploader Started 4');

      // consumer
      _proxyStream = StreamController<List<Backup>>();
      _logger.d('ImageUploader Started 5');

      syncQueue();

      _logger.d('ImageUploader Started 6');

      // wait for done signal
      await _proxyStream.done;

      _logger.d('ImageUploader Started 7');

      // clean resources
      await clean();
      _logger.d('ImageUploader Started 8');
    } catch (ex) {
      _logger.e('ImageUploaderInteractor exception $ex');
    }
  }

  // producer
  void moveToQueue(List<Backup> pendingImages) {
    _logger.d('ImageUploader moveToQueue (producer) images:$pendingImages');
    localImagesSynced = pendingImages.isEmpty;
    checkStopCondition();
    if (!localImagesSynced) {
      uploadQueue.addAll(pendingImages);
      _proxyStream.add(uploadQueue.toList());
    }
  }

  // consumer
  Future<void> syncQueue() async {
    await for (final List<Backup> images in _proxyStream.stream) {
      _logger.d('ImageUploader syncQueue (consumer) images:$images');
      // ignore: avoid_function_literals_in_foreach_calls
      images.forEach((image) async {
        _backupsRepository.updateBackups([image.copyWith(status: BackupStatus.UPLOADING)]);
        bool isSuccess = false;
        while (!isSuccess) {
          _logger.d('ImageUploader syncQueue try to upload $image');
          isSuccess = (await _backupsRepository.uploadImages([image])).isSuccess;
        }
        _logger.d('ImageUploader syncQueue success upload $image');
        _backupsRepository.updateBackups([image.copyWith(status: BackupStatus.UPLOADED)]);
        uploadQueue.remove(image);
      });

      checkStopCondition();
    }
  }
  // Future<void> syncQueue() async {
  //   await for (final List<Backup> images in _proxyStream.stream) {
  //     final List<Future<NetworkResult<bool?>>> futures =
  //         images.map((it) => _backupsRepository.uploadImages([it])).toList();

  //     final List<NetworkResult<bool?>> uploadResults = await Future.wait(futures);

  //     uploadResults.forEachIndexedWhile((index, element) {
  //       final uploadedItem = uploadQueue.elementAt(index);
  //       uploadQueue.remove(uploadedItem);
  //       _backupsRepository.updateBackups([uploadedItem.copyWith(status: BackupStatus.UPLOADED)]);
  //       return element.isSuccess;
  //     });

  //     checkStopCondition();
  //   }
  // }

  void checkStopCondition() {
    if (localImagesSynced && uploadQueue.isEmpty) {
      _logger.d('ImageUploader stopeed with stop condition');

      _proxyStream.done;
    }
  }

  Future<void> clean() async {
    await _pendingImagesubscribe.cancel();
    return _pendingImageObserver.dispose();
  }
}
