import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:injectable/injectable.dart';

@injectable
class DatabaseTransactionRunner {
  DatabaseTransactionRunner(this.db);
  final GraduateDB db;
  Future<void> call<T>(Future<T> Function() action) async {
    return await db.transaction(action);
  }
}
