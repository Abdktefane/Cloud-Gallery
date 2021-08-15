import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/data/mappers/mappers.dart';
import 'package:moor/moor.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:injectable/injectable.dart';

// TODO(abd): IOS required change prefix
String getDiskPrefix() {
  return '/storage/emulated/0/';
}

@singleton
class BackupMapper extends Mapper<AssetEntity, BackupsCompanion> {
  @override
  Future<BackupsCompanion> map(AssetEntity from) => Future.value(from.toEntry());
}

extension AssetEntityExt on AssetEntity {
  Future<BackupsCompanion> toEntry() async => BackupsCompanion(
        assetId: Value(id),
        mime: Value(mimeType ?? ''),
        path: Value(getDiskPrefix() + relativePath! + title!),
        thumbData: Value((await thumbData)!),
        title: Value(title),
      );
}
