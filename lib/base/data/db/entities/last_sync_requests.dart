import 'package:moor/moor.dart';

import 'graduate_entity.dart';

class LastSyncRequests extends GraduateEntity with PrimaryKeyMixin {
  DateTimeColumn get lastSyncDate => dateTime().nullable()();
}
