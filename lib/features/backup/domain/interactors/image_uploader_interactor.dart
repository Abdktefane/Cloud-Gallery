import 'dart:async';

import 'package:core_sdk/utils/Fimber/Logger.dart';
import 'package:core_sdk/utils/extensions/future.dart';
import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/data/models/upload_model.dart';
import 'package:graduation_project/base/domain/interactors/interactors.dart';
import 'package:graduation_project/features/backup/domain/repositorires/backups_repository.dart';
import 'package:injectable/injectable.dart';

const int IMAGES_PER_UPLOAD = 1;

@injectable
class ImageUploaderInteractor extends Interactor<void> {
  ImageUploaderInteractor(this._backupsRepository, this._logger);

  final BackupsRepository _backupsRepository;
  final Set<Backup> uploadQueue = {};
  final Logger _logger;

  bool localImagesSynced = false;

  @override
  Future<void> doWork(void params) async {
    try {
      _logger.d('ImageUploader Started ...');

      // producer
      moveToQueue(await _backupsRepository.getBackupsByStatus(
        status: BackupStatus.PENDING,
        modifier: BackupModifier.PRIVATE,
        asc: false,
      ));

      // consumer
      return syncQueue();
    } catch (ex) {
      _logger.e('ImageUploaderInteractor exception $ex');
      rethrow;
    }
  }

  // producer
  void moveToQueue(List<Backup> pendingImages) {
    _logger.d('ImageUploader moveToQueue (producer) images:${pendingImages.length}');
    localImagesSynced = pendingImages.isEmpty;
    if (!localImagesSynced) {
      uploadQueue.addAll(pendingImages);
    }
  }

  // consumer
  Future<void> syncQueue() async {
    final images = uploadQueue.toList();
    final length = images.length;
    for (var i = 0; i < length; i++) {
      final image = images[i];
      try {
        _logger.d('ImageUploader syncQueue try to upload ${image.assetId}');
        await changeImagesStatus([image], BackupStatus.UPLOADING);
        final UploadModel res = await uploadImages([images[i]]);
        _logger.d('ImageUploader syncQueue success upload ${image.assetId}');
        await changeImagesStatus([image.copyWith(serverPath: res.name)], BackupStatus.UPLOADED);
      } catch (ex, st) {
        await changeImagesStatus([image], BackupStatus.PENDING);
        _logger.e('ImageUploader upload fail id: ${image.assetId},cause: $ex, st: $st');
      }
    }
    uploadQueue.clear();
  }

  Future<UploadModel> uploadImages(List<Backup> images) =>
      _backupsRepository.uploadImages(images).whenSuccess((res) => res!);

  Future<void> changeImagesStatus(List<Backup> images, BackupStatus status) =>
      _backupsRepository.updateBackups(images.map((it) => it.copyWith(status: status)).toList());
}


// @injectable
// class ImageUploaderObserver extends SubjectInteractor<void, String> {
//   ImageUploaderObserver(this._backupsRepository, this._logger);

//   final BackupsRepository _backupsRepository;
//   final Set<Backup> uploadQueue = {};
//   final Logger _logger;

//   bool localImagesSynced = false;

//   @override
//   Stream<String> createObservable(void params) async* {
//     try {
//       _logger.d('ImageUploader Started ...');

//       // producer
//       moveToQueue(await _backupsRepository.getBackupsByStatus(
//         status: BackupStatus.PENDING,
//         modifier: BackupModifier.PRIVATE,
//         asc: false,
//       ));

//       // consumer
//       yield* syncQueue();
//     } catch (ex) {
//       _logger.e('ImageUploaderInteractor exception $ex');
//     }
//   }

//   // producer
//   void moveToQueue(List<Backup> pendingImages) {
//     _logger.d('ImageUploader moveToQueue (producer) images:${pendingImages.length}');
//     localImagesSynced = pendingImages.isEmpty;
//     if (!localImagesSynced) {
//       uploadQueue.addAll(pendingImages);
//     }
//   }

//   // consumer
//   Stream<String> syncQueue() async* {
//     final images = uploadQueue.toList();
//     final length = images.length;
//     for (var i = 0; i < length; i++) {
//       final image = images[i];
//       try {
//         _logger.d('ImageUploader syncQueue try to upload ${image.assetId}');
//         await changeImagesStatus([image], BackupStatus.UPLOADING);
//         await uploadImages([images[i]]);
//         _logger.d('ImageUploader syncQueue success upload ${image.assetId}');
//         await changeImagesStatus([image], BackupStatus.UPLOADED);
//       } catch (ex, st) {
//         await changeImagesStatus([image], BackupStatus.PENDING);
//         _logger.e('ImageUploader upload fail id: ${image.assetId},cause: $ex, st: $st');
//       } finally {
//         yield ((i / length) * 100).toStringAsFixed(0) + '%';
//       }
//     }
//   }

//   Future<bool> uploadImages(List<Backup> images) =>
//       _backupsRepository.uploadImages(images).then((res) => res.isSuccess || res.getOrThrow()!);

//   Future<void> changeImagesStatus(List<Backup> images, BackupStatus status) =>
//       _backupsRepository.updateBackups(images.map((it) => it.copyWith(status: status)).toList());
// }
