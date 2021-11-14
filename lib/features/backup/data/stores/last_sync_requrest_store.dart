import 'package:core_sdk/utils/extensions/list.dart';
import 'package:graduation_project/base/data/db/daos/entity_dao.dart';
import 'package:graduation_project/base/data/db/entities/last_sync_requests.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:injectable/injectable.dart';
import 'package:moor/moor.dart';

part 'last_sync_requrest_store.g.dart';

abstract class LastSyncRequestStore {
  Future<LastSyncRequest?> getlastSyncRequest();
  Future<int> saveLastSync(LastSyncRequestsCompanion dateTime);
}

@Singleton(as: LastSyncRequestStore)
@UseDao(tables: <Type>[LastSyncRequests])
class LastSyncRequestStoreImpl extends EntityDao<LastSyncRequests, LastSyncRequest, GraduateDB>
    with _$LastSyncRequestStoreImplMixin
    implements LastSyncRequestStore {
  LastSyncRequestStoreImpl(GraduateDB db) : super(db, db.lastSyncRequests);

  @override
  Future<LastSyncRequest?> getlastSyncRequest() async {
    final List<LastSyncRequest> rows = await getAll();
    if (rows.isNullOrEmpty) {
      return null;
    }
    return rows.first;
  }

  @override
  Future<int> saveLastSync(LastSyncRequestsCompanion dateTime) async {
    await deleteAll();
    return insert(dateTime);
  }
}
