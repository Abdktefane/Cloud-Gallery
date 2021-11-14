import 'package:graduation_project/features/backup/networking/base_isolate_datasource.dart';
import 'package:graduation_project/features/backup/networking/networking_isolator.dart';

abstract class GraduateDataSource extends BaseIsolateDataSourceImpl {
  const GraduateDataSource(NetworkIsolate client) : super(client);

  @override
  Map<String, dynamic> wrapWithBaseData(data) {
    return data;
  }
}
