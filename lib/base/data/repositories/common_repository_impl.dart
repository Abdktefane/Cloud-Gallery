import 'package:graduation_project/base/data/datasources/common_datasource.dart';
import 'package:graduation_project/base/domain/repositories/common_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CommonRepository)
class CommonRepositoryImpl extends CommonRepository {
  const CommonRepositoryImpl(this.commonDataSource) : super(commonDataSource);
  final CommonDataSource commonDataSource;
}
