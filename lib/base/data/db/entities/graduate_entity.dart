import 'package:moor/moor.dart';

abstract class GraduateEntity extends Table {
  // IntColumn get id => integer().autoIncrement().withDefault(const Constant(0))();
}

mixin PrimaryKeyMixin on GraduateEntity {
  IntColumn get id => integer().autoIncrement().withDefault(const Constant(0))();
}

// mixin RemoteIdEntity on GymZoneEntity {
//   TextColumn get remoteId => text().named('_id').nullable()();
// }

// mixin LanguageEntity on GymZoneEntity {
//   TextColumn get englishName => text().named('en_name')();
//   TextColumn get arabicName => text().named('ar_name')();
// }
