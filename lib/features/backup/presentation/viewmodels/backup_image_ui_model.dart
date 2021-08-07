import 'package:equatable/equatable.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class UploadStatus {
  const UploadStatus();
}

class Pending extends UploadStatus {}

class Uploading extends UploadStatus with EquatableMixin {
  const Uploading(
    this.progress,
  );
  final int progress;

  Uploading copyWith({
    int? progress,
  }) {
    return Uploading(
      progress ?? this.progress,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [progress];
}

class Uploaded extends UploadStatus {}

class BackupImageUIModel extends Equatable {
  const BackupImageUIModel({
    required this.image,
    required this.status,
  });

  static BackupImageUIModel fromAsset({required AssetEntity image}) {
    return BackupImageUIModel(image: image, status: Pending());
  }

  final AssetEntity image;
  final UploadStatus status;

  BackupImageUIModel copyWith({
    AssetEntity? image,
    UploadStatus? status,
  }) {
    return BackupImageUIModel(
      image: image ?? this.image,
      status: status ?? this.status,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [image, status];
}
