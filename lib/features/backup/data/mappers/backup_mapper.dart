import 'package:graduation_project/base/data/db/entities/backups.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:graduation_project/base/data/mappers/mappers.dart';
import 'package:graduation_project/base/domain/repositories/prefs_repository.dart';
import 'package:moor/moor.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:injectable/injectable.dart';
import 'package:device_info_plus/device_info_plus.dart';

// TODO(abd): IOS required change prefix
String getDiskPrefix() {
  return '/storage/emulated/0/';
}

@singleton
class BackupMapper extends Mapper<AssetEntity, BackupsCompanion> {
  BackupMapper(this._prefsRepository);

  final PrefsRepository _prefsRepository;

  @override
  Future<BackupsCompanion> map(AssetEntity from) => Future.value(from.toEntry(_prefsRepository.siteId!));
}

extension AssetEntityExt on AssetEntity {
  Future<BackupsCompanion> toEntry(int userId) async {
    late final Uint8List thumpFuture;
    try {
      thumpFuture = (await thumbData) ?? Uint8List(1);
      // thumpFuture = (await thumbDataWithSize(50, 50, quality: 40)) ?? Uint8List(1);
    } catch (ex) {
      thumpFuture = Uint8List(1);
    }
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    return BackupsCompanion(
      id: Value((deviceInfo.androidId ?? '') + id + userId.toString()),
      path: Value(getDiskPrefix() + relativePath! + title!),
      thumbData: Value(thumpFuture),
      title: Value(title),
      createdDate: Value(createDateTime),
      // status: const Value(BackupStatus.PENDING),
      needRestore: const Value(false),
    );
  }
}
