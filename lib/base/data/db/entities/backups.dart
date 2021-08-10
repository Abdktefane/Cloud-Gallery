import 'package:flutter/material.dart' as material;
import 'package:graduation_project/base/data/db/entities/graduate_entity.dart';
import 'package:moor/moor.dart';

enum BackupStatus {
  UPLOADED,
  CANCELED,
  PENDING,
  UPLOADING,
}

extension BackupStatusExt on BackupStatus {
  material.IconData get icon {
    switch (this) {
      case BackupStatus.UPLOADED:
        return material.Icons.done;
      case BackupStatus.CANCELED:
        return material.Icons.cancel;
      case BackupStatus.PENDING:
        return material.Icons.timelapse;
      // return material.Icons.timelapse;
      case BackupStatus.UPLOADING:
        return material.Icons.circle;
    }
  }
}

class Backups extends GraduateEntity {
  TextColumn get path => text()();

  TextColumn get mime => text()();

  BlobColumn get thumbData => blob()();

  TextColumn get assetId => text()();

  TextColumn get title => text().nullable()();

  IntColumn get status => intEnum<BackupStatus>().withDefault(Constant(BackupStatus.PENDING.index))();

  @override
  Set<Column> get primaryKey => {assetId};
}
