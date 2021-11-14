import 'package:graduation_project/base/data/datasources/common_datasource.dart';
import 'package:graduation_project/base/domain/repositories/base_repository.dart';

abstract class CommonRepository extends BaseRepository {
  const CommonRepository(CommonDataSource commonDataSource) : super(commonDataSource);
}
