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
import 'package:collection/collection.dart';

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
      // _pendingImagesubscribe = _pendingImageObserver.observe().listen(moveToQueue);
      // _pendingImageObserver(ImageObserver.params(
      //   status: BackupStatus.PENDING,
      //   modifier: BackupModifier.PRIVATE,
      //   asc: false,
      // ));
      _proxyStream = StreamController<List<Backup>>();

      moveToQueue(await _backupsRepository.getBackupsByStatus(
        status: BackupStatus.PENDING,
        modifier: BackupModifier.PRIVATE,
        asc: false,
      ));

      // consumer
      syncQueue();

      // wait for done signal
      await _proxyStream.done;

      // clean resources
      _logger.d('ImageUploader done');
      return clean();
    } catch (ex) {
      _logger.e('ImageUploaderInteractor exception $ex');
    }
  }

  // producer
  void moveToQueue(List<Backup> pendingImages) {
    _logger.d('ImageUploader moveToQueue (producer) images:${pendingImages.length}');
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
      _logger.d('ImageUploader syncQueue (consumer) images:${images.length}');
      // ignore: avoid_function_literals_in_foreach_calls
      for (final image in images) {
        try {
          _logger.d('ImageUploader syncQueue try to upload ${image.assetId}');
          await changeImagesStatus([image], BackupStatus.UPLOADING);
          await uploadImages([image]);
          await changeImagesStatus([image], BackupStatus.UPLOADED);
        } catch (ex, st) {
          await changeImagesStatus([image], BackupStatus.PENDING);
          _logger.e('ImageUploader upload fail id: ${image.assetId},cause: $ex, st: $st');
        }
        // while (!isSuccess) {
        //   try {
        //     _logger.d('ImageUploader syncQueue try to upload ${image.assetId}');
        //     await changeImagesStatus([image], BackupStatus.UPLOADING);
        //     isSuccess = await uploadImages([image]);
        //   } catch (ex, st) {
        //     await changeImagesStatus([image], BackupStatus.PENDING);
        //     _logger.e('ImageUploader upload fail id: ${image.assetId},cause: $ex, st: $st');
        //   }
        // }
        _logger.d('ImageUploader syncQueue success upload ${image.assetId}');

        uploadQueue.remove(image);
      }

      checkStopCondition();
    }
  }

  Future<bool> uploadImages(List<Backup> images) =>
      _backupsRepository.uploadImages(images).then((res) => res.isSuccess || res.getOrThrow()!);

  Future<void> changeImagesStatus(List<Backup> images, BackupStatus status) =>
      _backupsRepository.updateBackups(images.map((it) => it.copyWith(status: status)).toList());

  void checkStopCondition() {
    if (localImagesSynced && uploadQueue.isEmpty) {
      _logger.d('ImageUploader stopeed with stop condition');
      _proxyStream.done;
    }
  }

  Future<void> clean() async {
    await _pendingImagesubscribe.cancel();
    // return _pendingImageObserver.dispose();
  }
}
