import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
import 'package:graduation_project/app/theme/colors.dart';
import 'package:graduation_project/base/data/db/entities/graduate_entity.dart';
import 'package:moor/moor.dart';

enum BackupStatus {
  UPLOADED,
  CANCELED,
  PENDING,
  UPLOADING,
}

enum BackupModifier { PUBPLIC, PRIVATE }

extension BackupModifierExt on BackupModifier {
  String get raw => describeEnum(this);
  String get localizationKey => 'lbl_' + raw;
  material.IconButton getIcon(VoidCallback onPressed, {material.Color color = PRIMARY}) {
    late final material.IconData iconData;
    switch (this) {
      case BackupModifier.PRIVATE:
        iconData = material.Icons.sd_storage;
        break;
      case BackupModifier.PUBPLIC:
        iconData = material.Icons.cloud;
        break;
    }
    return material.IconButton(
      key: ValueKey(raw),
      icon: material.Icon(iconData),
      color: color,
      onPressed: onPressed,
    );
  }
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

  String get raw => describeEnum(this).toLowerCase();

  String get localizationKey => 'lbl_' + raw;
}

class Backups extends GraduateEntity {
  TextColumn get path => text()();

  TextColumn get mime => text()();

  BlobColumn get thumbData => blob()();

  TextColumn get assetId => text()();

  TextColumn get title => text().nullable()();

  IntColumn get status => intEnum<BackupStatus>().withDefault(Constant(BackupStatus.PENDING.index))();

  IntColumn get modifier => intEnum<BackupModifier>().withDefault(Constant(BackupModifier.PRIVATE.index))();

  DateTimeColumn get createdDate => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {assetId};
}
