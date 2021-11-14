import 'package:graduation_project/base/data/db/entities/graduate_entity.dart';
import 'package:moor/moor.dart';

class Tokens extends GraduateEntity with PrimaryKeyMixin {
  TextColumn get token => text()();
}
