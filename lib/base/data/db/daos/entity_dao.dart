import 'package:graduation_project/base/data/db/entities/graduate_entity.dart';
import 'package:moor/moor.dart';

abstract class EntityDao<T extends GraduateEntity, D extends DataClass, DB extends GeneratedDatabase>
    extends DatabaseAccessor<DB> {
  EntityDao(DB db, this._table) : super(db);

  final TableInfo<T, D> _table;

  Expression<int> get idColumn => _table.columnsByName['id'] as Expression<int>;

  Future<D> getById(int id) => (select(_table)..where((_) => idColumn.equals(id))).getSingle();

  Future<List<D>> getAll() => select(_table).get();

  Stream<D> observeById(int id) => (select(_table)..where((_) => idColumn.equals(id))).watchSingle();

  Stream<List<D>> observeAll() => select(_table).watch();

  Future<int> insert(Insertable<D> entry) => into(_table).insert(entry);

  Future<void> insertAll(List<Insertable<D>> entries) async => batch((Batch batch) => batch.insertAll(_table, entries));

  Future<bool> updateByEntry(Insertable<D> entry) => update(_table).replace(entry);

  Future<int> upsert(Insertable<D> entry) => into(_table).insertOnConflictUpdate(entry);

  Future<void> upsertAll(List<Insertable<D>> entries) async =>
      batch((Batch batch) => batch.insertAllOnConflictUpdate(_table, entries));

  Future<int> deleteById(int id) => (delete(_table)..where((T tbl) => idColumn.equals(id))).go();

  Future<int> deleteAll() => delete(_table).go();
}
