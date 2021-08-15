import 'dart:async';

import 'package:collection/collection.dart';
import 'package:core_sdk/utils/network_result.dart';
import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/domain/interactors/interactors.dart';
import 'package:graduation_project/features/backup/domain/interactors/image_observer.dart';
import 'package:graduation_project/features/backup/domain/repositorires/backups_repository.dart';
import 'package:injectable/injectable.dart';

const int IMAGES_PER_UPLOAD = 1;

@injectable
class ImageUploaderInteractor extends Interactor<void> {
  ImageUploaderInteractor(this._backupsRepository, this._imageObserver);

  final BackupsRepository _backupsRepository;
  final ImageObserver _imageObserver;
  final Set<Backup> uploadQueue = const {};

  late final StreamSubscription<List<Backup>> _subscribe;
  late final StreamController<List<Backup>> _proxyStream;

  bool localImagesSynced = false;

  @override
  Future<void> doWork(void params) async {
    // producer
    _subscribe = _imageObserver.observe().listen(moveToQueue);
    _imageObserver(BackupStatus.PENDING);

    // consumer
    _proxyStream = StreamController<List<Backup>>();
    syncQueue();

    // wait for done signal
    await _proxyStream.done;

    // clean resources
    await clean();
  }

  // producer
  void moveToQueue(List<Backup> pendingImages) {
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
      // ignore: avoid_function_literals_in_foreach_calls
      images.forEach((image) async {
        _backupsRepository.updateBackups([image.copyWith(status: BackupStatus.UPLOADING)]);
        bool isSuccess = false;
        while (!isSuccess) {
          isSuccess = (await _backupsRepository.uploadImages([image])).isSuccess;
        }
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
      _proxyStream.done;
    }
  }

  Future<void> clean() async {
    await _subscribe.cancel();
    return _imageObserver.dispose();
  }
}
