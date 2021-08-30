import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
import 'package:graduation_project/app/theme/colors.dart';
import 'package:graduation_project/base/data/db/entities/graduate_entity.dart';
import 'package:moor/moor.dart';

import '../graduate_db.dart';

enum BackupStatus {
  UPLOADED,
  CANCELED,
  UPLOADING,
  // PENDING,
}

enum BackupModifier { PUBPLIC, PRIVATE }

extension BackupModifierExt on BackupModifier {
  String get raw => describeEnum(this);
  String get localizationKey => 'lbl_' + raw;
  BackupModifier get negate => this == BackupModifier.PRIVATE ? BackupModifier.PUBPLIC : BackupModifier.PRIVATE;
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
      // case BackupStatus.PENDING:
      //   return material.Icons.timelapse;
      // return material.Icons.timelapse;
      case BackupStatus.UPLOADING:
        return material.Icons.circle;
      // case BackupStatus.NEED_RESTORE:
      //   return material.Icons.stop;
    }
  }

  String get raw => describeEnum(this).toLowerCase();

  String get localizationKey => 'lbl_' + raw;
}

class Backups extends GraduateEntity {
  TextColumn get path => text().nullable()();

  BlobColumn get thumbData => blob()();

  TextColumn get id => text()();

  // TextColumn get title => text().nullable()();
  TextColumn get title => text().nullable().customConstraint('UNIQUE')();

  TextColumn get serverPath => text().nullable()();

  IntColumn get status => intEnum<BackupStatus>().withDefault(Constant(BackupStatus.UPLOADED.index))();

  IntColumn get modifier => intEnum<BackupModifier>().withDefault(Constant(BackupModifier.PRIVATE.index))();

  BoolColumn get needRestore => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdDate => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

extension BackupExtension on Backup {
  bool get pending => path == null;
}

extension BackupsCompanionExt on BackupsCompanion {
  static BackupsCompanion fromJson(Object? json) {
    json as Map<String, dynamic>;

    return BackupsCompanion(
      // created date + path + title
      serverPath: Value(json['name']),
      title: Value(json['name']),
      id: Value(json['identifier']),
      modifier: Value(json['isPublic'] == true ? BackupModifier.PUBPLIC : BackupModifier.PRIVATE),
      thumbData: Value(base64.decode(json['thump'])),
      needRestore: const Value(true),
      status: const Value(BackupStatus.UPLOADED),
    );
  }
}
