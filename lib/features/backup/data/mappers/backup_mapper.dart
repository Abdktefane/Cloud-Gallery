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
  Future<BackupsCompanion> toEntry() async {
    late final Uint8List thumpFuture;
    try {
      thumpFuture = (await thumbDataWithSize(50, 50, quality: 40)) ?? Uint8List(1);
    } catch (ex) {
      thumpFuture = Uint8List(1);
    }
    return BackupsCompanion(
      assetId: Value(id),
      mime: Value(mimeType ?? ''),
      path: Value(getDiskPrefix() + relativePath! + title!),
      thumbData: Value(thumpFuture),
      title: Value(title),
    );
  }
}
