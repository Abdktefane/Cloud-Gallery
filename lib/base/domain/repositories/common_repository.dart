import 'package:core_sdk/data/repositories/base_repository.dart';
import 'package:graduation_project/base/data/datasources/common_datasource.dart';

abstract class CommonRepository extends BaseRepository {
  const CommonRepository(CommonDataSource commonDataSource) : super(commonDataSource);
}
